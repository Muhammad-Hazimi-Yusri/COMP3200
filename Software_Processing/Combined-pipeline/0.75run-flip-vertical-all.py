import os
import subprocess

samples_path = "input/"

def rotate_files(input_dir):
    # Iterate over the files in the input directory
    for filename in os.listdir(input_dir):
        input_path = os.path.join(input_dir, filename)
        if filename.endswith(".mkv"):  # Check if the file is a video
            # Define the output video path
            output_path = os.path.join(input_dir, f"{os.path.splitext(filename)[0]}_rotated.mkv")

            # Define the ffmpeg command to rotate the video 180 degrees clockwise
            ffmpeg_command = [
                "ffmpeg",
                "-i", input_path,  # Input video file
                "-vf", "transpose=2,transpose=2",  # Rotate 180 degrees clockwise
                "-c:a", "copy",  # Copy audio stream without re-encoding
                "-y",  # Overwrite output file without asking
                output_path
            ]

            # Run ffmpeg command
            try:
                subprocess.run(ffmpeg_command, check=True)
                print(f"Video rotated successfully: {output_path}")
                # Remove the original video file
                os.remove(input_path)
                print(f"Removed original file: {input_path}")
                # Rename the rotated video to replace the original
                os.rename(output_path, os.path.join(input_dir, f"{os.path.splitext(filename)[0]}.mkv"))
                print(f"Renamed rotated file: {output_path} to {input_path}")
            except subprocess.CalledProcessError as e:
                print(f"Error rotating video: {e}")
                
        elif filename.endswith(".jpg"):  # Check if the file is an image
            # Define the output image path
            output_path = os.path.join(input_dir, f"{os.path.splitext(filename)[0]}.jpg")

            # Define the ffmpeg command to rotate the image 180 degrees clockwise
            ffmpeg_command = [
                "ffmpeg",
                "-i", input_path,  # Input image file
                "-vf", "transpose=2,transpose=2",  # Rotate 180 degrees clockwise
                "-y",  # Overwrite output file without asking
                output_path
            ]

            # Run ffmpeg command
            try:
                subprocess.run(ffmpeg_command, check=True)
                print(f"Image rotated successfully: {output_path}")
            except subprocess.CalledProcessError as e:
                print(f"Error rotating image: {e}")

# Specify the paths to the vid0 and vid2 directories
vid0_dir = samples_path + "videos/vid0"
vid2_dir = samples_path + "videos/vid2"
img0_dir = samples_path + "images/img0"
img2_dir = samples_path + "images/img2"

# Call the rotation function for all directories
rotate_files(vid0_dir)
rotate_files(vid2_dir)
rotate_files(img0_dir)
rotate_files(img2_dir)
