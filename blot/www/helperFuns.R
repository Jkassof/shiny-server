confirm_selected_trades <- function(input) {
  
  selected_trades <- input$tbl_rows_selected
  
  update_tab <- tibble::tibble(transaction_record = selected_trades,
                               confirmed = 1)
  
  RODBC::sqlUpdate(channel = fetch_backend(),
                   dat = update_tab,
                   tablename = "audit_record",
                   index = "transaction_record")
}

fetch_backend <- function() {
  RODBC::odbcDriverConnect("Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=//corp.rockco.com/deptdata/Data Solutions/Development/JK/daily_blotter_app/backend/blotter_backend.accdb")
}

fetch_unconf_trades <- function() {
  fetch_backend() %>%
    RODBC::sqlFetch(channel = ., sqtable = "unconfirmed_trade_details") %>%
    tibble::as_tibble
}

update_checker <- function() {
  fetch_backend() %>%
    RODBC::sqlFetch(channel = ., sqtable = "unconfirmed_trade_details") %>%
    nrow
}
