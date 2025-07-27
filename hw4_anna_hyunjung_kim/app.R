library(shiny)

ui <- fluidPage(
  titlePanel("HW4 Anna Kim"),
  mainPanel(
    tableOutput('data')
  )
)

server <- function(input, output, session) {
  output$data <- renderTable(head(mtcars))
}

shinyApp(ui, server)