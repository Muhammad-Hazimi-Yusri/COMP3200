import array
import board
from analogio import AnalogIn
import busio
import sdcardio
import storage
import time

# Constants
DC_OFFSET = 0  # DC offset in mic signal - if unsure, leave 0
NOISE = 300  # Noise/hum/interference in mic signal
SAMPLE_RATE = 8000  # Sample rate in Hz
SAMPLE_PERIOD = 1.0 / SAMPLE_RATE  # Sample period in seconds

# Global variables
lvl = 10  # Current "dampened" audio level

# Set up ADC
mic_pin = AnalogIn(board.A1)

# Set up SD card
spi = busio.SPI(board.GP10, MOSI=board.GP11, MISO=board.GP12)
cs = board.GP13
sdcard = sdcardio.SDCard(spi, cs)
vfs = storage.VfsFat(sdcard)
storage.mount(vfs, "/sd")
time.sleep(1)  # Add a delay after mounting the filesystem

# Record audio and save to SD card
with open("/sd/audio_data5.bin", "wb") as audio_file:
    try:
        while True:
            # Read ADC value (10-bit format)
            n = int((mic_pin.value / 65536) * 1024)

            # Remove DC offset and center on zero
            n = abs(n - 512 - DC_OFFSET)

            # Remove noise/hum
            if n < NOISE:
                n = 0
            else:
                n -= NOISE

            # "Dampened" reading (else looks twitchy)
            lvl = int(((lvl * 7) + n) / 8)

            # Convert 10-bit audio data to 16-bit
            n_16bit = n << 6  # Shift left by 6 bits

            # Write the 16-bit audio sample to the SD card
            audio_file.write(n_16bit.to_bytes(2, 'little'))

            print("Audio level:", lvl)
            print("N 16-bit:", n_16bit)
    
                
            # Delay for the sample period to set the sample rate
            time.sleep(SAMPLE_PERIOD)

    except KeyboardInterrupt:
        print("Recording stopped.")