# https://github.com/nvkelso/natural-earth-vector/blob/master/Makefile#L457-L481

test: admin_pop_test
all: admin_pop
all_bands: admin_pop admin_bands mts_tiles
fields = NAME1,UN_2020_E,TOTAL_A_KM,INSIDE_X,INSIDE_Y
northeast_csv = sedac/gpw-v4-admin-unit-center-points-population-estimates-rev11_global_csv/gpw_v4_admin_unit_center_points_population_estimates_rev11_usa_northeast.csv
midwest_csv = sedac/gpw-v4-admin-unit-center-points-population-estimates-rev11_global_csv/gpw_v4_admin_unit_center_points_population_estimates_rev11_usa_midwest.csv
west_csv = sedac/gpw-v4-admin-unit-center-points-population-estimates-rev11_global_csv/gpw_v4_admin_unit_center_points_population_estimates_rev11_usa_west.csv
# sumfields = 
# sql = SELECT $fields 

csv:
	# import all gpw csv layers and combine into one point shapefile 
	mapshaper-xl -i "sedac/gpw-v4-admin-unit-center-points-population-estimates-rev11_global_csv/*.csv" \
	combine-files \
	csv-fields=INSIDE_X,INSIDE_Y,UN_2020_E \
	-merge-layers \
	-points x=INSIDE_X y=INSIDE_Y \
	-o temp/sedac_inside.shp


merge_gpkg:
	# ogr2ogr \
	# 	-f "gpkg" temp/sedac_merge.gpkg \
	# 	-nln merge \
	# 	sedac/gpw-v4-admin-unit-center-points-population-estimates-rev11_global_gpkg/gpw_v4_admin_unit_center_points_population_estimates_rev11_global.gpkg
	# ogr2ogr \
	# 	-f "gpkg" temp/sedac_merge.gpkg \
	# 	-update -append \
	# 	-nln merge \
	# 	sedac/gpw-v4-admin-unit-center-points-population-estimates-rev11_global_gpkg/gpw_v4_admin_unit_center_points_population_estimates_rev11_usa_midwest.gpkg
	ogr2ogr \
		-f "gpkg" temp/sedac_merge.gpkg \
		-update -append \
		-nln merge \
		sedac/gpw-v4-admin-unit-center-points-population-estimates-rev11_global_gpkg/gpw_v4_admin_unit_center_points_population_estimates_rev11_usa_northeast.gpkg
	# ogr2ogr \
	# 	-f "gpkg" temp/sedac_merge.gpkg \
	# 	-update -append \
	# 	-nln merge \
	# 	sedac/gpw-v4-admin-unit-center-points-population-estimates-rev11_global_gpkg/gpw_v4_admin_unit_center_points_population_estimates_rev11_usa_south.gpkg
	ogr2ogr \
		-f "gpkg" temp/sedac_merge.gpkg \
		-update -append \
		-nln merge \
		sedac/gpw-v4-admin-unit-center-points-population-estimates-rev11_global_gpkg/gpw_v4_admin_unit_center_points_population_estimates_rev11_usa_west.gpkg

admin_pop:
	mkdir -p temp
	csv
	mapshaper_join
	# rm -rf temp/

mapshaper_join:
	mapshaper-xl -i naturalearth/ne_10m_admin_1_states_provinces.shp \
	 -join temp/points-csv.shp \
	 sum-fields="UN_2000_E,UN_2005_E,UN_2020_E,TOTAL_A_KM" \
	 -o output/ne_10m_admin_1_pop.shp
	
admin_pop_oceania:
	# ogr2ogr -sql "SELECT geom, UN_2000_E, UN_2020_E, MakePoint(INSIDE_X, INSIDE_Y) as inside_geom from gpw_v4_admin_unit_center_points_population_estimates_rev11_oceania" \
	# 	-f "ESRI Shapefile" temp/sedac_oceania.shp \
	# 	sedac/gpw-v4-admin-unit-center-points-population-estimates-rev11_oceania_gpkg/gpw_v4_admin_unit_center_points_population_estimates_rev11_oceania.gpkg
	ogr2ogr -select $(fields) \
		-f "ESRI Shapefile" temp/sedac_oceania.shp \
		sedac/gpw-v4-admin-unit-center-points-population-estimates-rev11_oceania_gpkg/gpw_v4_admin_unit_center_points_population_estimates_rev11_oceania.gpkg
	mapshaper -i temp/sedac_oceania.shp \
		-points x=INSIDE_X y=INSIDE_Y \
		-o temp/sedac_inside.shp
	mapshaper -i naturalearth/ne_10m_admin_1_states_provinces.shp \
	 -join temp/sedac_inside.shp \
	 sum-fields="UN_2000_E,UN_2005_E,UN_2020_E,TOTAL_A_KM" \
	 -o output/ne_10m_admin_1_pop_oceania.shp
	#rm -rf temp/
		

admin_pop_test:
	mapshaper -i sedac/gpw-v4-admin-unit-center-points-population-estimates-rev11_fin_gpkg/gpw_v4_admin_unit_center_points_population_estimates_rev11_fin.shp \
		-points x=INSIDE_X y=INSIDE_Y \
		-o temp/sedac_inside.shp
	mapshaper -i naturalearth/ne_10m_admin_1_states_provinces.shp \
	 -join temp/sedac_inside.shp \
	 sum-fields="UN_2000_E,UN_2005_E,UN_2020_E,TOTAL_A_KM" \
	 -o output/ne_10m_admin_1_pop_finland.shp
	# rm -rf temp/
		
get_natural_earth:
	wget --directory-prefix=naturalearth \
		https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_1_states_provinces.zip
	unzip naturalearth/ne_10m_admin_1_states_provinces.zip -d naturalearth/

admin_bands:
	mapshaper -i output/ne_10m_admin_1_pop.shp\
	 -join bands/bands_ogr.shp \
	 calc 'bands_count=count()' \
	 -each 'bands_per = bands_count / UN_2020_E' \
	 -each 'bands_p100 = 100000 * bands_count / UN_2020_E' \
	 -o output/ne_10m_admin_1_bands.shp


# https://github.com/mapbox/tilesets-cli
mts_tiles:
	ogr2ogr -F GeoJSON temp/ne_10m_admin_1_bands.geojson output/ne_10m_admin_1_bands.shp
	tilesets upload-source $(MAPBOX_USER) ne_10m_admin_1_bands temp/ne_10m_admin_1_bands.geojson \
		--replace \
		--token $(MAPBOX_SECRET_TOKEN)
	tilesets create $(MAPBOX_USER).ne_bands_percapita \
		--recipe mts/recipe.json \
		--name "Metal Bands Per Capita Natural Earth" \
		--token $(MAPBOX_SECRET_TOKEN)
	tilesets update-recipe $(MAPBOX_USER).ne_bands_percapita mts/recipe.json \
		--token $(MAPBOX_SECRET_TOKEN)
	tilesets publish $(MAPBOX_USER).ne_bands_percapita \
		--token $(MAPBOX_SECRET_TOKEN)



	