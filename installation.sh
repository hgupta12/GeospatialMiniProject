#!/bin/bash

set -e -x -v

apt update

echo "install basic dependencies"
apt install -y vim curl wget build-essential cmake zip unzip git

# This is just to increase timeout of TCP connection for downloading, ignore for now
echo '
Acquire::Retries "100";
Acquire::https::Timeout "240";
Acquire::http::Timeout "240";
APT::Get::Assume-Yes "true";
APT::Install-Recommends "false";
APT::Install-Suggests "false";
Debug::Acquire::https "true";
' > /etc/apt/apt.conf.d/99custom
apt update

echo "installing necessary packages for tileserver"
apt install -y libboost-all-dev git-core bzip2 autoconf libtool libxml2-dev
apt install -y libgeos-dev libgeos++-dev libpq-dev libbz2-dev libproj-dev munin-node munin
apt install -y libprotobuf-c-dev protobuf-c-compiler libfreetype6-dev libtiff5-dev libicu-dev
apt install -y libgdal-dev libcairo-dev libcairomm-1.0-dev libagg-dev
apt install -y liblua5.2-dev ttf-unifont lua5.1 liblua5.1-dev osm2pgsql libboost-graph-dev
apt install -y apache2 apache2-dev # libgeotiff-epsg

echo "installing dependencies for mapnik"
apt install -y gdal-bin libmapnik-dev mapnik-utils python3-mapnik
apt update

echo "Installing dependencies for mod_tile and renderd"
cd /
git clone -b switch2osm https://github.com/SomeoneElseOSM/mod_tile.git
cd mod_tile
./autogen.sh
./configure
make
sudo make install
sudo make install-mod_tile
ldconfig

echo "Installing pgrouting"
wget -O pgrouting-3.1.4.tar.gz https://github.com/pgRouting/pgrouting/archive/v3.1.4.tar.gz
tar xvfz pgrouting-3.1.4.tar.gz
cd pgrouting-3.1.4
mkdir build
cd build
cmake  ..
make
make install


