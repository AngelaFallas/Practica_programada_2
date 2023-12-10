library(shiny)
library(ggplot2)
library(shinydashboard)
library(dplyr)
library(readr)

datos_libertad <- read_csv("datos/datos_libertad.csv")


ui <- dashboardPage(
  dashboardHeader(title = "Libertad Dashboard"),
  dashboardSidebar(
    selectInput("pais_selector", "Seleccionar País", choices = unique(datos_libertad$pais))
  ),
  dashboardBody(
    tabBox(
      title = "Libertad en", id = "tab_1",
      tabPanel("Libertad Personal",
               plotOutput("personal_plot")),
      tabPanel("Libertad Humana",
               plotOutput("humana_plot")),
      tabPanel("Libertad Económica",
               plotOutput("economica_plot"))
    )
  )
)

server <- function(input, output){
  
}


shinyApp(ui, server)
