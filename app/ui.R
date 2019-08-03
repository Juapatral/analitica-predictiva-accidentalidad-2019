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
        # inicial
        tabPanel("Inicio", includeMarkdown("opening.md")),
        
        # resumen
        tabPanel("Resumen", includeMarkdown("resumen.md")),
        
        # informe
        tabPanel("Informe", includeHTML("accidentalidad-2014-2018.html")),
        
        # aplicacion
        tabPanel("App",
                 sidebarPanel(width = 3,
                   dateRangeInput('dateRange',
                                  label = 'Ingrese rangos de fechas:',
                                  start = as.Date("2019-01-01"), end = Sys.Date()
                                  ),
                   selectInput(inputId = "tipo_fecha", 
                              label = "Tipo de fecha:",
                              choices = c("Diario" = "dia",
                                          "Dia de la semana" = "diasemana",
                                          "Semanal" = "semana",
                                          "Mensual" = "mes",
                                          "Anual" = "anio"
                                          )
                              ),
                   selectInput(inputId = "tipo_accidente",
                               label = "Tipo de accidente:",
                               choices = accidentes)
                   ),
                 mainPanel(
                   leaflet() %>% 
                     addPolygons(data = , 
                                 color = "black", 
                                 opacity = 0.1, 
                                 fill = T, 
                                 #fillColor = c("red", "blue", "green"), 
                                 weight = 2
                                 ) %>% 
    addProviderTiles(providers$Wikimedia)
                 )
                 ),
        tabPanel("Video explicativo", HTML('<iframe width="813" height="457" src="https://www.youtube.com/embed/tAA_yWX8ycQ" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>'))
      )
    )
  

