import os
import json
from collections import Counter

def analyze_json_files(directory):
    prediction_counts = Counter()

    # Traverse through the directory and its subdirectories
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith(".json"):
                file_path = os.path.join(root, file)
                with open(file_path, 'r') as f:
                    try:
                        data = json.load(f)
                        if 'predictions' in data:
                            predictions = data['predictions']
                            for prediction in predictions:
                                label = prediction.get('label')
                                prediction_counts[label] += 1
                        #else: # i think this is irrelevant and never runs anymore as I created multiple .json file for videos frames instead
                        #    # Different format for videos.json 
                        #    for label in data:
                        #        prediction_counts[label['label']] += 1
                    except json.JSONDecodeError:
                        print(f"Error decoding JSON file: {file_path}")

    return prediction_counts

def write_analysis_to_file(prediction_counts, output_file):
    with open(output_file, 'w') as f:
        for label, count in prediction_counts.most_common():
            f.write(f"{label}: {count}\n")

# Define the path to the directory containing JSON files
samples_path = "input/output"

# Analyze JSON files in the images directory
images_directory = os.path.join(samples_path, "images")
image_prediction_counts = analyze_json_files(images_directory)

# Analyze JSON files in the videos directory
videos_directory = os.path.join(samples_path, "videos")
video_prediction_counts = analyze_json_files(videos_directory)

# Merge prediction counts from both directories
total_prediction_counts = image_prediction_counts + video_prediction_counts

# Write analysis to output files for images and videos respectively
image_output_analysis_file = os.path.join(images_directory, "image_output_json_analysis.txt")
write_analysis_to_file(image_prediction_counts, image_output_analysis_file)

video_output_analysis_file = os.path.join(videos_directory, "video_output_json_analysis.txt")
write_analysis_to_file(video_prediction_counts, video_output_analysis_file)

print(f"Image analysis written to {image_output_analysis_file}")
print(f"Video analysis written to {video_output_analysis_file}")
