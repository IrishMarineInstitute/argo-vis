#!/bin/bash -e

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

url='http://nginx/argos/#stillwhite'
docker run --add-host=nginx:$nginxip --shm-size 1G --rm \
	-v $output:/output \
	timecut \
 timecut "${url}" \
 --viewport=2000,1000 --fps=30 --duration=$VIDEO_DURATION_SECONDS \
 --frame-cache --pix-fmt=yuv420p \
 --output-options="-c:v hap -format hap_alpha" \
 --output=/output/argos.mov \
 -L "--no-sandbox --disable-dev-shm-usage --disable-gpu"

docker run --add-host=nginx:$nginxip --shm-size 1G --rm \
	-v $output:/output \
	timecut \
 timecut "http://nginx/argos/" \
 --viewport=2000,1000 --fps=30 --duration=$VIDEO_DURATION_SECONDS \
 --frame-cache --pix-fmt=yuv420p \
 --output=/output/argos.mp4 \
 -L "--no-sandbox --disable-dev-shm-usage --disable-gpu"

echo "videos done, now creating scaled versions"
for item in argos
do
  rm -f ${basedir}/output/${item}-scaled.mp4
  docker run --shm-size 1G --rm \
	-v ${basedir}/output:/output \
	timecut \
	ffmpeg -i /output/$item.mp4 -vf scale=512:256 /output/$item-scaled.mp4
done
date=$(date)
cat>$basedir/output/index.html<<EOF
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Argo Animation Videos</title>
  <meta name="description" content="Argo Animation">
  <meta name="author" content="Marine Institute">
</head>
<body>
<h1>Argo Animation Videos</h1>
<p>These videos were generated $date using the <a href="https://github.com/IrishMarineInstitute/argo-vis">argo-vis project</a> on github.</p>
<h2>With Map</h2>
<p><a href="argos.mp4">argos.mp4</a>
<p><a href="argos-scaled.mp4">argos-scaled.mp4</a>

<h2>Without Map (hap format)</h2>
<p><a href="argos.mov">argos.mov</a>
</body>
</html>
EOF

echo "all done, content is in the output folder"
 
