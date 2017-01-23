library(shiny)
library(shinyBS)
library(DT)


shinyServer(function(input, output, session) {
  
  # unconfirmed_trans <- reactivePoll(1000, session, 
  #                                   checkFunc = update_checker,
  #                                   valueFunc = )
  ########### Start right above this!!! #########
  
  output$tbl <- DT::renderDataTable(
    iris,
    options = list(paging = FALSE,
                   dom = "Brtip",
                   buttons = c("copy", "excel", "pdf", "print"),
                   autoWidth = TRUE),
    rownames = FALSE,
    extensions = "Buttons",
    filter = 'top',
    selection = list(selected = seq_along(1:nrow(iris)))
  )
  
  output$select_button <- renderUI({
    search_string <- if(purrr::is_null(input$tbl_search_columns)) "" else input$tbl_search_columns
    if (all(search_string ==  "")) {
      actionButton('select_but', "Select/Deselect All", style = "background-color: rgb(127, 129, 130); color: White;")
    }  else {
      actionButton('select_but', "Select/Deselect Filtered Only", style = "background-color: rgb(127, 129, 130); color: White;")
    }
  })
  
  proxy <-  dataTableProxy('tbl')
  
  observeEvent(input$all, {
    if (input$all %% 2 != 0) {
      proxy %>% selectRows(NULL)
    } else {
      proxy %>% selectRows(seq_along(1:nrow(iris)))
    }
  })
  
  observeEvent(input$select_but, {
    selected <- input$tbl_rows_selected
    filtered <-  input$tbl_rows_current
    if (all(input$tbl_search_columns == "") & purrr::is_null(selected)) {
      proxy %>% selectRows(seq_along(1:nrow(iris)))
    } else if (all(input$tbl_search_columns == "")) {
      proxy %>% selectRows(NULL)
    } else if (all(filtered %in% selected)) {
       proxy %>% selectRows(setdiff(selected, filtered))
    } else {
       proxy %>% selectRows(filtered)
    }
  })
  
  observeEvent(input$confirm, {
    selected <- length(input$tbl_rows_selected)
    all_rows <- nrow(iris)
    output$statement <- shiny::renderText({
      if (selected == all_rows) {
        "You have selected all trades to be confirmed"  
      } else {
        paste("You have selected", selected, "trades to be confirmed")

    }
    })
    if (selected == 0) {
      createAlert(session, "above_table",
                  content = "There are no selected trades, please select trades for confirmation",
                  style = "warning")
    } else {
    show("confirmation_box", anim = TRUE)
    }
  })
  
  observeEvent(input$deny_confirm, {
    hide("confirmation_box", anim = TRUE)
  })
  
  observeEvent(input$confirm_confirm, {
    hide("confirmation_box", anim = TRUE)
    createAlert(session, "above_table",
                content = "Thanks for the trades! Have a nice day :)",
                style = "success")
    #confirm_selected_trades(input)
  })
  
  observeEvent(input$escalate, {
    selected <- length(input$tbl_rows_selected)
    all_rows <- nrow(iris)
    output$escalate_statement <- shiny::renderText({
      if (selected == all_rows) {
        "You have selected all trades to be escalated"  
      } else {
        paste("You have selected", selected, "trades to be escalated")
        
      }
    })
    if (selected == 0) {
      createAlert(session, "above_table",
                  content = "There are no selected trades, please select trades for escalation",
                  style = "warning")
    } else {
      show("escalation_box", anim = TRUE) 
    }
  })
  
  observeEvent(input$deny_escalate, {
    hide("escalation_box", anim = TRUE)
  })
  
  observeEvent(input$confirm_escalate, {
    hide("escalation_box", anim = TRUE)
    createAlert(session, "above_table",
                content = "Your trades have been escalated to trading and compliance",
                style = "warning")
  })
  
  output$counter <- renderText({
    all_rows <- nrow(iris)
    row_select_count <- length(input$tbl_rows_selected)
    if (row_select_count == all_rows) {
    "All trades selected"  
    } else {
    paste(length(input$tbl_rows_selected), "out of", all_rows, "trades selected")
  }})
  
  # output$selected <- renderPrint(input$tbl_rows_selected)
  # output$filtered <- renderPrint(input$tbl_rows_current)
  # output$search <- renderPrint(input$tbl_search_columns)
  

})
