# https://github.com/nvkelso/natural-earth-vector/blob/master/Makefile#L457-L481

test: admin_pop_test
all: admin_pop

admin_pop:
	mapshaper -i 

admin_pop_test:
	mapshaper -i sedac/gpw-v4-admin-unit-center-points-population-estimates-rev11_fin_gpkg/gpw_v4_admin_unit_center_points_population_estimates_rev11_fin.shp \
		-points x=INSIDE_X y=INSIDE_Y \
		-o temp/sedac_inside.shp
	mapshaper -i naturalearth/ne_10m_admin_1_states_provinces/ne_10m_admin_1_states_provinces.shp \
	 -join temp/sedac_inside.shp \
	 sum-fields="UN_2000_E,UN_2005_E,UN_2020_E,TOTAL_A_KM" \
	 -o output/ne_10m_admin_1_pop_finland.shp
		
