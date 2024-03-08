import subprocess
import time
from datetime import datetime
import os

# Create directories if they don't exist
video_dir = "videos"
image_dir = "images"
vid0_dir = os.path.join(video_dir, "vid0")
vid2_dir = os.path.join(video_dir, "vid2")
img0_dir = os.path.join(image_dir, "img0")
img2_dir = os.path.join(image_dir, "img2")
for dir_path in [video_dir, image_dir, vid0_dir, vid2_dir, img0_dir, img2_dir]:
    os.makedirs(dir_path, exist_ok=True)


while True:
    # Video recording every 5 minutes
    print("Starting automated recording for both webcams...")
    # Generate timestamp for the filename
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    
    # Define filenames for each webcam
    filename_vid0 = os.path.join(vid0_dir, f"video_vid0_{timestamp}.mkv")
    filename_vid2 = os.path.join(vid2_dir, f"video_vid2_{timestamp}.mkv")
    # Define the FFmpeg commands for each webcam with optimized settings
    command_vid0 = f"ffmpeg -f v4l2 -framerate 24 -video_size 1280x720 -input_format mjpeg -i /dev/video0 -preset ultrafast -pix_fmt yuv420p -t 30 {filename_vid0}"
    command_vid2 = f"ffmpeg -f v4l2 -framerate 24 -video_size 1280x720 -input_format mjpeg -i /dev/video2 -preset ultrafast -pix_fmt yuv420p -t 30 {filename_vid2}"
   
    # Run the commands using subprocess.Popen() to start each process
    process_cam0 = subprocess.Popen(command_vid0, shell=True)
    process_cam2 = subprocess.Popen(command_vid2, shell=True)
    
    print("Automated recording started for both webcams...")
    # Wait for both processes to finish
    process_cam0.wait()
    process_cam2.wait()
    
    print("Automated video recording completed for both webcams...")
    
    # Image capture every 10 seconds
    for j in range(30):  # 30 iterations = 5 minutes of images every 10 seconds
        # Generate timestamp for the filename
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        
        # Define filenames for each webcam
        filename_img0 = os.path.join(img0_dir, f"image_img0_{timestamp}.jpg")
        filename_img2 = os.path.join(img2_dir, f"image_img2_{timestamp}.jpg")
        
        # Define the FFmpeg commands for each webcam
        command_img0 = f"ffmpeg -f v4l2 -framerate 30 -ss 1 -video_size 1280x720 -input_format mjpeg -i /dev/video0 -vframes 1 {filename_img0}"
        command_img2 = f"ffmpeg -f v4l2 -framerate 30 -ss 1 -video_size 1280x720 -input_format mjpeg -i /dev/video2 -vframes 1 {filename_img2}"
        
        # Run the commands using subprocess.Popen() to capture images
        process_img0 = subprocess.Popen(command_img0, shell=True)
        process_img2 = subprocess.Popen(command_img2, shell=True)
        
        # Wait for both image capture processes to finish
        process_img0.wait()
        process_img2.wait()
        
        print("Automated image capture completed for both webcams...")
        
        time.sleep(10)  # Wait for 10 seconds before capturing the next set of images
        
    print("5 minutes completed. Restarting the automated recording process...")
