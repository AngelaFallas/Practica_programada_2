library(shiny)
library(ggplot2)
library(shinydashboard)
library(dplyr)
library(readr)

datos_libertad <- read_csv("datos/datos_libertad.csv")

ui <- dashboardPage(
  skin = "purple",
  dashboardHeader(title = "Libertades Mundiales"),
  dashboardSidebar(
    selectInput("pais_selector", "Seleccionar País", choices = unique(datos_libertad$pais)),
    sliderInput("rango_anios", "Seleccionar Rango de Años:",
                min = min(datos_libertad$anio),
                max = max(datos_libertad$anio),
                value = c(min(datos_libertad$anio), max(datos_libertad$anio)),
                step = 1),
    radioButtons("tipo_datos", "Seleccionar Tipo de Datos:",
                 choices = c("Puntaje" = "puntaje", "Ranking" = "ranking"),
                 selected = "puntaje"),
    downloadButton("descargar_datos", "Descargar Datos")
  ),
  dashboardBody(
    tabBox(
      title = "Libertad", id = "tab_1",
      tabPanel("Libertad Personal",
               plotOutput("personal_chart")),
      tabPanel("Libertad Humana",
               plotOutput("humana_chart")),
      tabPanel("Libertad Económica",
               plotOutput("economica_chart")),
      width = "100%"
    )
  )
)

server <- function(input, output) {
  output$personal_chart <- renderPlot({
    data <- subset(datos_libertad, pais == input$pais_selector & between(anio, input$rango_anios[1], input$rango_anios[2]))
    columna <- ifelse(input$tipo_datos == "puntaje", "libertad_personal_puntaje", "libertad_personal_ranking")
    plot(data$anio, data[[columna]], type = 'l', main = paste("Libertad Personal para", input$pais_selector, "a lo largo del tiempo"), xlab = "Año", ylab = ifelse(input$tipo_datos == "puntaje", "Puntaje", "Ranking"))
  })
  output$humana_chart <- renderPlot({
    data <- subset(datos_libertad, pais == input$pais_selector & between(anio, input$rango_anios[1], input$rango_anios[2]))
    columna <- ifelse(input$tipo_datos == "puntaje", "libertad_humana_puntaje", "libertad_humana_ranking")
    plot(data$anio, data[[columna]], type = 'l', main = paste("Libertad Humana para", input$pais_selector, "a lo largo del tiempo"), xlab = "Año", ylab = ifelse(input$tipo_datos == "puntaje", "Puntaje", "Ranking"))
  })
  output$economica_chart <- renderPlot({
    data <- subset(datos_libertad, pais == input$pais_selector & between(anio, input$rango_anios[1], input$rango_anios[2]))
    columna <- ifelse(input$tipo_datos == "puntaje", "libertad_economica_puntaje", "libertad_economica_ranking")
    plot(data$anio, data[[columna]], type = 'l', main = paste("Libertad Económica para", input$pais_selector, "a lo largo del tiempo"), xlab = "Año", ylab = ifelse(input$tipo_datos == "puntaje", "Puntaje", "Ranking"))
  })
  output$descargar_datos <- downloadHandler(
    filename = function() {
      paste("datos_filtrados_", input$pais_selector, "_", input$tipo_datos, "_", input$rango_anios[1], "_", input$rango_anios[2], ".csv", sep = "")
    },
    content = function(file) {
      data <- subset(Libertad, pais == input$pais_selector & between(anio, input$rango_anios[1], input$rango_anios[2]))
      write.csv(data, file, row.names = FALSE)
    }
  )
  
  output$descargar_graficos <- downloadHandler(
    filename = function() {
      paste("graficos_", input$pais_selector, "_", input$tipo_datos, "_", input$rango_anios[1], "_", input$rango_anios[2], ".zip", sep = "")
    },
    content = function(file) {
      png("personal_plot.png")
      print(output$personal_plot)
      dev.off()
      
      png("humana_plot.png")
      print(output$humana_plot)
      dev.off()
      
      png("economica_plot.png")
      print(output$economica_plot)
      dev.off()
      
      files_to_zip <- c("personal_plot.png", "humana_plot.png", "economica_plot.png")
      zip(file, files_to_zip)
    }
  )
}

shinyApp(ui, server)

