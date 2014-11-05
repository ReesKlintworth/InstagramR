textInputRow<-function (inputId, label, value){
  div(style="display:inline-block",
      tags$label(label, `for` = inputId), 
      tags$input(id = inputId, type = "text", value = value, class = "input-medium"))
}

numericInputRow <- function (inputId, label, value, min){
  div(style="display:inline-block",
      tags$label(label, `for` = inputId),
      tags$input(id = inputId, type = "number", value = value, min = min, step = 1, class = "input-small"))
}

actionButtonSeparateRow <- function(inputId, value){
  div(
    tags$button(id = inputId, type="button", class = "btn btn-primary action-button shiny-bound-input", value))
}