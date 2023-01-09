#### Travail sur la librairie httr ####

"Nous allons essayé d'interroger les API de RTE avec le logiciel R, 

Organisation de l'appel API : 

1. Determine the API's baseURL and query aprameters, and contruct a request URL
2. Run httr::GET on that URL
3. parse the resultst with httr:content() 
4. If necessary, run jsonlite(s fromJSON function "

#### Appels des librairies nécessaires ####

library(httr)
library(jsonlite)

"Essai d'appels API RTE : 

ID Client 93021053-c8db-48ae-83cc-72db1d3323dd
ID Secret 245150da-1416-4546-964e-60b9755d8544

Quatre ressources : 

- « transmission_network_unavailabilities »
- « transmission_network_unavailabilities/{identifier}/versions »
- « generation_unavailabilities »
- « generation_unavailabilities/{identifier}/versions »
- « additional_informations »


"

"BIG PHYSICAL GazelEnergie : MjkwNWMxMjYtMThhMC00ZWMyLTk1YmYtMTMxZWNkMDNiYTVhOmUxZTBiNWQ3LTAzYmQtNGVmMS04ODIxLWI1NjVkMGE0M2VmMQ=="


#### Travail sur l'API Unavailability Additional Information ####

" 1 - Génération du token 

Via SOAPui, générer une requête en posant l'adresse ci-dessous et poser deux composantes HEADER :

Content-Type : application/x-www-form-urlencoded
Authorization : Basic OTMwMjEwNTMtYzhkYi00OGFlLTgzY2MtNzJkYjFkMzMyM2RkOjI0NTE1MGRhLTE0MTYtNDU0Ni05NjRlLTYwYjk3NTVkODU0NA== 
la dernière composante provient du site de Data RTE et est une clé unique 

Le token généré sera effectif pendant deux heures.

"

url_base_token <- "https://digital.iservices.rte-france.com//token/oauth"

requesttoken <- GET(url_base_token, add_headers(Content = "application/x-www-form-urlencoded", Authorization = "Basic OTMwMjEwNTMtYzhkYi00OGFlLTgzY2MtNzJkYjFkMzMyM2RkOjI0NTE1MGRhLTE0MTYtNDU0Ni05NjRlLTYwYjk3NTVkODU0NA=="))

requestparsed <- httr::content(requesttoken, as = 'text')

jsonresult <- jsonlite::fromJSON(requestparsed)

token <- jsonresult$access_token

"Nous retrouvons le résultat attendu dans le résultat JSON jsonresult$access_token "





"2 - Faire un appel et récupérer les données"

#### Transmission Network Unavailabilities ####

url_base_tnu <- "https://digital.iservices.rte-france.com//open_api/unavailability_additional_information/v4/transmission_network_unavailabilities"

requestdata <- GET(url_base_tnu, add_headers(Authorization = paste("Bearer", token)))

requestparsed <- httr::content(requestdata, as = 'text')

jsonresult <- jsonlite::fromJSON(requestparsed)

base <- dplyr::glimpse(jsonresult)

a <- base$transmission_network_unavailabilities

b <- a[,c("impacted_asset$name")]

a$impacted_asset$eic_code

base <- a[,c("start_date","end_date","type","identifier","message_id","version","creation_date","updated_date","reason","status")]

base <- cbind(base,a$impacted_asset)



#### Generation Forecast ####

" 1 - Generation du token "

url_base_token <- "https://digital.iservices.rte-france.com//token/oauth"

requesttoken <- GET(url_base_token, add_headers(Content = "application/x-www-form-urlencoded", Authorization = "Basic M2Y0NjYyYzktZjBmZi00MDk1LWE4ODMtZDlhZWY5N2EzM2ZhOmRlNTBiMzkzLTE5NjMtNDU2ZS1iMzcxLWE2NDVlNDE2YzA3Zg=="))

requestparsed <- httr::content(requesttoken, as = 'text')

jsonresult <- jsonlite::fromJSON(requestparsed)

token <- jsonresult$access_token

"Nous retrouvons le résultat attendu dans le résultat JSON jsonresult$access_token "




"2 - Faire un appel et récupérer les données"

url_base_tnu <- "https://digital.iservices.rte-france.com//open_api/unavailability_additional_information/v4/transmission_network_unavailabilities"

requestdata <- GET(url_base_tnu, add_headers(Authorization = paste("Bearer", token)))

requestparsed <- httr::content(requestdata, as = 'text')

jsonresult <- jsonlite::fromJSON(requestparsed)

base <- dplyr::glimpse(jsonresult)

a <- base$transmission_network_unavailabilities














