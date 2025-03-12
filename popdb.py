#import TC
import terracotta as tc

#create db
driver = tc.get_driver('tc.sqlite')
key_names = ('year', 'band', 'intensity', 'period', 'geotype', 'resolution')
driver.create(key_names)

#assign rasters to be included
rasters = { 
	('2023', '1', 'pga', '475', 'rock', '3min'): 'v2023_1_pga_475_rock_3min.tif'
}

#add entry for each raster in db
for keys, raster_file in rasters.items():
    driver.insert(keys, raster_file, override_path=f'/data/{raster_file}')
