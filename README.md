# iceSubtract
Animation showing difference in antartic ice cover between 1979 and 2016

Data required:

Download 1979 pngs from ftp://sidads.colorado.edu/pub/DATASETS/nsidc0051_gsfc_nasateam_seaice/final-gsfc/browse/south/daily/1979/

Download 2016 pngs from ftp://sidads.colorado.edu/pub/DATASETS/nsidc0081_nrt_nasateam_seaice/browse/south/

Make sure all pngs are in the same folder and rename them to `nt_YYYYMMDD_s.png`

Download `SH_seaice_extent_nrt_v2.csv` and `SH_seaice_extent_final_v2.csv` from https://nsidc.org/data/docs/noaa/g02135_seaice_index/#daily_data_files and merge them together into one file called `SH_seaice_extent.csv`.

Will require java.time library (`joda-time-2.9.7.jar`) in code folder of sketch.
