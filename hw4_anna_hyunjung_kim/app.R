library(shiny)
library(ggplot2)

ui <- fluidPage(
  titlePanel("HW4 Anna Kim"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("select1", "Choose the variance", choices = names(mtcars))
    ),
    
    mainPanel(
      tableOutput('data'),
      tabsetPanel(
        tabPanel("Test Boxplot", plotOutput("Boxplot"))
      )
    )
  )

)

server <- function(input, output, session) {
  output$data <- renderTable(head(mtcars))
  output$Boxplot <- renderPlot(
    ggplot(mtcars, aes(x = factor(cyl), y = mpg)) +
      geom_boxplot(fill = "lightblue") +
      labs(x = "cyl", y = "mpg", title = "mpg x cyp Bpxplot")
  )
}

shinyApp(ui, server)