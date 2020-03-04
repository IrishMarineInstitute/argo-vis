#!/bin/bash -e
basedir=$(realpath $(dirname $0)/..)
mkdir -p output
chmod 777 output
for item in argos argosk #oceans velocity argos
do
  rm -f ${basedir}/output/${item}-scaled.mp4
  docker run --shm-size 1G --rm \
	-v ${basedir}/output:/output \
	timecut \
	ffmpeg -i /output/$item.mp4 -vf scale=512:256 /output/$item-scaled.mp4
done
 
