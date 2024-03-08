import subprocess
import time
from datetime import datetime

while True:
    # Generate timestamp for the filename
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    
    # Define filenames for each webcam
    filename_cam0 = f"video_cam0_{timestamp}.mkv"
    filename_cam2 = f"video_cam2_{timestamp}.mkv"
    
    # Define the FFmpeg commands for each webcam with optimized settings
    command_cam0 = f"ffmpeg -f v4l2 -framerate 15 -video_size 1280x720 -input_format mjpeg -i /dev/video0 -preset faster -pix_fmt yuv420p -t 20 {filename_cam0}"
    command_cam2 = f"ffmpeg -f v4l2 -framerate 15 -video_size 1280x720 -input_format mjpeg -i /dev/video2 -preset faster -pix_fmt yuv420p -t 20 {filename_cam2}"
    
    # Run the commands using subprocess.Popen() to start each process
    process_cam0 = subprocess.Popen(command_cam0, shell=True)
    process_cam2 = subprocess.Popen(command_cam2, shell=True)
    
    # Wait for both processes to finish
    process_cam0.wait()
    process_cam2.wait()
    
    print("Automated recording started for both webcams...")
    
    # Wait for 5 minutes before capturing the next set of videos
    time.sleep(10)
