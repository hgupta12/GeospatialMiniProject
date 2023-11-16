FROM postgis/postgis:16-3.4

RUN apt update && apt install -y curl wget osm2pgsql