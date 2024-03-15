import subprocess
import time
from datetime import datetime
import os

use_webcam = False  # Set this to True if you want to use a USB webcam

# Create directories if they don't exist
home_dir = "/home/chronohax/"
video_dir = home_dir + "videos"
image_dir = home_dir + "images"
vid0_dir = os.path.join(video_dir, "vid0")
vid2_dir = os.path.join(video_dir, "vid2")
img0_dir = os.path.join(image_dir, "img0")
img2_dir = os.path.join(image_dir, "img2")
for dir_path in [video_dir, image_dir, vid0_dir, vid2_dir, img0_dir, img2_dir]:
    os.makedirs(dir_path, exist_ok=True)

while True:
    # Video recording every 5 minutes
    print("Starting automated recording for both cameras...")
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")

    # Define filenames for each camera
    filename_vid0 = os.path.join(vid0_dir, f"video_vid0_{timestamp}")
    filename_vid2 = os.path.join(vid2_dir, f"video_vid2_{timestamp}")

    if use_webcam:
        # Define the FFmpeg commands for each USB webcam with optimized settings
        command_vid0 = f"ffmpeg -f v4l2 -framerate 24 -ss 1 -video_size 1280x720 -input_format mjpeg -i /dev/video0 -preset ultrafast -pix_fmt yuv420p -t 30 {filename_vid0}.mkv"
        command_vid2 = f"ffmpeg -f v4l2 -framerate 24 -ss 1 -video_size 1280x720 -input_format mjpeg -i /dev/video2 -preset ultrafast -pix_fmt yuv420p -t 30 {filename_vid2}.mkv"
    else:
        # Define the libcamera/rpicam commands for the Raspberry Pi camera
        command_vid0 = f"rpicam-vid --camera 0 --width 1920 --height 1080 --framerate 30 -t 30000 --codec mjpeg -o  {filename_vid0}.mjpeg"
        command_vid2 = f"rpicam-vid --camera 1 --width 1920 --height 1080 --framerate 30 -t 30000 --codec mjpeg -o  {filename_vid2}.mjpeg"

    # Run the commands using subprocess.Popen() to start each process
    process_cam0 = subprocess.Popen(command_vid0, shell=True)
    process_cam2 = subprocess.Popen(command_vid2, shell=True)
    print("Automated recording started for both cameras...")

    # Wait for both processes to finish
    process_cam0.wait()
    process_cam2.wait()
    print("Automated video recording completed for both cameras...")

    # Image capture every 10 seconds
    for j in range(2):  # 30 iterations = 5 minutes of images every 10 seconds
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")

        # Define filenames for each camera
        filename_img0 = os.path.join(img0_dir, f"image_img0_{timestamp}.jpg")
        filename_img2 = os.path.join(img2_dir, f"image_img2_{timestamp}.jpg")

        if use_webcam:
            # Define the FFmpeg commands for each USB webcam
            command_img0 = f"ffmpeg -f v4l2 -framerate 30 -ss 1 -video_size 1280x720 -input_format mjpeg -i /dev/video0 -vframes 1 {filename_img0}"
            command_img2 = f"ffmpeg -f v4l2 -framerate 30 -ss 1 -video_size 1280x720 -input_format mjpeg -i /dev/video2 -vframes 1 {filename_img2}"
        else:
            # Define the libcamera commands for the Raspberry Pi camera
            command_img0 = f"libcamera-still -o {filename_img0}"
            command_img2 = f"libcamera-still -o {filename_img2}"

        # Run the commands using subprocess.Popen() to capture images
        process_img0 = subprocess.Popen(command_img0, shell=True)
        process_img2 = subprocess.Popen(command_img2, shell=True)

        # Wait for both image capture processes to finish
        process_img0.wait()
        process_img2.wait()
        print("Automated image capture completed for both cameras...")

        time.sleep(10)  # Wait for 10 seconds before capturing the next set of images

    print("5 minutes completed. Restarting the automated recording process...")