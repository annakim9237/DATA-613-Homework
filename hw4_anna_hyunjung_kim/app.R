library(shiny)
library(ggplot2)
#remove.packages("DT")
#install.packages("DT", dependencies = FALSE)
library(DT)

ui <- fluidPage(
  titlePanel("HW4 Anna Kim"),
  
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("columns", "Select variance you want to see", 
                         choices = names(mtcars),
                         selected = c("mpg", "cyl", "hp")),
      selectInput("select1", "Choose the variance", choices = names(mtcars))
    ),
    
    mainPanel(
      DT::dataTableOutput("data"),
      tabsetPanel(
        tabPanel("Test Boxplot", plotOutput("Boxplot"))
      )
    )
  )

)

server <- function(input, output, session) {
  output$data <- DT::renderDataTable({
    mtcars[, input$columns, drop = FALSE]
  })
  output$Boxplot <- renderPlot(
    ggplot(mtcars, aes(x = factor(cyl), y = mtcars[[input$select1]])) +
      geom_boxplot(fill = "lightblue") +
      labs(x = "cyl", y = "mpg", title = "mpg x cyp Bpxplot")
  )
}

shinyApp(ui, server)