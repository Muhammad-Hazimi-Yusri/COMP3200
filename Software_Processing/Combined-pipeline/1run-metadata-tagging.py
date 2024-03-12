import requests
import json
import os
import piexif
import subprocess
import shlex
import cv2

samples_path = "Samples-testing-8-march/"

def make_prediction_request(file_path):
    url = "http://localhost:5000/model/predict"
    files = {'image': open(file_path, 'rb')}
    headers = {'accept': 'application/json'}
    response = requests.post(url, files=files, headers=headers)
    print(response.json)
        # Write prediction to JSON file
    prediction_json_path = os.path.splitext(file_path)[0] + "_prediction.json"
    with open(prediction_json_path, 'w') as json_file:
        json.dump(response.json(), json_file, indent=4)
    
    return response.json()

def update_image_metadata(image_path, prediction):
    try:
        exif_data = piexif.load(image_path)
    except FileNotFoundError:
        print(f"Image file not found: {image_path}")
        return
    except piexif.InvalidImageDataError:
        print(f"Invalid image data: {image_path}")
        return

    label = prediction["predictions"][0]["label"]
    probability = prediction["predictions"][0]["probability"]
    description = f"{label} ({probability:.2f})"
    exif_data['0th'][piexif.ImageIFD.ImageDescription] = description.encode('utf-8')
    exif_bytes = piexif.dump(exif_data)

    try:
        piexif.insert(exif_bytes, image_path)
        print(f"Image description updated successfully: {image_path}")
    except Exception as e:
        print(f"Error updating image description for {image_path}: {e}")

def update_video_metadata(video_path, prediction_list):
    cap = cv2.VideoCapture(video_path)
    fps = cap.get(cv2.CAP_PROP_FPS)
    total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
    duration = total_frames / fps

    if duration > 30:
        print(f"Video duration exceeds 30 seconds for {video_path}. Processing the first 30 seconds.")
        total_frames = int(fps * 30)

    frame_indices = [int(total_frames * i / 5) for i in range(5)]
    predictions = []

    for idx in frame_indices:
        cap.set(cv2.CAP_PROP_POS_FRAMES, idx)
        ret, frame = cap.read()
        if ret:
            temp_file = f"temp_{idx}.jpg"
            cv2.imwrite(temp_file, frame)
            prediction = make_prediction_request(temp_file)
            # Write prediction to JSON file
            prediction_json_path =  os.path.splitext(video_path)[0] + f"_prediction{idx}.json"
            with open(prediction_json_path, 'w') as json_file: # append instead of overwriting
                json.dump(prediction, json_file, indent=4)
    

            label = prediction["predictions"][0]["label"]
            probability = prediction["predictions"][0]["probability"]
            description = f"{label} ({probability:.2f})"
            predictions.append(description)
            os.remove(temp_file)

    cap.release()

    description = ', '.join(predictions)
    metadata_cmd = f"ffmpeg -i {shlex.quote(video_path)} -metadata description={shlex.quote(description)} -codec copy output.mkv"
    try:
        subprocess.run(shlex.split(metadata_cmd), check=True)
        os.replace('output.mkv', video_path)
        print(f"Video description updated successfully: {video_path}")
    except subprocess.CalledProcessError as e:
        print(f"Error updating video description for {video_path}: {e.output.decode()}")

def process_files(directory):
    for root, _, files in os.walk(directory):
        for file in files:
            file_path = os.path.join(root, file)
            file_extension = os.path.splitext(file_path)[1].lower()

            if file_extension == '.jpg':                
                print("current img: " + str(file_path))
                prediction = make_prediction_request(file_path)
                update_image_metadata(file_path, prediction)
            elif file_extension == '.mkv':
                update_video_metadata(file_path, None)
            else:
                print(f"Unsupported file type: {file_extension}")

# Process images in the 'images/img0' directory
process_files(samples_path+'images/img0')

# Process videos in the 'videos/vid0' directory
process_files(samples_path+'videos/vid0')