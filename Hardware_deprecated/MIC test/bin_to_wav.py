import array
import os

# Parameters (adjust these based on your recording settings)
sample_rate = 8000  # Example: 44.1 kHz
bit_depth = 16       # Example: 16 bits per sample
num_channels = 1     # Mono audio
input_file = "audio_data5.bin"
output_file = "output5.wav"

# Function to create a WAV header
def create_wav_header(sample_rate, bit_depth, num_channels, num_samples):
    byte_rate = sample_rate * num_channels * bit_depth // 8
    block_align = num_channels * bit_depth // 8
    data_size = num_samples * block_align
    file_size = data_size + 36

    header = bytes([
        ord('R'), ord('I'), ord('F'), ord('F'),
        file_size & 0xff, (file_size >> 8) & 0xff, (file_size >> 16) & 0xff, (file_size >> 24) & 0xff,
        ord('W'), ord('A'), ord('V'), ord('E'),
        ord('f'), ord('m'), ord('t'), ord(' '),
        16, 0, 0, 0,  # Subchunk1Size is 16
        1, 0,  # PCM is format 1
        num_channels, 0,  # Mono = 1, Stereo = 2, etc.
        sample_rate & 0xff, (sample_rate >> 8) & 0xff, (sample_rate >> 16) & 0xff, (sample_rate >> 24) & 0xff,
        byte_rate & 0xff, (byte_rate >> 8) & 0xff, (byte_rate >> 16) & 0xff, (byte_rate >> 24) & 0xff,
        block_align, 0,  # Block align
        bit_depth, 0,  # Bits per sample
        ord('d'), ord('a'), ord('t'), ord('a'),
        data_size & 0xff, (data_size >> 8) & 0xff, (data_size >> 16) & 0xff, (data_size >> 24) & 0xff
    ])

    return header
# Read raw binary data from the file
with open(input_file, "rb") as bin_file:
    raw_data = bin_file.read()

# Convert binary data to a Python array of 8-bit unsigned integers
audio_data_8bit = array.array('B', raw_data)

# Convert 8-bit audio data to 16-bit
audio_data_16bit = array.array('h', [(sample - 128) << 8 for sample in audio_data_8bit])

# Calculate the number of samples
num_samples = len(audio_data_16bit)

# Create a WAV header
wav_header = create_wav_header(sample_rate, bit_depth, num_channels, num_samples)

# Write the WAV header and audio data to the output file
with open(output_file, "wb") as wav_file:
    wav_file.write(wav_header)
    wav_file.write(audio_data_16bit.tobytes())