
library(sf)
library(dplyr)
library(here)

destdir = file.path(here(),"data","shapefiles","departements-20140306-100m")

if (!file.exists(file.path(destdir,"departements-20140306-100m.shp"))){
  dir.create(file.path(here(),"data","shapefiles"), showWarnings = FALSE)
  download.file(url = "https://www.data.gouv.fr/fr/datasets/r/3096e551-c68d-40ce-8972-a228c94c0ad1",
                destfile = file.path(here(),"data","shapefiles","departements-20140306-100m.zip"))
  unzip(file.path(here(),"data","shapefiles","departements-20140306-100m.zip"),
        exdir = destdir)
}

# load departments shapefile
deps = st_read(file.path(destdir,"departements-20140306-100m.shp"))

plot(deps[,"code_insee"])

# subset to continental france
deps = deps %>%
  dplyr::filter(!(code_insee %in% c("2A","2B","971","972","973","974","976")))


# Seine data
data("seine",
     package = "spData")

## Make sure they have the same projection
seine = st_transform(seine,
                     crs = st_crs(deps))

# intersect deps and rivers
deps_seine = st_join(deps, seine) %>%
  ## Get rid of regions with no overlap
  dplyr::filter(!is.na(name)) %>% 
  dplyr::distinct(code_insee, .keep_all = T)

# reproduce plot from class
ggplot() + 
  geom_sf(data = deps_seine,alpha = 0.5, 
          aes(fill = nom),
          col = "#fcb4b3",  # of borders
          linewidth = 0.5) + # of borders
  geom_sf(data = seine, col = "#05E9FF", lwd = 1) + 
  labs(title = "Intersected regions only") +
  theme_bw()


# # get communes shapefile from 
# # https://www.data.gouv.fr/fr/datasets/contours-des-communes-de-france-simplifie-avec-regions-et-departement-doutre-mer-rapproches/
# stable url: https://www.data.gouv.fr/fr/datasets/r/00c0c560-3ad1-4a62-9a29-c34c98c3701e

commdir = file.path(here(),"data","shapefiles","communes")

if (!file.exists(file.path(commdir,"a-com2022-topo-2154.json"))){
  dir.create(commdir, showWarnings = FALSE)
  
  download.file(url = "https://www.data.gouv.fr/fr/datasets/r/00c0c560-3ad1-4a62-9a29-c34c98c3701e",
                destfile = file.path(commdir,"a-com2022-topo-2154.json"),quiet = FALSE)
}


comms = st_read(file.path(commdir,"a-com2022-topo-2154.json"),layer = "a_com2022")
st_crs(comms) <- 2154 # set the initial CRS

comms = comms %>%
  st_transform(4326) %>%
  dplyr::rename(code_insee = codgeo)

# subset to relevant departments only: i.e. the ones of the join above
co_d = comms %>% 
  dplyr::filter(dep %in% unique(deps_seine$code_insee))

# reproduce plot above but now apply a color code that tells us
# how many communes the rivers traverse *in each departement*

# join co with seine
co_seine = st_join(co_d, seine) %>%
  ## Get rid of regions with no overlap
  dplyr::filter(!is.na(name)) %>% 
  dplyr::distinct(code_insee, .keep_all = T)

# plot all the communes that are traversed and color by river name
ggplot(co_seine) + geom_sf(aes(fill = name))

# add the rivers themselves
ggplot(co_seine) + 
  geom_sf(aes(fill = name)) + 
  geom_sf(data = seine, col = "#05E9FF", lwd = 0.6)


co_d_seine = co_seine %>%
  st_set_geometry(NULL) %>% # can get rid of geometry
  dplyr::group_by(dep) %>%
  dplyr::summarise(ncomms = dplyr::n()) 

# merge with deps_seine and plot again
deps_seine %>%
  dplyr::inner_join(co_d_seine, by = c("code_insee" = "dep")) %>%
  ggplot() + 
  geom_sf(alpha = 0.9, 
          aes(fill = ncomms),
          col = "grey",  # of borders
          linewidth = 0.2) + # of borders
  geom_sf(data = seine, col = "#05E9FF", lwd = 1) + 
  # scale_fill_gradient2(low = "white",high = "red") + 
  scale_fill_viridis_c() + 
  labs(title = "Number of Communes by Department",
       subtitle = "Traversed by one of Seine, Marne or Yonne",
       fill = "Number of\nCommunes") +
  theme_bw()
  





