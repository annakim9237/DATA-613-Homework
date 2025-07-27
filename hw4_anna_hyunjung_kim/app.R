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
      selectInput("xvar_scatter", "Choose X variable for Scatter Plot", choices = names(mtcars), selected = "wt"),
      selectInput("yvar_scatter", "Choose Y variable for Scatter Plot", choices = names(mtcars), selected = "mpg"),
      selectInput("var_hist", "Choose variable for Histogram", choices = names(mtcars), selected = "mpg")
    ),
    
    mainPanel(
      DT::dataTableOutput("data"),
      tabPanel("Summary", verbatimTextOutput("summary")),
      tabsetPanel(
        tabPanel("Test Boxplot", plotOutput("Boxplot")),
        tabPanel("Scatter Plot", plotOutput("plot", width = "90%")),
        tabPanel("Histogram", plotOutput("histplot")
        )
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
    ggplot(mtcars, aes(x = .data[[input$xvar_scatter]], y = .data[[input$yvar_scatter]])) +
      geom_point() +
      theme_bw() +
      xlab("Displacement") +
      ylab("Highway MPG")
  })
  
  output$histplot <- renderPlot({
    hist(mtcars[[input$var_hist]],
         xlab = input$var_hist,
         col = "pink")
  })
}

shinyApp(ui, server)