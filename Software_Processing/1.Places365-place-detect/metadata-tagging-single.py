import requests
import json
import os
import piexif

def make_prediction_request(image_path):
    url = "http://localhost:5000/model/predict"
    files = {'image': open(image_path, 'rb')}
    headers = {'accept': 'application/json'}
    response = requests.post(url, files=files, headers=headers)
    return response.json()

def update_description(image_path, prediction):
    # Load existing metadata from the image
    try:
        exif_data = piexif.load(image_path)
    except FileNotFoundError:
        print("Image file not found.")
        return
    except piexif.InvalidImageDataError:
        print("Invalid image data.")
        return

    # Extract the label with the highest probability from the prediction
    label = prediction["predictions"][0]["label"]

    # Update or add the description tag
    exif_data['0th'][piexif.ImageIFD.ImageDescription] = label.encode('utf-8')

    # Convert the modified metadata dictionary back to bytes
    exif_bytes = piexif.dump(exif_data)

    # Write the modified metadata back to the image file
    try:
        piexif.insert(exif_bytes, image_path)
        print("Description updated successfully.")
        print("Prediction is "+ str(label))
        print("Updated image description is " + str(exif_data['0th'][piexif.ImageIFD.ImageDescription]))
    except Exception as e:
        print(f"Error updating description: {e}")

# Path to the JPEG image file
image_path = "IMG_0061.jpeg"

# Make prediction request
prediction = make_prediction_request(image_path)

# Update description based on the prediction
update_description(image_path, prediction)
