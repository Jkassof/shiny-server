library(shiny)
library(shinythemes)
library(shinyBS)
library(shinyjs)
library(DT)

# Define UI for application that draws a histogram
ui <- fluidPage(theme = shinytheme("readable"), includeCSS('www/style.css'),
  useShinyjs(),              
  titlePanel(img(src = 'rock_logo.png', height = 50), windowTitle = "Daily Blotter"),
  hr(),

  sidebarLayout(
    
    sidebarPanel(style = "text-align: center;",
      h3("Daily Blotter Review",  style = "margin-top: 5px; size: 26px;"),
      uiOutput('select_button'),
      hr(),
      actionButton('confirm', "Confirm Selected Trades",
                   style = "background-color: ForestGreen;
                            color: white;"), hr(),
      actionButton('escalate', "Escalate Selected Trades",
                   style = "background-color: Firebrick;
                            color:  white;"), hr(),
      h3(textOutput("counter"), style = "padding: 5px; color: rgb(127, 129, 130); border: 3px solid #b0bed; border-radius: 15px;")
    ),
    
    mainPanel(
      shinyjs::hidden(
        div(id = "confirmation_box",
            wellPanel(style = "background-color: ForestGreen;",
              h4(textOutput("statement"), style = "color: white;"),
              actionButton("confirm_confirm", "Yes, I'm sure", style = "margin-right: 30px; margin-bottom: 10px; background-color: Linen;"),
              actionButton("deny_confirm", "Let me go back and check", style = "background-color: Linen;")
            ))
      ),
      shinyjs::hidden(
        div(id = "escalation_box",
            wellPanel(style = "background-color: Firebrick;",
                      h4(textOutput("escalate_statement"), style = "color: white;"),
                      actionButton("confirm_escalate", "Yes, I'm sure", style = "margin-right: 30px; margin-bottom: 10px; background-color: Linen;"),
                      actionButton("deny_escalate", "Let me go back and check", style = "background-color: Linen;")
            ))
      ),
      bsAlert('above_table'),
      # textOutput('search'),
      # h5("selected"),
      # textOutput('selected'),
      # h5("filtered"),
      # textOutput('filtered'),
      dataTableOutput('tbl')
      )
    )
  )


