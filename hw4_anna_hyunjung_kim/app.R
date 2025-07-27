library(shiny)
library(ggplot2)
#remove.packages("DT")
#install.packages("DT", dependencies = FALSE) #solving error
library(DT)

ui <- fluidPage(
  titlePanel("HW4 Anna Kim"),
  
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("columns", "Select variance you want to see", 
                         choices = names(mtcars),
                         selected = c("mpg", "cyl", "hp")),
      selectInput("select1", "Choose the variable for Box plot", choices = names(mtcars)),
      selectInput("xvar", "Choose X variable for Scatter Plot", choices = names(mtcars), selected = "wt"),
      selectInput("yvar", "Choose Y variable for Scatter Plot", choices = names(mtcars), selected = "mpg")
    ),
    
    mainPanel(
      DT::dataTableOutput("data"),
      tabPanel("Summary", verbatimTextOutput("summary")),
      tabsetPanel(
        tabPanel("Test Boxplot", plotOutput("Boxplot")),
        tabPanel("Scatter Plot", plotOutput("plot", width = "60%", height ="400px"))
      )
      
    )
  )

)

server <- function(input, output, session) {
  output$data <- DT::renderDataTable({
    mtcars[, input$columns, drop = FALSE]
  })
  
  output$summary <- renderPrint({
    summary(mtcars)
  })
  
  output$Boxplot <- renderPlot(
    ggplot(mtcars, aes(x = factor(cyl), y = mtcars[[input$select1]])) +
      geom_boxplot(fill = "lightblue") +
      labs(x = "cyl", y = "mpg", title = "mpg x cyp Bpxplot")
  )
  
  output$plot <- renderPlot({
    ggplot(mpg, aes(x = .data[[input$xvar]], y = .data[[input$yvar]])) +
      geom_point() +
      theme_bw() +
      xlab("Displacement") +
      ylab("Highway MPG")
  })
}

shinyApp(ui, server)