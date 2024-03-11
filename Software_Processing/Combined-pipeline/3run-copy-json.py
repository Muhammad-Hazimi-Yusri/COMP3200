import os
import re
import shutil

samples_path = "Samples-testing-8-march"
output_path = "output"

# Function to convert filenames
def convert_filename(filename):
    match = re.match(r'^(image|video)_(\w+)_(\d{8}_\d{6})_prediction\.json$', filename)
    if match:
        prefix = "stitched_image" if match.group(1) == "image" else "stitched_video"
        return f"{prefix}_{match.group(2)}_{match.group(3)}_prediction.json"
    else:
        return filename

# Function to find all JSON files in a directory
def find_json_files(directory):
    json_files = []
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.json'):
                json_files.append(os.path.join(root, file))
    return json_files

# Function to copy, rename, and move files
def process_files(src_dir, dest_dir):
    json_files = find_json_files(src_dir)
    print(src_dir)
    for src_file in json_files:
        filename = os.path.basename(src_file)
        new_filename = convert_filename(filename)
        dest_file = os.path.join(dest_dir, new_filename)
        os.makedirs(os.path.dirname(dest_file), exist_ok=True)
        shutil.copy(src_file, dest_file)

# Join current directory to output paths
#output_path = os.path.join(os.getcwd(), output_path)

# Copy, rename, and move image files
process_files(os.path.join(samples_path, 'images', 'img0'), os.path.join(samples_path, output_path, 'images'))

# Copy, rename, and move video files
process_files(os.path.join(samples_path, 'videos', 'vid0'), os.path.join(samples_path, output_path, 'videos'))

print("Copy Finished!")