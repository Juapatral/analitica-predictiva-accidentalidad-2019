function(input, output) {
    ### ---- cargar liberias ----
    library(leaflet)
    library(sf)
    
    ### ---- cargar archivos    
    # CREAR FUNCION DE LECTURA CUANDO SE TENGA
    datos2019 <- datos2019
    
    # vector de posibles accidentes
    accidentes <- c("TODOS", "ATROPELLO", "CAIDA OCUPANTE", "CHOQUE", "INCENDIO", 
                    "VOLCAMIENTO", "OTRO")  
    
    # mapa de comunas
    barrio <- read_sf("files/Limite_Barrio_Vereda_Catastral/Limite_Barrio_Vereda_Catastral.shp")
    
    ### ---- crear outputs ----
    # crear grafico 2019
    output$prueba <- renderPlotly({
        
        # definir nuevas variables
        clase <- input$tipo_accidente
        fecha <- input$tipo_fecha
            
        if(clase == "TODOS"){
            datos_grafico <- group_by(.data = datos2019, 
                                      .dots = fecha) %>%
                             filter(FECHA >= input$dateRange[1] &
                                        FECHA <= input$dateRange[2]) %>%
                             summarize(accidentes = sum(total_accidentes))
        } else {
            
            datos_grafico <- group_by(.data = datos2019, 
                                      .dots = fecha) %>%
                             filter(FECHA >= input$dateRange[1] &
                                        FECHA <= input$dateRange[2]) %>%
                             filter(CLASE == clase) %>% 
                             summarize(accidentes = sum(total_accidentes))
        }
        
        if(fecha == "PERIODO" | fecha == "DIA_NOMBRE"){
            
            tipo <- "bar"
            modo <- NULL
            llenado <- NULL
        
        }else{
            
            tipo <- "scatter"
            modo <- "lines"
            llenado <- "tozeroy"
        }
        
        visible <- ifelse(fecha == "FECHA", F, T)
        
        clase_acc <- ifelse(input$tipo_accidente2 == "s",
                            datos_grafico["CLASE"], 
                            F)
        
        if(fecha == "DIA_NOMBRE"){
            datos_grafico[fecha][[1]] <- factor(datos_grafico[fecha][[1]],
                                                levels = c("LUNES", "MARTES",
                                                           "MIERCOLES", "JUEVES",
                                                           "VIERNES", "SABADO", 
                                                           "DOMINGO"))
            datos_grafico <- datos_grafico %>% arrange(DIA_NOMBRE)
        }
        
        titulo <- paste("Total de accidentes entre", 
                        paste(input$dateRange, collapse = " y ")
                        )
        
        eje_x <- paste("Tipo de fecha:", switch(fecha,
                                        "FECHA" = "Diario",
                                        "DIA_NOMBRE" = "Dia de la semana",
                                        "SEMANA" = "Semanal",
                                        "MES" = "Mensual",
                                        "PERIODO" = "Anual"
                                        ))
        
        eje_y <- "Cantidad de accidentes"
        
        plot_ly(data = datos_grafico,
                x = datos_grafico[fecha],
                y = ~accidentes,
                type = tipo,
                mode = modo,
                fill = llenado,
                line = list(width = 1),
                hoverinfo = "text+y",
                hovertext = as.character(datos_grafico[fecha][[1]]),
                color = "red") %>%
            layout(title = titulo,
                   xaxis = list(visible = visible,
                                title = eje_x,
                                #categoryorder = "array",
                                #categoryarray = as.character(datos_grafico[fecha][[1]]),
                                #type = "date",
                                tickmode = "array",
                                tickvals = 0:nrow(datos_grafico[fecha]),
                                ticktext = datos_grafico[fecha][[1]]
                                ),
                   yaxis = list(title = eje_y,
                                rangemode = "nonnegative")
                   
                  
                   )
    })
    
    # crear grafico historico
    output$historico <- renderPlotly({
        
        # definir nuevas variables
        clase <- input$tipo_accidente
        fecha <- input$tipo_fecha
        
        if(clase == "TODOS"){
            datos_grafico <- group_by(.data = acc_totales, 
                                      .dots = fecha) %>%
                             summarize(accidentes = sum(total_accidentes))
        } else {
            
            datos_grafico <- group_by(.data = acc_totales, 
                                      .dots = fecha) %>%
                             filter(CLASE == clase) %>% 
                             summarize(accidentes = sum(total_accidentes))
        }
        
        if(fecha == "PERIODO" | fecha == "DIA_NOMBRE"){
            
            tipo <- "bar"
            modo <- NULL
            llenado <- NULL
            
        }else{
            
            tipo <- "scatter"
            modo <- "lines"
            llenado <- "tozeroy"
        }
        
        visible <- ifelse(fecha == "FECHA", F, T)
        
        if(fecha == "DIA_NOMBRE"){
            datos_grafico[fecha][[1]] <- factor(datos_grafico[fecha][[1]],
                                                levels = c("LUNES", "MARTES",
                                                           "MIERCOLES", "JUEVES",
                                                           "VIERNES", "SABADO", 
                                                           "DOMINGO"))
            datos_grafico <- datos_grafico %>% arrange(DIA_NOMBRE)
        }
        
        titulo <- paste("Total de accidentes entre 2014 y 2018")
        
        eje_x <- paste("Tipo de fecha:", switch(fecha,
                                        "FECHA" = "Diario",
                                        "DIA_NOMBRE" = "Dia de la semana",
                                        "SEMANA" = "Semanal",
                                        "MES" = "Mensual",
                                        "PERIODO" = "Anual"
                                        ))
        
        eje_y <- "Cantidad de accidentes"
        
        plot_ly(data = datos_grafico,
                x = datos_grafico[fecha],
                y = ~accidentes,
                type = tipo,
                mode = modo,
                fill = llenado,
                line = list(width = 1),
                hoverinfo = "text+y",
                hovertext = as.character(datos_grafico[fecha][[1]]))%>%
            layout(title = titulo,
                   xaxis = list(visible = visible,
                                title = eje_x,
                                #categoryorder = "array",
                                #categoryarray = as.character(datos_grafico[fecha][[1]]),
                                #type = "date",
                                tickmode = "array",
                                tickvals = 0:nrow(datos_grafico[fecha]),
                                ticktext = datos_grafico[fecha][[1]]
                                ),
                   yaxis = list(title = eje_y,
                                rangemode = "nonnegative")
                   )
    })
    
    # crear texto app
    output$texto_descriptivo <- renderText({
        
        "Se presentan los accidentes de movilidad entre 2014 y 2018 y sus valores pronosticados para el 2019. Seleccione rango de fechas, tipo de fecha y tipo de accidente."
        
    })
    
    # crear mapa
    output$mapa <- renderLeaflet({
        
        tipo_accidente_mapa <- input$tipo_accidente_mapa
        comuna_mapa <- input$comuna_mapa
        
        if(tipo_accidente_mapa == "TODOS" & comuna_mapa == "TODAS"){
            
            nueva_base <- acc %>%
                filter(PERIODO >= input$anio_mapa[1] & 
                           PERIODO <= input$anio_mapa[2]) %>%
                group_by(COMUNA_BARRIO) %>%
                summarize(accidentes = n()) %>%   
                ungroup() %>%
                mutate(categoria_accidentes = ifelse(accidentes <= 10,
                                                     "0-10",
                                              ifelse(accidentes <= 25,
                                                     "11-25",
                                              ifelse(accidentes <= 50,
                                                     "26-50",
                                              ifelse(accidentes <= 75,
                                                     "51-75",
                                              ifelse(accidentes <= 100,
                                                     "76-100",
                                              ifelse(accidentes <= 250,
                                                     "101-250",
                                                     "+250"
                                              )))))))
            
            nuevo_mapa <- inner_join(barrio, nueva_base,
                                     by = c("CODIGO" = "COMUNA_BARRIO"))
        }else if(comuna_mapa == "TODAS"){
            
            nueva_base <- acc %>%
                      filter(PERIODO >= input$anio_mapa[1] & 
                                 PERIODO <= input$anio_mapa[2],
                             CLASE == tipo_accidente_mapa) %>%
                      group_by(COMUNA_BARRIO) %>%
                      summarize(accidentes = n()) %>%
                                      ungroup() %>%
                mutate(categoria_accidentes = ifelse(accidentes <= 10,
                                                     "0-10",
                                              ifelse(accidentes <= 25,
                                                     "11-25",
                                              ifelse(accidentes <= 50,
                                                     "26-50",
                                              ifelse(accidentes <= 75,
                                                     "51-75",
                                              ifelse(accidentes <= 100,
                                                     "76-100",
                                              ifelse(accidentes <= 250,
                                                     "101-250",
                                                     "+250"
                                              )))))))
            
            nuevo_mapa <- inner_join(barrio, nueva_base,
                                     by = c("CODIGO" = "COMUNA_BARRIO"))
        }else if(tipo_accidente_mapa == "TODOS"){
            
            nueva_base <- acc %>%
                      filter(PERIODO >= input$anio_mapa[1] & 
                                 PERIODO <= input$anio_mapa[2]) %>%
                      group_by(COMUNA_BARRIO) %>%
                      summarize(accidentes = n()) %>%
                                      ungroup() %>%
                mutate(categoria_accidentes = ifelse(accidentes <= 10,
                                                     "0-10",
                                              ifelse(accidentes <= 25,
                                                     "11-25",
                                              ifelse(accidentes <= 50,
                                                     "26-50",
                                              ifelse(accidentes <= 75,
                                                     "51-75",
                                              ifelse(accidentes <= 100,
                                                     "76-100",
                                              ifelse(accidentes <= 250,
                                                     "101-250",
                                                     "+250"
                                              )))))))
            
            nuevo_mapa <- inner_join(barrio, nueva_base,
                                     by = c("CODIGO" = "COMUNA_BARRIO")) %>%
                          filter(NOMBRE_COM == comuna_mapa)
        }else{
            
            nueva_base <- acc %>%
                      filter(PERIODO >= input$anio_mapa[1] & 
                                 PERIODO <= input$anio_mapa[2],
                             CLASE == tipo_accidente_mapa) %>%
                      group_by(COMUNA_BARRIO) %>%
                      summarize(accidentes = n()) %>%
                                      ungroup() %>%
                mutate(categoria_accidentes = ifelse(accidentes <= 10,
                                                     "0-10",
                                              ifelse(accidentes <= 25,
                                                     "11-25",
                                              ifelse(accidentes <= 50,
                                                     "26-50",
                                              ifelse(accidentes <= 75,
                                                     "51-75",
                                              ifelse(accidentes <= 100,
                                                     "76-100",
                                              ifelse(accidentes <= 250,
                                                     "101-250",
                                                     "+250"
                                              )))))))
            
            nuevo_mapa <- inner_join(barrio, nueva_base,
                                     by = c("CODIGO" = "COMUNA_BARRIO"))%>%
                          filter(NOMBRE_COM == comuna_mapa)
        }
        
        # establecer paleta
        mypal <- colorNumeric(palette = "magma", 
                               domain = nuevo_mapa$accidentes, 
                               n = 5, 
                               reverse = TRUE)
        
        # crear mapa
        leaflet() %>%
            addPolygons(data = nuevo_mapa,
                        color = "grey",
                        opacity = 0.9,
                        #fill = ~categoria_accidentes,
                        fillColor = ~mypal(nuevo_mapa$accidentes),
                        fillOpacity = 0.6,
                        weight = 1,
                        label = ~NOMBRE_BAR,
                        highlightOptions = highlightOptions(color = "black",
                                      weight = 3, bringToFront = T, opacity = 1),
                        popup = paste("Barrio: ", nuevo_mapa$NOMBRE_BAR, "<br>",
                                      "Accidentes: ", nuevo_mapa$accidentes, "<br>")
                        ) %>%
            addProviderTiles(providers$Wikimedia) %>%
            addLegend(position = "bottomright", 
                      pal = mypal, 
                      values = nuevo_mapa$accidentes,
                      title = "Accidentes",
                      opacity = 0.3)
    })
    
    # crear texto mapa
    output$texto_mapa <- renderText({
        
        "Se presenta el mapa de los accidentes de movilidad entre 2014 y 2018 por barrio, comuna y tipo de accidente. Seleccione los periodos, comuna y tipo de accidente."
        
    })
    
    # crear texto mapa explicacion
    output$texto_mapa_explicacion <- renderText({
        "Darle click al mapa para conocer el barrio y el total de accidentes."
    })
}