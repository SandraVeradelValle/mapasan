# Cargar librerías y datos

library(shiny)
library(sf)
library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)

# Cargando datos ----------------------------------------------------------

shape <- read_sf(dsn = "data/mapas/Distrital INEI 2023 geogpsperu SuyoPomalia.shp")
sandra <- read.csv(file = "data/sandra_total.csv", fileEncoding = "latin1")

# Transformando datos -----------------------------------------------------

sandra = sandra %>%
  gather(Dx_Type, Dx, Dx_PT, Dx_TE, Dx_PE) %>%
  group_by(UbigeoPN, Sexo, Dx_Type, Dx) %>%
  summarise(count = n()) %>%
  ungroup()
names(sandra) = c("UBIGEO", "Sexo","indicador","categorias","Numero")

datos_sum_dx_pe <- sandra %>%
  filter(indicador == "Dx_PE") %>%
  group_by(UBIGEO, Sexo, categorias) %>%
  summarise(Numero = sum(Numero))

datos_sum_dx_pt <- sandra %>%
  filter(indicador == "Dx_PT") %>%
  group_by(UBIGEO, Sexo, categorias) %>%
  summarise(Numero = sum(Numero))

datos_sum_dx_te <- sandra %>%
  filter(indicador == "Dx_TE") %>%
  group_by(UBIGEO, Sexo, categorias) %>%
  summarise(Numero = sum(Numero))

# Cargando server y ui ----------------------------------------------------

source("ui.R")
source("server.R")

# Corriendo app -----------------------------------------------------------

shinyApp(ui = ui, server = server)
