#!/bin/bash

set -e -x -v

apt update

echo "Configure stylesheets"
git clone https://github.com/gravitystorm/openstreetmap-carto.git
cd openstreetmap-carto
apt install -y npm nodejs-legacy
apt update
npm install -g carto
carto project.mml > mapnik.xml

echo "Load OSM data into postgresql"
mkdir ~/osmdata
cd ~/osmdata
wget http://download.geofabrik.de/asia/india-latest.osm.pbf # put data to download here
# osm2pgsql -d geospatial_user --create --slim -G --hstore --tag-transform-script openstreetmap-carto/openstreetmap-carto.lua -C 2500 --number-processes 1 -S openstreetmap-carto/openstreetmap-carto.style /data/india-latest.osm.pbf
sudo osm2pgsql -c -d geospatial_db -U postgres --create --slim  -G --hstore --tag-transform-script /home/student/openstreetmap-carto/openstreetmap-carto.lua -C 2500 --number-processes 1 -S /home/student/openstreetmap-carto/openstreetmap-carto.style /home/student/osmdata/india-latest.osm.pbf --host=localhost --password

echo "Download shapefiles and fonts"
cd /geospatial/openstreetmap-carto/
scripts/get-shapefiles.py
apt install -y fonts-noto-cjk fonts-noto-hinted fonts-noto-unhinted ttf-unifont
apt update

psql -U geospatial_user geospatial_user -c 'CREATE EXTENSION pgRouting'


