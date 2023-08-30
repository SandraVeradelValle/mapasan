ui <- fluidPage(

  titlePanel("Mapas Interactivos por Indicador"),
  selectInput("indicador", "Seleccione un Indicador:",
              choices = c("Dx_PE", "Dx_PT", "Dx_TE")),
  plotlyOutput("mapa_interactivo", width = "100%", height = "600px")

)
