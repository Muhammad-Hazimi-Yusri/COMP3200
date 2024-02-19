import board
import busio
import sdcardio
import storage

# Use the board's primary SPI bus
#spi = board.SPI()

# Or, use an SPI bus on specific pins: #GP10 is SCK
spi = busio.SPI(board.GP10, MOSI=board.GP11, MISO=board.GP12)

# For breakout boards, you can choose any GPIO pin that's convenient:
cs = board.GP13
# Boards with built in SPI SD card slots will generally have a
# pin called SD_CS:
#cs = board.SD_CS

sdcard = sdcardio.SDCard(spi, cs)
vfs = storage.VfsFat(sdcard)

storage.mount(vfs, "/sd")

with open("/sd/test.txt", "w") as f:
    f.write("Hello world!\r\n")
    
with open("/sd/test.txt", "r") as f:
    print("Read line from file:")
    print(f.readline(), end='')
