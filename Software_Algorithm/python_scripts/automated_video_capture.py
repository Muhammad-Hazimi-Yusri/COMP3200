import subprocess
import time
from datetime import datetime

while True:
    # Generate timestamp for the filename
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    filename = f"video_{timestamp}.mkv"
    
    # Define the FFmpeg command with optimized settings
    command = f"ffmpeg -f v4l2 -framerate 24 -video_size 1280x720 -input_format mjpeg -i /dev/video0 -preset faster -pix_fmt yuv420p -t 30 {filename}"
    
    # Run the command using subprocess
    subprocess.call(command, shell=True)
    
    print("Automated recording started...")
    
    # Wait for 5 minutes before capturing the next video
    time.sleep(10)

