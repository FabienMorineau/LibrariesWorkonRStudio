#### Travail sur la librairie eurostat ####

"Le package Eurostat est un datastore de données."

#### 1 - Récupération des données ####

install.packages("eurostat")
library(eurostat)

"The search_eurostat(pattern ..) function scans the directory of Eurostat tables and return cdes and descriptions of tables that match pattern"
query <- search_eurostat(pattern = "fertility rate", type = "table", fixed = FALSE)

query[,1:2]

"The get_eruostat(id, time_format = date, filters = none, type = code, cache = TRUE .. ) function downloads the requested table from the Eurostat bulk download facility 
 or from the eurostat web services JSON API (if filter are defined). Downloaded data is cachet (if cache = TRUE).
  
  Additional arguments define how to read the time column (time_format) and if table dimensions shall be kept as codes or converted to labels (type)"

"Download the table "
ct <- c("AT","BE","BG","FI","FR","NL","DE","UK")
  
dat <- get_eurostat(id = "tps00199", time_format = "num", filters = list(geo=ct))

dat[1:2,]


"Add labels "

dat <- label_eurostat(dat)

#### 2 - Création de graphiques ####

"Réalisation d'une graphique de série temporelle"

library(ggplot2)
library(dplyr)
dat <- get_eurostat(id = "tps00199", filters = list(geo=ct))
ggplot(dat, aes(x=time, y=values, color = geo, label = geo)) +
  geom_line(alpha = .5)+
  geom_text(data = dat %>% group_by(geo) %>% filter(time == max(time)), soze = 2.6) +
  theme(legend.position = "none") +
  labs(title = "Total fertility rate, 2006-2017", x = "Year", y = "%")


"Réalisation d'un histogramme"

dat_2015 <- dat %>% filter(time == "2015-01-01")

ggplot(dat_2015, aes(x=reorder(geo,values), y=values)) +
  geom_col(color = "white", fill = "grey80")+
  theme(axis.text.x = element_text(size = 10)) +
  labs(title = "Total fertility rate, 2015", x = "Country", y = "%")








#### 3 - Création d'une carte ####

"There are two function to work with geospatial data from GISCO.
 The get_eurostat_geospatial() returns spatial data as sf-object.

 Object can me merged with data.frames using dplyr::*_join() functions.
 The cut_to_classes() is a wrapper for cut() function and is used for categorizing data for maps with tidy labels."

mapdata <- get_eurostat_geospatial(nuts_level = 0) %>% 
  right_join(dat_2015) %>%
  mutate(cat = cut_to_classes(values, n=4, decimals = 1))

head(select(mapdata, geo, values, cat),3)


ggplot(mapdata, aes(fill=cat))+
  scale_fill_brewer(palette = "RdYlBu")+
  geom_sf(color = alpha("white",1/3),alpha = .6)+
  xlim(c(-12,44)) + ylim(c(35,70))+
  labs(title = "Total fertility rate, 2015", subtitle = "Avg. numer of life births per woman", fill = "%")


#### Aller chercher des données sur Eurostat ####

"- Se rendre sur https://ec.europa.eu/eurostat/fr/web/main/data/database 
- Chercher le thème souhaité et trouver le code entre parenthèse permettant de faire appel à la donnée à partir de la fonction get_eurostat()"


"Je souhaite suivre les dépenses moyennes de consommations des ménages privés pour le sport"

depsport <- get_eurostat(id = "sprt_pcs_hbs")

depsport <- label_eurostat(depsport)

summary(depsport)

"Présenter les dépenses par pays de manière additionnelle sur l'année 2015"

max(depsport$time)

depsport <- depsport[which(depsport$coicop != "Total"),]

ggplot(dat, aes(x = geo))+
  geom_bar()




