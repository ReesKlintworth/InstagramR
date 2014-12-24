library(rCharts)
library(rjson)
library(RCurl)
library(shiny)
library(shinyIncubator)

source('HTMLR/input.R')
source('R/data_gathering.R')
source('R/utility.R')

initial_user = TRUE
initial_hashtag = TRUE