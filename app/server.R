function(input, output, session) {
    ### ---- cargar liberias ----
    library(leaflet, quietly = T)
    library(sf, quietly = T)
    library(data.table, quietly = T)
    library(dplyr, quietly = T)
    library(shiny, quietly = T)
    library(lubridate, quietly = T)
    library(plotly, quietly = T)
    
    ### ---- cargar archivos ----
    
    # datos historicos
    acc <- fread("files/accidentalidad_georreferenciada_completa.csv",
                 sep = ",",
                 encoding = "UTF-8",
                 colClasses = "character")
    
    # agrupar datos
    acc_totales <- group_by(acc, 
                            FECHA, DIA_NOMBRE, DIA, MES, PERIODO, FESTIVO, 
                            MADRE, NAVIDAD, BRUJITOS, SEMSANTA, ESCOLAR, 
                            CLASE) %>% 
                   summarize(total_accidentes = n()) %>%
                   mutate(SEMANA = week(FECHA))

    
    # cargar datos 2019, limpiar fechas y total accidentes
    datos2019 <- fread("files/matriz-2019-pronosticada.csv",
                       sep = ";", 
                       colClasses = "character")
    
    datos2019$FECHA <- as.Date(datos2019$FECHA)
    names(datos2019)[9] <- "total_accidentes" 
    datos2019$total_accidentes <- as.integer(datos2019$total_accidentes)
    datos2019$PERIODO <- as.integer(datos2019$PERIODO)
    datos2019$SEMANA <- week(datos2019$FECHA)
    datos2019$MES <- month(datos2019$FECHA)
    
    # vector de posibles accidentes
    accidentes <- c("TODOS", "ATROPELLO", "CAIDA OCUPANTE", "CHOQUE", 
                    "INCENDIO", "VOLCAMIENTO", "OTRO")  
    
    # mapa de comunas
    barrio <- read_sf("files/Limite_Barrio_Vereda_Catastral/Limite_Barrio_Vereda_Catastral.shp")
    
    ### ---- crear outputs ----
    
    # crear texto de version
    output$version_mapa <- renderText({
        "MoviliApp v.2019.08.11"
    })
    
    # crear texto de version
    output$version_grafica <- renderText({
        "MoviliApp v.2019.08.11"
    })
    
    # crear mapa
    output$mapa <- renderLeaflet({
        
        # crear variables
        tipo_accidente_mapa <- input$tipo_accidente_mapa
        comuna_mapa <- input$comuna_mapa
        
        # crear nueva base dependiendo de las opciones elegidas
        if(tipo_accidente_mapa == "TODOS" & comuna_mapa == "TODAS"){
            
            # se filtra por el periodo elegido, se agrupa por comuna,
            # se calcula el total de accidentes
            nueva_base <- acc %>%
                filter(PERIODO >= input$anio_mapa[1] & 
                           PERIODO <= input$anio_mapa[2]) %>%
                group_by(COMUNA_BARRIO) %>%
                summarize(accidentes = n()) %>%   
                ungroup()
            
            # se unen las tablas
            nuevo_mapa <- inner_join(barrio, nueva_base,
                                     by = c("CODIGO" = "COMUNA_BARRIO"))
            
        }else if(comuna_mapa == "TODAS"){
            
            # se filtra por el periodo elegido, se agrupa por comuna y 
            # tipo de accidente, se calcula el total de accidentes
            nueva_base <- acc %>%
                      filter(PERIODO >= input$anio_mapa[1] & 
                                 PERIODO <= input$anio_mapa[2],
                             CLASE == tipo_accidente_mapa) %>%
                      group_by(COMUNA_BARRIO) %>%
                      summarize(accidentes = n()) %>%
                      ungroup() 
            
            # se unen las tablas
            nuevo_mapa <- inner_join(barrio, nueva_base,
                                     by = c("CODIGO" = "COMUNA_BARRIO"))
            
        }else if(tipo_accidente_mapa == "TODOS"){
            
            # se filtra por el periodo elegido, se agrupa por comuna,
            # se calcula el total de accidentes
            nueva_base <- acc %>%
                      filter(PERIODO >= input$anio_mapa[1] & 
                                 PERIODO <= input$anio_mapa[2]) %>%
                      group_by(COMUNA_BARRIO) %>%
                      summarize(accidentes = n()) %>%
                      ungroup()
            
            # se unen las tablas y se filtra por comuna
            nuevo_mapa <- inner_join(barrio, nueva_base,
                                     by = c("CODIGO" = "COMUNA_BARRIO")) %>%
                          filter(NOMBRE_COM == comuna_mapa)
        }else{
            
            # se filtra por el periodo elegido, se agrupa por comuna y por 
            # tipo de accidente, se calcula el total de accidentes
            nueva_base <- acc %>%
                      filter(PERIODO >= input$anio_mapa[1] & 
                                 PERIODO <= input$anio_mapa[2],
                             CLASE == tipo_accidente_mapa) %>%
                      group_by(COMUNA_BARRIO) %>%
                      summarize(accidentes = n()) %>%
                      ungroup()
            
            # se unen las tablas y se filtra por comuna
            nuevo_mapa <- inner_join(barrio, nueva_base,
                                     by = c("CODIGO" = "COMUNA_BARRIO"))%>%
                          filter(NOMBRE_COM == comuna_mapa)
        }
        
        # establecer paleta
        mypal <- colorNumeric(palette = "magma", 
                               domain = nuevo_mapa$accidentes,
                               reverse = TRUE)
        
        # crear mapa
        leaflet() %>%
            addPolygons(data = nuevo_mapa,
                        color = "grey",
                        opacity = 0.9,
                        weight = 1, # grosor de la linea
                        fillColor = ~mypal(nuevo_mapa$accidentes),
                        fillOpacity = 0.6,
                        label = ~NOMBRE_BAR,
                        # ajustar sombreado de seleccion
                        highlightOptions = highlightOptions(color = "black",
                                                            weight = 3, 
                                                            bringToFront = T, 
                                                            opacity = 1),
                        # ajustar descripcion emergente al darle click
                        popup = paste("Barrio: ", 
                                      nuevo_mapa$NOMBRE_BAR, 
                                      "<br>",
                                      "Accidentes: ", 
                                      nuevo_mapa$accidentes, 
                                      "<br>")
                        ) %>%
            
            #establecer mapa de fondo
            addProviderTiles(providers$OpenStreetMap) %>%
            
            # agregar leyenda
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
    
    # crear grafico 2019
    output$pronostico <- renderPlotly({
        
        # definir nuevas variables
        clase <- input$tipo_accidente
        fecha <- input$tipo_fecha
        
        # crear nuevos datos si se eligen todos los accidentes    
        if(clase == "TODOS"){
            # agrupar por fecha, filtrar por rango de fechas y agregar por 
            # total de accidentes
            datos_grafico <- group_by(.data = datos2019, 
                                      .dots = fecha) %>%
                             filter(FECHA >= input$dateRange[1] &
                                        FECHA <= input$dateRange[2]) %>%
                             summarize(accidentes = sum(total_accidentes))
            
        # crear nuevos datos si se elige un accidente particular    
        } else {
            
            # agrupar por fecha, filtrar por rango de fechas, clase y 
            # agregar por total de accidentes
            datos_grafico <- group_by(.data = datos2019, 
                                      .dots = fecha) %>%
                             filter(FECHA >= input$dateRange[1] &
                                        FECHA <= input$dateRange[2]) %>%
                             filter(CLASE == clase) %>% 
                             summarize(accidentes = sum(total_accidentes))
        }
        
        # parametrizar grafico
        if(fecha == "PERIODO" | fecha == "DIA_NOMBRE"){
            
            tipo <- "bar"   # tipo grafico
            modo <- NULL    # modo especial del grafico
            llenado <- NULL # llenar colores del grafico
        
        }else{
            
            tipo <- "scatter"       # tipo grafico
            modo <- "lines"         # modo especial del grafico
            llenado <- "tozeroy"    # llenar colores del grafico
        }
        
        # parametrizar visibilidad del eje
        visible <- ifelse(fecha == "FECHA", F, T)
        
        # ordenar nombre del dia 
        if(fecha == "DIA_NOMBRE"){
            datos_grafico[fecha][[1]] <- factor(datos_grafico[fecha][[1]],
                                                levels = c("LUNES", "MARTES",
                                                           "MIERCOLES", "JUEVES",
                                                           "VIERNES", "SABADO", 
                                                           "DOMINGO"))
            datos_grafico <- datos_grafico %>% arrange(DIA_NOMBRE)
        }
        
        # ajustar titulo del grafico
        titulo <- paste("Total de accidentes entre", 
                        paste(input$dateRange, collapse = " y ")
                        )
        
        # ajustar parametros del eje x
        eje_x <- paste("Tipo de fecha:", switch(fecha,
                                        "FECHA" = "Diario",
                                        "DIA_NOMBRE" = "Dia de la semana",
                                        "SEMANA" = "Semanal",
                                        "MES" = "Mensual",
                                        "PERIODO" = "Anual"
                                        ))
        
        # ajustar parametros del eje y
        eje_y <- "Cantidad de accidentes"
        
        # crear grafico
        plot_ly(data = datos_grafico,      
                x = datos_grafico[fecha],
                y = ~accidentes,
                type = tipo,
                mode = modo,
                fill = llenado,
                line = list(width = 1),
                # ajustar descripcion emergente
                hoverinfo = "text+y",
                hovertext = as.character(datos_grafico[fecha][[1]]),
                color = I("#ff3112")) %>%
            layout(title = titulo,
                   xaxis = list(visible = visible,
                                title = eje_x,
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
        
        # crear nuevos datos si se eligen todos los accidentes    
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
        
        # parametrizar grafico
        if(fecha == "PERIODO" | fecha == "DIA_NOMBRE"){
            
            tipo <- "bar"   # tipo grafico
            modo <- NULL    # modo especial del grafico
            llenado <- NULL # llenar colores del grafico
            
        }else{
            
            tipo <- "scatter"       # tipo grafico
            modo <- "lines"         # modo especial del grafico
            llenado <- "tozeroy"    # llenar colores del grafico
        }
        
        # parametrizar visibilidad del eje
        visible <- ifelse(fecha == "FECHA", F, T)
        
        # ordenar nombre del dia 
        if(fecha == "DIA_NOMBRE"){
            datos_grafico[fecha][[1]] <- factor(datos_grafico[fecha][[1]],
                                                levels = c("LUNES", "MARTES",
                                                           "MIERCOLES", "JUEVES",
                                                           "VIERNES", "SABADO", 
                                                           "DOMINGO"))
            datos_grafico <- datos_grafico %>% arrange(DIA_NOMBRE)
        }
        
        # ajustar titulo del grafico
        titulo <- paste("Total de accidentes entre 2014 y 2018")
        
        # ajustar parametros del eje x
        eje_x <- paste("Tipo de fecha:", switch(fecha,
                                        "FECHA" = "Diario",
                                        "DIA_NOMBRE" = "Dia de la semana",
                                        "SEMANA" = "Semanal",
                                        "MES" = "Mensual",
                                        "PERIODO" = "Anual"
                                        ))
        
        # ajustar parametros del eje y
        eje_y <- "Cantidad de accidentes"
        
        # crear grafico
        plot_ly(data = datos_grafico,
                x = datos_grafico[fecha],
                y = ~accidentes,
                type = tipo,
                mode = modo,
                fill = llenado,
                line = list(width = 1),
                color = I("#084594"),
                # ajustar descripcion emergente
                hoverinfo = "text+y",
                hovertext = as.character(datos_grafico[fecha][[1]]))%>%
            layout(title = titulo,
                   xaxis = list(visible = visible,
                                title = eje_x,
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
    
}