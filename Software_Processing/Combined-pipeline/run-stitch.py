import os
import subprocess
from datetime import datetime
import piexif
from PIL import Image

samples_path = "Samples-testing-8-march"

def stitch_videos(output_dir):
    # Create the output directory if it doesn't exist
    output_video_dir = os.path.join(output_dir, "videos")
    if not os.path.exists(output_video_dir):
        os.makedirs(output_video_dir)

    # Iterate over the video files in the vid0 and vid2 subdirectories
    vid0_dir = os.path.join(samples_path, "videos", "vid0")
    vid2_dir = os.path.join(samples_path, "videos", "vid2")
    for filename in os.listdir(vid0_dir):
        if filename.endswith(".mkv"):
            # Get the input video paths
            vid0_path = os.path.join(vid0_dir, filename)
            vid2_path = os.path.join(vid2_dir, filename.replace('_vid0', '_vid2'))

            # Check if the input videos exist
            if not os.path.exists(vid0_path) or not os.path.exists(vid2_path):
                print(f"Input video files not found for {filename}")
                continue

            # Define the output video path
            output_path = os.path.join(output_video_dir, f"stitched_{filename.replace('_vid0', '').replace('_vid2', '')}")

            # Define the ffmpeg command to stitch the videos side by side
            ffmpeg_command = [
                "ffmpeg",
                "-i", vid0_path,
                "-i", vid2_path,
                "-filter_complex", "[0:v][1:v]hstack=inputs=2",
                "-c:v", "libx264",
                "-preset", "fast",
                "-crf", "23",
                "-an",  # Disable audio
                "-map_metadata", "0:g:0",  # Copy metadata from the first input file
                "-y",  # Overwrite output file without asking
                output_path
            ]

            # Run ffmpeg command
            try:
                subprocess.run(ffmpeg_command, check=True)
                print(f"Videos stitched successfully: {output_path}")
            except subprocess.CalledProcessError as e:
                print(f"Error stitching videos: {e}")

def stitch_images(output_dir):
    # Create the output directory if it doesn't exist
    output_image_dir = os.path.join(output_dir, "images")
    if not os.path.exists(output_image_dir):
        os.makedirs(output_image_dir)

    # Iterate over the image files in the img0 and img2 subdirectories
    img0_dir = os.path.join(samples_path, "images", "img0")
    img2_dir = os.path.join(samples_path, "images", "img2")
    for filename in os.listdir(img0_dir):
        if filename.endswith(".jpg"):
            # Get the input image paths
            img0_path = os.path.join(img0_dir, filename)
            img2_path = os.path.join(img2_dir, filename.replace('_img0', '_img2'))

            # Check if the input images exist
            if not os.path.exists(img0_path) or not os.path.exists(img2_path):
                print(f"Input image files not found for {filename}")
                continue

            # Define the output image path
            output_path = os.path.join(output_image_dir, f"stitched_{filename.replace('_img0', '').replace('_img2', '')}")

            # Load input images
            img0 = Image.open(img0_path)
            img2 = Image.open(img2_path)

            # Get the width and height of the input images
            width1, height1 = img0.size
            width2, height2 = img2.size

            # Create a new blank image with the combined width
            result_width = width1 + width2
            result_height = max(height1, height2)
            result = Image.new('RGB', (result_width, result_height))

            # Paste the input images side by side
            result.paste(img0, (0, 0))
            result.paste(img2, (width1, 0))

            # Load metadata from the first input image
            try:
                exif_data = piexif.load(img0_path)
            except FileNotFoundError:
                print(f"Image file not found: {img0_path}")
                continue
            except piexif.InvalidImageDataError:
                print(f"Invalid image data: {img0_path}")
                continue

            # Save the stitched image with the copied metadata
            try:
                exif_bytes = piexif.dump(exif_data)
                result.save(output_path, exif=exif_bytes)
                print(f"Images stitched successfully: {output_path}")
            except Exception as e:
                print(f"Error stitching images: {e}")

if __name__ == "__main__":
    # Path to output directory
    output_dir = "output"

    # Stitch videos
    stitch_videos(output_dir)

    # Stitch images
    stitch_images(output_dir)