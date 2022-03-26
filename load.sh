#!/bin/bash
# set -e - script fails on error

# mkdir -p sedac
# Auth required to download thesse. Please download and unzip these files before continuing
# Testing level 1: Finland
# wget https://sedac.ciesin.columbia.edu/downloads/data/gpw-v4/gpw-v4-admin-unit-center-points-population-estimates-rev11/gpw-v4-admin-unit-center-points-population-estimates-rev11_fin_gpkg.zip
# Testing level 2: Oceania
# wget https://sedac.ciesin.columbia.edu/downloads/data/gpw-v4/gpw-v4-admin-unit-center-points-population-estimates-rev11/gpw-v4-admin-unit-center-points-population-estimates-rev11_oceania_gpkg.zip
# Production: Global
# wget https://sedac.ciesin.columbia.edu/downloads/data/gpw-v4/gpw-v4-admin-unit-center-points-population-estimates-rev11/gpw-v4-admin-unit-center-points-population-estimates-rev11_global_gpkg.zip

echo "1) GADM Test (Finland)"
echo "2) GADM Global"
echo "3) Natural Earth"
DATASET=$(read -p "Which dataset do you want to use? [1]: ")

case $DATASET in
    1) ZIP_URL="https://geodata.ucdavis.edu/gadm/gadm4.0/shp/gadm40_FIN_shp.zip";;
    2) ZIP_URL="https://geodata.ucdavis.edu/gadm/gadm4.0/gadm404-gpkg.zip";;
    3) ZIP_URL="https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_1_states_provinces.zip"
esac

! [[ $GADM_DIR_PATH ]] && $GADM_DIR_PATH="gadm"
! [[ $GADM_BASENAME ]] && $GADM_ZIP_PATH="$GADM_DIR_PATH/$(basename $ZIP_URL)"

if ![ -f $GADM_ZIP_PATH ]; then
    echo "Downloading $GADM_ZIP_PATH "
    wget $ZIP_URL -O $GADM_ZIP_PATH
else
    echo "$GADM_ZIP_PATH already downloaded"
fi


echo "Unzipping $GADM_ZIP_PATH"
unzip -d $GADM_DIR_PATH $GADM_ZIP_PATH

# Select the first admin 1 shapefile or geopackage
GADM_DATA_FILE=$(ls $GADM_DIR_PATH/.*{\.gpkg,1\.shp,\.shp} | head -n1)

# Initialize postgres default postgres settings 
! [[ "$DB_HOST" ]] && DB_HOST=localhost
! [[ "$DB_PORT" ]] && DB_PORT=5432
! [[ "$DB_USER" ]] && DB_USER=$USER
! [[ "$DB_NAME" ]] && DB_NAME=metal
POSTGRES_CONNECTION_STRING="dbname='$DB_NAME' host='$DB_HOST' port='$DB_PORT' user='$DB_USER' password='$DB_PASSWORD'"

# create a new database
createdb -h $DB_HOST -p $DB_PORT -U $DB_USER -O $USER $DB_NAME
# enable post GIS
psql $POSTGRES_CONNECTION_STRING -c 'CREATE EXTENSION postgis;'
# load the data, be sure to specify layer type since GDAL may guess incorrectly based on the first feature
# This prevents the error: Warning 1: Geometry to be inserted is of type Multi Polygon, whereas the layer geometry type is Polygon.
# https://postgis.net/workshops/postgis-intro/loading_data.html
ogr2ogr \
  -nln gadm1 \
  -nlt PROMOTE_TO_MULTI \
  -lco PRECISION=NO \
  -lco GEOMETRY_NAME=geom \
  -lco FID=gid \
  -progress \
  # -overwrite \
  -f "PostgreSQL" PG:"$POSTGRES_CONNECTION_STRING" \
  $GADM_DIR_PATH/$GADM_DATA_FILE
  
ogr2ogr \
  -nln gpw \
  -lco PRECISION=NO \
  -lco GEOMETRY_NAME=geom \
  -lco FID=gid \
  # -overwrite \
  -f "PostgreSQL" PG:"$POSTGRES_CONNECTION_STRING" \
  sedac/gpw-v4-admin-unit-center-points-population-estimates-rev11_fin_gpkg/gpw_v4_admin_unit_center_points_population_estimates_rev11_fin.gpkg

# Enable spatial index on both 
psql $POSTGRES_CONNECTION_STRING -c 'CREATE INDEX gadm1_geom_idx ON gadm1 USING GIST (geom);'
psql $DB_NAME -c 'CREATE INDEX gow_geom_idx ON gpw USING GIST (geom);'

echo "creating geom_inside field for more reliable join"
psql $DB_NAME -f sql/0_create_geom_inside.sql

echo "running spatial join of SEDAC against Admin units"