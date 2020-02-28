#!/bin/sh -e
cd $(dirname $0)
mkdir -p output
chmod 777 output
rm -f output/oceans.mp4
docker run --shm-size 1G --rm \
	-v $(pwd)/output:/output \
	timecut \
ffmpeg -i /output/velocity.mp4 -i /output/argos.mp4 -filter_complex "[0:v:0][1:v:0]concat=n=2:v=1:a=0[outv]" -map "[outv]" /output/oceans.mp4
 
