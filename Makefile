# https://github.com/nvkelso/natural-earth-vector/blob/master/Makefile#L457-L481

test: admin_pop_test
all: admin_pop
# fields = UN_2000_E,UN_2005_E,UN_2020_E,TOTAL_A_KM j
# sumfields = 

admin_pop:
	ogr2ogr -f "ESRI Shapefile" temp/sedac_global.shp \
		sedac/gpw-v4-admin-unit-center-points-population-estimates-rev11_global_gpkg/gpw_v4_admin_unit_center_points_population_estimates_rev11_global.gpkg
	mapshaper-xl -i temp/sedac_global.shp \
		-points x=INSIDE_X y=INSIDE_Y \
		-o temp/sedac_inside.shp
	mapshaper-xl -i naturalearth/ne_10m_admin_1_states_provinces.shp \
	 -join temp/sedac_inside.shp \
	 sum-fields="UN_2000_E,UN_2005_E,UN_2020_E,TOTAL_A_KM" \
	 -o output/ne_10m_admin_1_pop.shp
	# rm -rf temp/

admin_pop_oceania:
	ogr2ogr -f "ESRI Shapefile" temp/sedac_oceania.shp \
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
	rm -rf temp/
		
get_natural_earth:
	wget --directory-prefix=naturalearth \
		https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_1_states_provinces.zip
	unzip naturalearth/ne_10m_admin_1_states_provinces.zip -d naturalearth/