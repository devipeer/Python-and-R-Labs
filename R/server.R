library(shiny)
library(ggplot2)
library(RColorBrewer)
load("C:/Users/piotr/OneDrive/Pulpit/R lab 3/postop.RData")


ui <- fluidPage(
  titlePanel("Lab 3"),
  p("Task 3"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "task1",
        "Select variable for summary",
        colnames(postop),
        "decision"
      ),
      selectInput(
        "task2",
        "Select variable for graph",
        levels(postop$L.CORE)
      )
    ),
    mainPanel(
      p("Chosen variable:"),
      br(),
      tabsetPanel(
        tabPanel("Summary", verbatimTextOutput("summary")),
        tabPanel("Graph", plotOutput("plot1", width = 600)),
        tabPanel("Table", verbatimTextOutput("table")),
        tabPanel("Means", verbatimTextOutput("means")),
        
      )
    )
    )
  )



# Define server logic required to draw a histogram
server <- function(input, output) {
  data <- reactive({
    postop[,input$task1]
  })
  
  output$summary <- renderPrint({
    temp <- data()
    summary(temp)
  })
  
  data2 <- reactive({
    postop[postop$L.CORE == input$task2,]
  })
  
  output$plot1 <- renderPlot({
    temp <- data2()
    g <- ggplot(temp, aes(x =SURF.STBL, y = COMFORT,fill=SURF.STBL))+
      geom_violin()+
      scale_fill_brewer(palette = "Dark2")+
      theme_bw()+
      labs(title="Violin plot")
    plot(g)
  })
  
  output$table <- renderPrint({
    patients <- matrix(nrow = 3, ncol = 3)
    rownames(patients) <- c("Decision A", "Decision S", "Decision I")
    colnames(patients) <- c("CORE.STBL stable", "CORE.STBL mod-stable", "CORE.STBL unstable")
    patients[1, 1] <- sum(postop$decision == "A" & postop$CORE.STBL == "stable", na.rm = TRUE)
    patients[1, 2] <- sum(postop$decision == "A" & postop$CORE.STBL == "mod-stable", na.rm = TRUE)
    patients[1, 3] <- sum(postop$decision == "A" & postop$CORE.STBL == "unstable", na.rm = TRUE)
    patients[2, 1] <- sum(postop$decision == "S" & postop$CORE.STBL == "stable", na.rm = TRUE)
    patients[2, 2] <- sum(postop$decision == "S" & postop$CORE.STBL == "mod-stable", na.rm = TRUE)
    patients[2, 3] <- sum(postop$decision == "S" & postop$CORE.STBL == "unstable", na.rm = TRUE)
    patients[3, 1] <- sum(postop$decision == "I" & postop$CORE.STBL == "stable", na.rm = TRUE)
    patients[3, 2] <- sum(postop$decision == "I" & postop$CORE.STBL == "mod-stable", na.rm = TRUE)
    patients[3, 3] <- sum(postop$decision == "I" & postop$CORE.STBL == "unstable", na.rm = TRUE)
    patients <- as.table(patients)
    kable(patients)
  })
  
  output$means <- renderPrint({
    temp <- data2()
    paste0(input$task2, ": ", mean(temp$COMFORT))
  })
  
  
}



# Run the application 
shinyApp(ui = ui, server = server)
