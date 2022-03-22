#!/bin/bash
# mkdir -p sedac
# Auth required to download thesse. Please download and unzip these files before continuing
# Testing level 1: Finland
# wget https://sedac.ciesin.columbia.edu/downloads/data/gpw-v4/gpw-v4-admin-unit-center-points-population-estimates-rev11/gpw-v4-admin-unit-center-points-population-estimates-rev11_fin_gpkg.zip
# Testing level 2: Oceania
# wget https://sedac.ciesin.columbia.edu/downloads/data/gpw-v4/gpw-v4-admin-unit-center-points-population-estimates-rev11/gpw-v4-admin-unit-center-points-population-estimates-rev11_oceania_gpkg.zip
# Production: Global
# wget https://sedac.ciesin.columbia.edu/downloads/data/gpw-v4/gpw-v4-admin-unit-center-points-population-estimates-rev11/gpw-v4-admin-unit-center-points-population-estimates-rev11_global_gpkg.zip

wget --directory-prefix=gadm https://geodata.ucdavis.edu/gadm/gadm4.0/gpkg/gadm40_FIN_gpkg.zip
unzip gadm40_FIN_gpkg.zip
DB="dbname='postgres' host='127.0.0.1' port='5432' user='$USER' password=''"
INPUT_POINTS=
DB_NAME=metal

# create a new database
sudo -u postgres createdb -O $USER $DB_NAME
# enable postgis
psql -h localhost -U $USER $DB_NAME -c 'CREATE EXTENSION postgis;'
# load the data, be sure to specify layer type since GDAL may guess incorrectly based on the first feature
# This prevents the error: Warning 1: Geometry to be inserted is of type Multi Polygon, whereas the layer geometry type is Polygon.
# https://postgis.net/workshops/postgis-intro/loading_data.html
ogr2ogr -nln gadm1 -nlt PROMOTE_TO_MULTI -lco PRECISION=NO -lco GEOMETRY_NAME=geom -lco FID=gid -progress -overwrite -f "PostgreSQL" PG:"dbname=metal" gadm/gadm40_FIN_shp/gadm40_FIN_1.shp
ogr2ogr -nln gpw -lco PRECISION=NO -lco GEOMETRY_NAME=geom -lco FID=gid -overwrite -f "PostgreSQL" PG:"dbname=metal" sedac/gpw-v4-admin-unit-center-points-population-estimates-rev11_fin_gpkg/gpw_v4_admin_unit_center_points_population_estimates_rev11_fin.gpkg

# Enable spatial index on both 
psql metal -c 'CREATE INDEX gadm1_geom_idx ON gadm1 USING GIST (geom);'
psql metal -c 'CREATE INDEX gow_geom_idx ON gpw USING GIST (geom);'