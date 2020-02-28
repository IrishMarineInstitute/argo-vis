#!/bin/bash -e
cd $(dirname $0)
mkdir -p output
chmod 777 output
for item in argos #oceans velocity argos
do
  rm -f output/${item}-scaled.mp4
  docker run --shm-size 1G --rm \
	-v $(pwd)/output:/output \
	timecut \
	ffmpeg -i /output/$item.mp4 -vf scale=512:256 /output/$item-scaled.mp4
done
 
