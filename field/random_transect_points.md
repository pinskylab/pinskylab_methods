To create start locations for random fish transects:

1. Use polygons from Amphiprion: /local/shared/pinsky_lab/philippines/GIS/site_hulls/*.shp
2. Generate random points with QGIS plugin (Vector/Research Tools/Random Points)
   i. make sure CRS is WGS84 (lat/lon) (EPSG:4326)
   ii. generate 2 per polygon (Stratified). Trim Magbangon to only 2 total (even though 4 polygons)
   iii. save as random_points and add to map
3. Add lat and lon using calculator in QGIS table (width 10, precision 10)
4. Add a column for direction  (SE, NW, NE, SW). Go NW from point for a 25m transect, unless this would cross an edge. Then try going SE from point, then NE, then SW. The measure tool is useful here.
   i. With the shapefile's table open, "Show Features Visible On Map" is useful
5. Fill in site names by hand (name column, width 20)
7. Save layer as... CSV: Random_points_YYYY_MM.csv (YYYY is year, MM is month)
8. Use randquads.R to generate random photo quadrat locations along each transect (5 quadrats for each)
9. All saved in Planning/Transect_locationsYYYY_XX.xlsx (along with Fixed locations from previous seasons)
10. Copy lat/lons and random quad locations into the Random transect lines
