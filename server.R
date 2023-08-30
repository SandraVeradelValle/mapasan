server <- function(input, output) {

  output$mapa_interactivo <- renderPlotly({
    indx <- input$indicador

    datos_sum <- switch(indx,
                        "Dx_PE" = datos_sum_dx_pe,
                        "Dx_PT" = datos_sum_dx_pt,
                        "Dx_TE" = datos_sum_dx_te)

    ukmap_sub <- shape[shape$UBIGEO %in% unique(datos_sum$UBIGEO), ]
    LIMA <- shape[shape$DEPARTAMEN %in% "LIMA", ]

    datos_sum = datos_sum %>%
      pivot_wider(names_from = c(Sexo, categorias), values_from = Numero)

    ukmap_sub <- merge(ukmap_sub, datos_sum, by = "UBIGEO")

    indicador_texto <- switch(indx,
                              "Dx_PE" = paste("Ubigeo: ", ukmap_sub$UBIGEO,
                                              "<br>Niñas D.Global: ",  ukmap_sub$F_D.Global,
                                              "<br>Niñas Normal: ",  ukmap_sub$F_Normal,
                                              "<br>Niños D.Global: ",  ukmap_sub$M_D.Global,
                                              "<br>Niños Normal: ",  ukmap_sub$M_Normal),
                              "Dx_PT" = paste("Ubigeo: ",  ukmap_sub$UBIGEO,
                                              "<br>Niñas D.Aguda: ",  ukmap_sub$F_D.Aguda,
                                              "<br>Niñas Normal: ",  ukmap_sub$F_Normal,
                                              "<br>Niñas Obesidad: ",  ukmap_sub$F_Obesidad,
                                              "<br>Niñas Sobrepeso: ",  ukmap_sub$F_Sobrepeso,
                                              "<br>Niños D.Aguda: ",  ukmap_sub$M_D.Aguda,
                                              "<br>Niños Normal: ",  ukmap_sub$M_Normal,
                                              "<br>Niños Obesidad: ", ukmap_sub$ M_Obesidad,
                                              "<br>Niños Sobrepeso: ",  ukmap_sub$M_Sobrepeso),
                              "Dx_TE" = paste("Ubigeo: ",  ukmap_sub$UBIGEO,
                                              "<br>Niñas D.Crónica: ",  ukmap_sub$F_D.Crónica,
                                              "<br>Niñas Normal: ",  ukmap_sub$F_Normal,
                                              "<br>Niños D.Crónica: ",  ukmap_sub$M_D.Crónica,
                                              "<br>Niños Normal: ",  ukmap_sub$M_Normal))


    mapa <- ggplot() +
      geom_sf(data = LIMA) +
      geom_sf(data = ukmap_sub,
              aes(fill = UBIGEO, color = UBIGEO, text = indicador_texto)) +
      scale_fill_manual(values = rainbow(length(unique(ukmap_sub$UBIGEO))),
                        guide = "none") +
      labs(title = paste("Mapa - Indicador:", indx)) +
      theme_bw() +
      theme(legend.position = "none")

    ggplotly(mapa, tooltip = "text")

  })
}
