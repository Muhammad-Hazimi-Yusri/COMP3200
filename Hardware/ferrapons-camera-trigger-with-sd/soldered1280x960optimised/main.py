import time as utime
import busio
import board
import usb_cdc
from Arducam import *
from board import *
import os

import sdcardio
import storage

from digitalio import DigitalInOut, Direction, Pull

trigger = DigitalInOut(GP14)
trigger.direction = Direction.INPUT
trigger.pull = Pull.DOWN

path = '/sd/'
filename = 'test'
extension = '.jpg'

def get_filename():
    return path + filename + str(imageCounter) + extension

imageCounter = 0
mode = 0
start_capture = 0
stop_flag=0
once_number=128
value_command=0
flag_command=0
buffer=bytearray(once_number)
isCapturing = False

spi = busio.SPI(GP10, MOSI=GP11, MISO=GP12)
cs = GP13
sd = sdcardio.SDCard(spi, cs)

vfs = storage.VfsFat(sd)
storage.mount(vfs, '/sd')
with open(get_filename(), 'wb'):
    pass

mycam = ArducamClass(OV5642)
mycam.Camera_Detection()
mycam.Spi_Test()
mycam.Camera_Init()
utime.sleep(1)
mycam.set_format(JPEG)
mycam.OV5642_set_JPEG_size(OV5642_1280x960)
        
def get_still(mycam):
    once_number = 1024  # Increased buffer size for batch processing
    buffer = bytearray(once_number)
    count = 0
    finished = 0
    length = mycam.read_fifo_length()
    mycam.SPI_CS_LOW()
    mycam.set_fifo_burst()

    while finished == 0:
        remaining_bytes = min(once_number, length - count)
        mycam.spi.readinto(buffer, start=0, end=remaining_bytes)
        #print(str(count) + ' of ' + str(length))
        with open(get_filename(), 'ab') as fj:
            fj.write(buffer[:remaining_bytes])  # Write only the read bytes
        count += remaining_bytes
        
        if count >= length:
            print(str(count) + ' of ' + str(length))
            mycam.SPI_CS_HIGH()
            mycam.clear_fifo_flag()
            finished = 1

def capture_image():
    mycam.flush_fifo()
    mycam.clear_fifo_flag()
    mycam.start_capture()
    finished = 0
    while finished == 0:
        if mycam.get_bit(ARDUCHIP_TRIG, CAP_DONE_MASK) != 0:
            finished = get_still(mycam)
    print('Capture Finished!')
    print(get_filename())

# Open file outside the loop
with open(get_filename(), 'wb'):
    pass

# Main loop
while True:
    if not trigger.value:
        print("Triggered")
        if not isCapturing:
            isCapturing = True
            capture_image()
            imageCounter += 1
    else:
        isCapturing = False

    utime.sleep(0.1)



