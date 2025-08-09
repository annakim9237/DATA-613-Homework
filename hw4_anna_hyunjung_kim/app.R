library(shiny)
library(ggplot2)
#remove.packages("DT")
#install.packages("DT", dependencies = FALSE) #solving error
library(DT)

ui <- fluidPage(
  titlePanel("Summer 2025 Sessions DATA-613_001 HW4 Anna Kim"),
  
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("columns", "Select variance you want to see", choices = names(mtcars), selected = c("mpg", "cyl", "hp")),
      selectInput("var_box", "Choose the variable for Box plot", choices = names(mtcars)), # For Box plot
      selectInput("xvar_scatter", "Choose X variable for Scatter Plot", choices = names(mtcars), selected = "wt"), # For Scatter plot
      selectInput("yvar_scatter", "Choose Y variable for Scatter Plot", choices = names(mtcars), selected = "mpg"), # For Scatter plot
      selectInput("var_hist", "Choose variable for Histogram", choices = names(mtcars), selected = "mpg"), # For histogram
      selectInput("var_bar", "Choose variable for Bar Plot", choices = c("cyl", "gear", "carb"), selected = "cyl") # For bar plot
    ),
    
    mainPanel(
      DT::dataTableOutput("data"),
      tabPanel("Summary", verbatimTextOutput("summary")),
      tabsetPanel(
        tabPanel("Test Boxplot", plotOutput("Boxplot")),
        tabPanel("Scatter Plot", plotOutput("plot", width = "90%")),
        tabPanel("Histogram", plotOutput("histplot")),
        tabPanel("Box Plot", plotOutput('barplot'))
      )
      
    )
  )

)

server <- function(input, output, session) {
  output$data <- DT::renderDataTable({
    mtcars[, input$columns, drop = FALSE]
  })
  
  output$summary <- renderPrint(
    summary(mtcars)
  ) # () is okay in single line but we need {} on multiple
  
  # boxplot server code
  output$Boxplot <- renderPlot({
    ggplot(mtcars, aes(x = factor(cyl), y = mtcars[[input$var_box]])) +
      geom_boxplot(fill = "lightblue") +
      labs(x = "cyl", y = "mpg", title = "mpg x cyp Bpxplot")
  })
  
  #scatter plot server code
  output$plot <- renderPlot({
    ggplot(mtcars, aes(x = .data[[input$xvar_scatter]], y = .data[[input$yvar_scatter]])) +
      geom_point() +
      theme_bw() +
      xlab("Displacement") +
      ylab("Highway MPG")
  })
  
  # Histogram server code
  output$histplot <- renderPlot({
    hist(mtcars[[input$var_hist]],
         xlab = input$var_hist,
         col = "pink")
  })
  
  # Box plot server code
  output$barplot <- renderPlot({
    ggplot(mtcars, aes(x = factor(.data[[input$var_bar]]))) +
      geom_bar(fill = "darkgreen") +
      ggtitle("Bar Plot")
  })
}

shinyApp(ui, server)