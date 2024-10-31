r <- raster("fus_pred_low_hist_crop.tif")
r <- aggregate(r, 2)


writeRaster(r, "./2fus_pred_low_hist_crop.tif", dataType="INT2U")
