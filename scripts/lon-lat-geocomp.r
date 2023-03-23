# this is copied from 
# https://raw.githubusercontent.com/geocompx/geocompr/main/code/02-vectorplots.R


library(globe)
library(dplyr)
library(sf)

london_lonlat = st_point(c(-0.1, 51.5)) %>%
  st_sfc() %>%
  st_sf(crs = 4326, geometry = .)
london_osgb = st_transform(london_lonlat, 27700)
origin_osgb = st_point(c(0, 0)) %>% 
  st_sfc() %>% 
  st_sf(crs = 27700, geometry = .)
london_orign = rbind(london_osgb, origin_osgb)

paris = c(2.34,48.85)

paris_lonlat = st_point(paris) %>%
    st_sfc() %>%
    st_sf(crs = 4326, geometry = .)
paris_lambert = st_transform(paris_lonlat, 27561)
origin_lambert = st_point(c(0, 0)) %>% 
  st_sfc() %>% 
  st_sf(crs = 27561, geometry = .)
paris_origin = rbind(paris_lambert, origin_lambert)

png("images/vector_lonlat.png")
globe::globeearth(eye = c(0, 0))
gratmat = st_coordinates(st_graticule())[, 1:2]
globe::globelines(loc = gratmat, col = "grey", lty = 3)
globe::globelines(loc = matrix(c(-90, 90, 0, 0), ncol = 2))
globe::globelines(loc = matrix(c(0, 0, -90, 90), ncol = 2))
globe::globepoints(loc = c(-0.1, 51.5), pch = 4, cex = 2, lwd = 3, col = "red")
globe::globepoints(loc = c(0, 0), pch = 1, cex = 2, lwd = 3, col = "blue")
dev.off()
png("images/vector_projected.png")
uk = rnaturalearth::ne_countries(scale = 50) %>% 
  st_as_sf() %>% 
  filter(grepl(pattern = "United Kingdom|Ire", x = name_long)) %>% 
  st_transform(27700)
plot(uk$geometry)
plot(london_orign$geometry[1], add = TRUE, pch = 4, cex = 2, lwd = 3, col = "red")
plot(london_orign$geometry[2], add = TRUE, pch = 1, cex = 2, lwd = 3, col = "blue")
abline(h = seq(0, 9e5, length.out = 10), col = "grey", lty = 3)
abline(v = seq(0, 9e5, length.out = 10), col = "grey", lty = 3)
dev.off()


# globe
png("images/vector_lonlatglobe.png")
globe::globeearth(eye = c(0,0))
gratmat = st_coordinates(st_graticule())[, 1:2]
globe::globelines(loc = gratmat, col = "grey", lty = 3)
globe::globelines(loc = matrix(c(-90, 90, 0, 0), ncol = 2))
globe::globelines(loc = matrix(c(0, 0, -90, 90), ncol = 2))
globe::globepoints(loc = c(0, 0), pch = 1, cex = 2, lwd = 3, col = "blue")
dev.off()

# paris
png("images/vector_lonlatparis.png")
globe::globeearth(eye = c(0,0))
gratmat = st_coordinates(st_graticule())[, 1:2]
globe::globelines(loc = gratmat, col = "grey", lty = 3)
globe::globelines(loc = matrix(c(-90, 90, 0, 0), ncol = 2))
globe::globelines(loc = matrix(c(0, 0, -90, 90), ncol = 2))
globe::globepoints(loc = paris, pch = 4, cex = 2, lwd = 3, col = "red")
globe::globepoints(loc = c(0, 0), pch = 1, cex = 2, lwd = 3, col = "blue")
dev.off()
png("images/vector_projectedparis.png")
france = rnaturalearth::ne_states(country = "France", returnclass = "sf") %>% 
  filter(!name %in% c("Guyane française", "Martinique", "Guadeloupe", "La Réunion", "Mayotte")) %>%
  st_as_sf() %>% 
  st_transform(27561)
plot(france$geometry)
plot(paris_origin$geometry[1], add = TRUE, pch = 4, cex = 2, lwd = 3, col = "red")
plot(paris_origin$geometry[2], add = TRUE, pch = 1, cex = 2, lwd = 3, col = "blue")
abline(h = seq(-9e5, 9e5, length.out = 15), col = "grey", lty = 3)
abline(v = seq(0, 13e5, length.out = 10), col = "grey", lty = 3)
dev.off()
