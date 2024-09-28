#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

# Define UI for application that draws a histogram
fluidPage(

    # Application title
    titlePanel("Medicare Post Acute Care by Geography and Provider 2020-2022"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
      
      
        sidebarPanel(
          selectInput(inputId="DataVariable",
                     label="Select",
                     choices=dataCOLS,
                     selected="TOT_CHRG_AMT"
          ),
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("distPlot"),
            plotOutput("usaMap")
        )
    )
)
