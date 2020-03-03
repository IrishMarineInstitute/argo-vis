#!/bin/sh
set -e
mkdir -p data
cp $(dirname $0)/crawler.py data/crawler.py
docker run -i -t --rm -v $(pwd)/data:/data sharedcloud/web-crawling-python36 python3 /data/crawler.py
rm data/crawler.py
cat data/????-??-??.txt > data/profiles.txt
echo ">>> data updated"

