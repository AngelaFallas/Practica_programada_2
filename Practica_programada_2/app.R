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
                 selected = "puntaje")
  ),
  dashboardBody(
    tabBox(
      title = "Libertad", id = "tab_1",
      tabPanel("Libertad Personal",
               plotOutput("personal_plot")),
      tabPanel("Libertad Humana",
               plotOutput("humana_plot")),
      tabPanel("Libertad Económica",
               plotOutput("economica_plot"))
    )
  )
)

server <- function(input, output) {
  output$personal_plot <- renderPlot({
    data <- subset(datos_libertad, pais == input$pais_selector & between(anio, input$rango_anios[1], input$rango_anios[2]))
    columna <- ifelse(input$tipo_datos == "puntaje", "libertad_personal_puntaje", "libertad_personal_ranking")
    plot(data$anio, data[[columna]], type = 'l', main = paste("Libertad Personal para", input$pais_selector, "a lo largo del tiempo"), xlab = "Año", ylab = ifelse(input$tipo_datos == "puntaje", "Puntaje", "Ranking"))
  })
  output$humana_plot <- renderPlot({
    data <- subset(datos_libertad, pais == input$pais_selector & between(anio, input$rango_anios[1], input$rango_anios[2]))
    columna <- ifelse(input$tipo_datos == "puntaje", "libertad_humana_puntaje", "libertad_humana_ranking")
    plot(data$anio, data[[columna]], type = 'l', main = paste("Libertad Humana para", input$pais_selector, "a lo largo del tiempo"), xlab = "Año", ylab = ifelse(input$tipo_datos == "puntaje", "Puntaje", "Ranking"))
  })
  output$economica_plot <- renderPlot({
    data <- subset(datos_libertad, pais == input$pais_selector & between(anio, input$rango_anios[1], input$rango_anios[2]))
    columna <- ifelse(input$tipo_datos == "puntaje", "libertad_economica_puntaje", "libertad_economica_ranking")
    plot(data$anio, data[[columna]], type = 'l', main = paste("Libertad Económica para", input$pais_selector, "a lo largo del tiempo"), xlab = "Año", ylab = ifelse(input$tipo_datos == "puntaje", "Puntaje", "Ranking"))
  })
}

shinyApp(ui, server)

