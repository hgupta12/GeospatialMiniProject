#!/bin/bash

echo "Cloning and extracting pgrouting"

wget -O pgrouting-3.1.4.tar.gz https://github.com/pgRouting/pgrouting/archive/v3.1.4.tar.gz
tar xvfz pgrouting-3.1.4.tar.gz

echo "Extraction completed"

cd pgrouting-3.1.4
mkdir build
cd build
cmake  ..
make
make install

# psql -U geospatial_user geospatial_user -c 'CREATE EXTENSION pgRouting'

