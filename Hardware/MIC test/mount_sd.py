import board
import busio
import sdcardio
import storage
import array
import time

# Use the board's primary SPI bus
#spi = board.SPI()

# Or, use an SPI bus on specific pins: #GP10 is SCK
spi = busio.SPI(board.GP10, MOSI=board.GP11, MISO=board.GP12)

# For breakout boards, you can choose any GPIO pin that's convenient:
cs = board.GP13
# Boards with built-in SPI SD card slots will generally have a
# pin called SD_CS:
#cs = board.SD_CS

sdcard = sdcardio.SDCard(spi, cs)
vfs = storage.VfsFat(sdcard)

storage.mount(vfs, "/sd")

# Create an array to store audio waveform data
audio_data = array.array('H', [0] * 1024)  # Adjust the size based on your requirements

# Write audio waveform data to the file
with open("/sd/audio_data.bin", "wb") as audio_file:
    # Replace this loop with your actual audio data collection logic
    for i in range(len(audio_data)):
        # Simulated audio data (replace with your actual data source)
        sample_value = i % 4096
        audio_data[i] = sample_value
        audio_file.write(sample_value.to_bytes(2, 'little'))  # Assuming 16-bit audio, adjust accordingly

print("Audio data written to file.")

# Read audio waveform data from the file and print a few samples
with open("/sd/audio_data.bin", "rb") as audio_file:
    # Read and print the first few samples (adjust the range as needed)
    print("Read samples from file:")
    for i in range(10):
        sample_bytes = audio_file.read(2)
        sample_value = int.from_bytes(sample_bytes, 'little')
        print(sample_value)

# Add a delay to keep the program running for a while
time.sleep(5)
