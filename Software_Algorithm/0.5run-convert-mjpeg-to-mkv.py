import os
import subprocess

samples_path = "raspi-cam-3-test-15-march/"

def convert_mjpeg_to_mkv(input_dir):
    # Iterate over the video files in the input directory
    for filename in os.listdir(input_dir):
        if filename.endswith(".mjpeg"):
            # Get the input video path
            input_path = os.path.join(input_dir, filename)

            # Check if the input video exists
            if not os.path.exists(input_path):
                print(f"Input video file not found: {input_path}")
                continue

            # Define the output video path
            output_path = os.path.join(input_dir, f"{os.path.splitext(filename)[0]}.mkv")

            # Define the ffmpeg command to convert the video
            ffmpeg_command = [
                "ffmpeg",
                "-i", input_path,  # Input video file
                "-c:v", "copy",  # Copy video stream without re-encoding
                "-r", "30",  # Set the output framerate to 30 fps
                "-f", "matroska",  # Output format: Matroska (MKV)
                "-y",  # Overwrite output file without asking
                output_path
            ]

            # Run ffmpeg command
            try:
                subprocess.run(ffmpeg_command, check=True)
                print(f"Video converted successfully: {output_path}")
                # Remove the original .mjpeg file
                os.remove(input_path)
                print(f"Removed original file: {input_path}")
            except subprocess.CalledProcessError as e:
                print(f"Error converting video: {e}")

# Specify the paths to the vid0 and vid2 directories
vid0_dir = samples_path + "videos/vid0"
vid2_dir = samples_path + "videos/vid2"

# Call the conversion function for both directories
convert_mjpeg_to_mkv(vid0_dir)
convert_mjpeg_to_mkv(vid2_dir)