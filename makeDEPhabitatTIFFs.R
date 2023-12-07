# makeDEPhabitatTIFFs.R
# Make DEP and IEI TIFFs for DEPhabitat.all.R
# B. Compton, 26 Jul 2023
# 7 Dec 2023: use files from original sources without copying; put this with app so I can find it next time



source('x:/LCC/Code/Web/geoTIFF4web.R')

geoTIFF4web('x:/CAPS/caps2020/deptop40.tif', 'DEPhabitat', resultpath = 'x:/LCC/GIS/Final/GeoServer/DEPhabitat/',
            auto = FALSE, type = 'INT1U', overviewResample = 'nearest')

geoTIFF4web('x:/CAPS/caps2020/iei5color.tif', 'fivecolor', resultpath = 'x:/LCC/GIS/Final/GeoServer/DEPhabitat/',
            auto = FALSE, type = 'INT1U')

