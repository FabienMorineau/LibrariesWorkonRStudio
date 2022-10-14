#### Travail sur la librairie cartography ####

install.packages("mapsf")

library(cartography)
library(sf)
library(sp)
library(mapsf)
lycee <- st_read("C:/Users/fmorineau/OneDrive - Business & Decision/Documents/GitHub/LibrariesWorkonRStudio/lycees-donnees-generales.shp")

"Description des données géospatiales"

st_bbox(lycee)
st_crs(lycee)

class(lycee)
head(lycee)
plot(lycee)


lycee$code_academ <- as.numeric(lycee$code_academ)

plot(st_geometry(lycee))


propSymbolsLayer(x=lycee, var = "code_academ", legend.title.txt = "Academie", col = '#a7dfb4')

lycee$code_academ <- as.character(lycee$code_academ)

"Création d'une variable définissant la note de chaque établissement"

lycee$note <- rnorm(849)



#### I - Classification ####

"Choropleth"
choroLayer(x = lycee, var = "note",
           method = "quantile", nclass = 8)

"Typology"
typoLayer(x = lycee, var = "note")

propSymbolsLayer(x = lycee, var = "note", inches = 0.1, symbols = "circle")

tiles <- getTiles(x = lycee, var = "note")



