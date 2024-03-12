import os
import re
import shutil

samples_path = "Samples-testing-8-march"
output_path = "output"

# Function to convert filenames
def convert_filename(filename):
    match = re.match(r'^(image|video)_\w+_(\d{8}_\d{6})_prediction(\d+)?\.json$', filename)
    if match:
        prefix = "stitched_image" if match.group(1) == "image" else "stitched_video"
        frame_number = match.group(3) if match.group(3) else ""
        return f"{prefix}_{match.group(2)}_prediction{frame_number}.json"
    else:
        return filename  # Default behavior, returning the same filename if not matching the pattern

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
    for src_file in json_files:
        filename = os.path.basename(src_file)
        new_filename = convert_filename(filename)
        dest_file = os.path.join(dest_dir, new_filename)
        os.makedirs(os.path.dirname(dest_file), exist_ok=True)
        shutil.copy(src_file, dest_file)

# Join current directory to output paths
samples_output_path = os.path.join(samples_path, output_path)

# Copy, rename, and move image files
process_files(os.path.join(samples_path, 'images', 'img0'), os.path.join(samples_output_path, 'images'))

# Copy, rename, and move video files
process_files(os.path.join(samples_path, 'videos', 'vid0'), os.path.join(samples_output_path, 'videos'))
