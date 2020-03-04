#!/bin/sh -e

VIDEO_DURATION_SECONDS=120
#VIDEO_DURATION_SECONDS=5

basedir=$(realpath $(dirname $0)/..)

#
# update data
#
$basedir/bin/fetch_data.sh

#
# Start the nginx container
# bring it down at the end
htmldir=$basedir/html
datadir=$basedir/data
nginx=$(docker run -d --rm -v $htmldir:/usr/share/nginx/html/argos:ro -v $datadir:/usr/share/nginx/html/data:ro nginx)
trap "docker stop $nginx" EXIT

# Map the nginx container so we can use the
# content
nginxip=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $nginx)
output=$basedir/output
mkdir -p $output
chmod 777 $output
docker run --add-host=nginx:$nginxip --shm-size 1G --rm \
	-v $output:/output \
	timecut \
 timecut "http://nginx/argos/" \
 --viewport=2000,1000 --fps=24 --duration=$VIDEO_DURATION_SECONDS \
 --frame-cache --pix-fmt=yuv420p \
 --output=/output/argos.mp4 \
 -L "--no-sandbox --disable-dev-shm-usage --disable-gpu"

echo "all done, content is in the output folder"
 
