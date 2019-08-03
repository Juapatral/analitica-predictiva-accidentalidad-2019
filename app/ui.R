library(markdown)

fluidPage(

  mainPanel(
      tabsetPanel(position = "below", 
        tabPanel("Inicio", includeMarkdown("opening.md")),
        tabPanel("Resumen", includeMarkdown("resumen.md")),
        tabPanel("Informe", includeHTML("accidentalidad-2014-2018.html")),
        tabPanel("Aplicacion", dateRangeInput('dateRange',
                                           label = 'Date range input: yyyy-mm-dd',
                                           start = as.Date("2019-01-01"), end = Sys.Date()
                                           )
                 ),
        tabPanel("Explicacion", HTML('<iframe width="813" height="457" src="https://www.youtube.com/embed/tAA_yWX8ycQ" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>'))
      )
    )
  )

