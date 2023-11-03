#!/bin/bash

input_file="input.mp4"
output_file="output.ogv"

ffmpeg -i "$input_file" -codec:v libtheora -qscale:v 10 -codec:a libvorbis -qscale:a 10 -f ogv "$output_file"
