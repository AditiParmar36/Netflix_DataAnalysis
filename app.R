install.packages("crayon")
install.packages("shiny")
library(shiny)
library(shinydashboard)

# ---- Load saved model ----
saved <- readRDS("final_model.rds")
model <- saved$model

# If you saved levels (recommended), use them; otherwise rebuild from your training df
rating_levels  <- if (!is.null(saved$levels_rating))  saved$levels_rating  else NULL
country_levels <- if (!is.null(saved$levels_country)) saved$levels_country else NULL

# ---- UI ----
ui <- dashboardPage(
  skin = "black",
  dashboardHeader(title = "Netflix Content Predictor"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Predict", tabName = "predict", icon = icon("magic"))
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "predict",
              
              fluidRow(
                box(
                  title = "Enter Details",
                  width = 5, status = "primary", solidHeader = TRUE,
                  
                  numericInput("year", "Release Year", value = 2020, min = 1950, max = 2030),
                  
                  # Toggle content type to guide inputs
                  radioButtons("ctype", "Content Type (for input logic)",
                               choices = c("Movie", "TV Show"),
                               inline = TRUE),
                  
                  conditionalPanel(
                    condition = "input.ctype == 'Movie'",
                    numericInput("movie_dur", "Movie Duration (minutes)", value = 100, min = 1)
                  ),
                  
                  conditionalPanel(
                    condition = "input.ctype == 'TV Show'",
                    numericInput("tv_seasons", "Number of Seasons", value = 2, min = 1)
                  ),
                  
                  selectInput("rating", "Rating",
                              choices = rating_levels),
                  
                  selectInput("country", "Country",
                              choices = country_levels),
                  
                  actionButton("go", "Predict", icon = icon("play"))
                ),
                
                box(
                  title = "Result",
                  width = 7, status = "success", solidHeader = TRUE,
                  h3(textOutput("pred_text")),
                  h4(textOutput("prob_text")),
                  hr(),
                  verbatimTextOutput("debug")
                )
              )
      )
    )
  )
)

# ---- SERVER ----
server <- function(input, output, session) {
  
  observeEvent(input$go, {
    
    # Build features consistent with training
    movie_duration <- if (input$ctype == "Movie") input$movie_dur else 0
    tv_seasons     <- if (input$ctype == "TV Show") input$tv_seasons else 0
    
    new_data <- data.frame(
      release_year   = input$year,
      movie_duration = movie_duration,
      tv_seasons     = tv_seasons,
      rating  = factor(input$rating,  levels = rating_levels),
      country = factor(input$country, levels = country_levels)
    )
    
    # Predict
    prob <- predict(model, new_data, type = "response")
    pred <- ifelse(prob > 0.5, "TV Show", "Movie")
    
    # Output
    output$pred_text <- renderText({
      paste("Prediction:", pred)
    })
    
    output$prob_text <- renderText({
      paste("Probability (TV Show):", round(prob, 3))
    })
    
    # Optional debug (helps in viva)
    output$debug <- renderPrint({
      list(input = new_data, probability = prob, threshold = 0.5)
    })
  })
}

shinyApp(ui, server)
