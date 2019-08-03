# cargar libreria de markdown
library(markdown)

# cargar libreria de mapas
library(leaflet)
library(sf)

# vector de posibles accidentes
accidentes <- c("Atropello", "Caida Ocupante", "Choque", "Choque y Atropello", 
                "Incendio", "Volcamiento", "Otro")

# mapa de comunas
barrios <- read_sf("files/Limite_Barrio_Vereda_Catastral/Limite_Barrio_Vereda_Catastral.shp")

# iniciar pagina
fluidPage(

  # crear pestania principal
  
      tabsetPanel( 
        
        # pestania de inicio
        tabPanel("Inicio", includeMarkdown("opening.md")),
        
        # pestania de resumen
        tabPanel("Resumen", includeMarkdown("resumen.md")),
        
        # pestania de informe
        tabPanel("Informe", includeHTML("accidentalidad-2014-2018.html")),
        
        # pestania de aplicacion
        tabPanel("App",
                 
                 # crear barra lateral
                 sidebarPanel(width = 3,
                              
                   # seleccion de rango de fechas
                   dateRangeInput('dateRange',
                                  label = 'Ingrese rangos de fechas:',
                                  start = as.Date("2019-01-01"), end = Sys.Date()
                                  ),
                   
                   # seleccion de tipo de fechas
                   selectInput(inputId = "tipo_fecha", 
                              label = "Tipo de fecha:",
                              choices = c("Diario" = "dia",
                                          "Dia de la semana" = "diasemana",
                                          "Semanal" = "semana",
                                          "Mensual" = "mes",
                                          "Anual" = "anio"
                                          )
                              ),
                   
                   # seleccion de tipo de accidentes
                   selectInput(inputId = "tipo_accidente",
                               label = "Tipo de accidente:",
                               choices = accidentes)
                   ),
                 
                 # crear panel principal
                 mainPanel(
                   
                   # crear mapa
                   leaflet() %>% 
                     addPolygons(data = barrios, 
                                 color = "black", 
                                 opacity = 0.1, 
                                 fill = T, 
                                 fillColor = "grey", 
                                 weight = 3
                                 ) %>% 
                     addProviderTiles(providers$Wikimedia)
                   )
                 ),
        
        # pestania de video
        tabPanel("Video explicativo", HTML('<iframe width="813" height="457" src="https://www.youtube.com/embed/tAA_yWX8ycQ" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>'))
      )
    )
  

