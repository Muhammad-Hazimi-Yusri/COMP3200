import os
import subprocess

def stitch_videos(video1_path, video2_path, output_path):
    # Check if the input videos exist
    if not os.path.exists(video1_path) or not os.path.exists(video2_path):
        print("Input video files not found.")
        return

    # Create the output directory if it doesn't exist
    output_dir = os.path.dirname(output_path)
    if not os.path.exists(output_dir):
        try:
            os.makedirs(output_dir)
        except OSError as e:
            print(f"Error creating output directory: {e}")
            return

    # Define the ffmpeg command to stitch the videos side by side
    ffmpeg_command = [
        "ffmpeg",
        "-i", video1_path,
        "-i", video2_path,
        "-filter_complex", "[0:v][1:v]hstack=inputs=2",
        "-c:v", "libx264",
        "-preset", "fast",
        "-crf", "23",
        "-an",  # Disable audio
        "-y",  # Overwrite output file without asking
        output_path
    ]

    # Run ffmpeg command
    try:
        subprocess.run(ffmpeg_command, check=True)
        print("Videos stitched successfully.")
    except subprocess.CalledProcessError as e:
        print(f"Error stitching videos: {e}")

if __name__ == "__main__":
    # Paths to input videos and output stitched video
    video1_path = "video_cam0_20240307_213710.mkv"
    video2_path = "video_cam2_20240307_213710.mkv"
    output_dir = "output"
    output_path = os.path.join(output_dir, "stitched_output.mp4")

    # Stitch the videos
    stitch_videos(video1_path, video2_path, output_path)
