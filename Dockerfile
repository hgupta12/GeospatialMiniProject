FROM postgis/postgis:16-3.4

WORKDIR /geospatial

COPY ./installation.sh ./
RUN chmod +x installation.sh
RUN ./installation.sh

COPY ./postStartup.sh ./
RUN chmod +x postStartup.sh

ENTRYPOINT ["./postStartup.sh"]
