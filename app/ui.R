### ---- carga de librerias ----
# cargar libreria de markdown
library(markdown)
library(plotly)

# cargar libreria de mapas
library(leaflet)
library(sf)

### ---- carga de archivos ----
# vector de posibles accidentes
accidentes <- c("TODOS", "ATROPELLO", "CAIDA OCUPANTE", "CHOQUE", "INCENDIO", 
                "VOLCAMIENTO", "OTRO")  

# mapa de barrios y comunas
barrios <- read_sf("files/Limite_Barrio_Vereda_Catastral/Limite_Barrio_Vereda_Catastral.shp")
comunas <- c("TODAS", levels(factor(barrios$NOMBRE_COM)))

### ---- iniciar ui ----  
# iniciar pagina
fluidPage(
  
  # titulo
  #titlePanel("Hello Shiny!"),
  
  # imagen de la app
  img(src = 'MoviliApp40.png', height = "50px", align = "right"),
  
  # crear pestania principal
      tabsetPanel( 
        
        ### ---- pestania de inicio ----
        tabPanel("Inicio", includeMarkdown("opening.md")),
        
        ### ---- pestania de resumen ----
        tabPanel("Resumen", includeMarkdown("resumen.md")),

        ### ---- pestania de informe ----
        #tabPanel("Informe", includeHTML("accidentalidad-2014-2018.html")),
        
        ### ---- pestania de mapa ----
        tabPanel("Mapa",

                 # crear barra lateral
                 sidebarPanel(width = 3,

                   # prueba
                   tags$style(".well {background-color: #b3cde0;}"),

                   # imagen de la app
                   img(src = 'MoviliApp.png', height = "165px"),

                   # titulo
                   titlePanel("Resumen y filtros:", windowTitle = "MoviliApp"),

                   # texto
                   textOutput("texto_mapa"),

                   # seleccion de anio
                   sliderInput("anio_mapa",
                               "Periodos:",
                               min = 2014,
                               max = 2018,
                               value = c(2014, 2018)),
                   
                   # seleccion de tipo de accidentes
                   selectInput(inputId = "comuna_mapa",
                               label = "Comuna:",
                               choices = comunas),
                   
                   # seleccion de tipo de accidentes
                   selectInput(inputId = "tipo_accidente_mapa",
                               label = "Tipo de accidente:",
                               choices = accidentes),
                   
                   # version
                   textOutput("version")
                   
                   ),

                 mainPanel(
                   
                   # titulo del mapa
                   titlePanel("Mapa de accidentalidad por barrios"),
                   
                   # explicacion del mapa
                   textOutput("texto_mapa_explicacion"),

                   # crear mapa
                   leafletOutput("mapa")

                   )

                 ),
        
        ### ---- pestania de aplicacion ---- 
        tabPanel("App",

                 # crear barra lateral
                 sidebarPanel(width = 3,

                   # prueba
                   tags$style(".well {background-color: #b3cde0;}"),

                   # imagen de la app
                   img(src = 'MoviliApp.png', height = "165px"),

                   # titulo
                   titlePanel("Resumen y filtros:"),

                   # texto
                   textOutput("texto_descriptivo"),

                   # seleccion de rango de fechas
                   dateRangeInput('dateRange',
                                  label = 'Ingrese rangos de fechas:',
                                  start = as.Date("2019-01-01"),
                                  end = as.Date(ifelse(Sys.Date() > as.Date("2019-12-31"),
                                               as.Date("2019-12-31"),
                                               Sys.Date()),
                                               origin = as.Date("1970-01-01"))
                                  ),

                   # seleccion de tipo de fechas
                   selectInput(inputId = "tipo_fecha",
                              label = "Tipo de fecha:",
                              choices = c("Diario" = "FECHA",
                                          "Dia de la semana" = "DIA_NOMBRE",
                                          "Semanal" = "SEMANA",
                                          "Mensual" = "MES",
                                          "Anual" = "PERIODO"
                                          )
                              ),

                   # seleccion de tipo de accidentes
                   selectInput(inputId = "tipo_accidente",
                               label = "Tipo de accidente:",
                               choices = accidentes),
                   
                   # version
                   textOutput("version")
                   
                   ),

                 # crear panel principal
                 mainPanel(

                   # mostrar grafico historico
                   plotlyOutput("historico", height = "350px"),

                   # crear grafico
                   div(align = "center",
                    plotlyOutput("pronostico", height = "250px")
                         )
                   )
        ),

        ### ---- pestania de video ----
        tabPanel("Video explicativo", 
                 
                 # video embebido
                 HTML('<iframe width="813" height="457" src="https://www.youtube.com/embed/tAA_yWX8ycQ" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>'),
                 
                 # version
                 textOutput("version")
                 )
      )
    )
  

