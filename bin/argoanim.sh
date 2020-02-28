#!/bin/sh -e
cd $(dirname $0)
mkdir -p output
chmod 777 output
docker run --shm-size 1G --rm \
	-v $(pwd)/output:/output \
	timecut \
 timecut "https://spiddal.marine.ie/argos/" \
 --viewport=2000,1000 --fps=24 --duration=180 \
 --frame-cache --pix-fmt=yuv420p \
 --output=/output/argos.mp4 \
 -L "--no-sandbox --disable-dev-shm-usage --disable-gpu"

 
