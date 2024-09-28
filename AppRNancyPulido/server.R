#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

# Define server logic required to draw a histogram
function(input, output, session) {

    output$distPlot <- renderPlot({

        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = 'Waiting time to next eruption (in mins)',
             main = 'Histogram of waiting times')

    })
    output$usaMap<-renderPlot({
      x<- input$DataVariable
      print(x)
      
      col_name <- x  # Extract the column name
      new_col_name <- paste0("State", col_name)  # Create new dynamic column name
      
      # Calculate totals by state 
      CountByStates <- main_2020_2022s %>% 
        group_by(STATE) %>%
        dplyr::summarize(!!new_col_name := sum(as.numeric(ifelse(!!sym(col_name) == "N/A", 0, !!sym(col_name))), na.rm = TRUE))

      # Convert state abbreviations to full state names
      CountByStates$state_full <- state.name[match(CountByStates$STATE, state.abb)]
      
      # Make state_full lowercase
      CountByStates$state_full <- tolower(CountByStates$state_full)
      
      # Graphs
      # Get USA map data
      usa_map <- map_data("state")
      
      # Change state_full column to region
      colnames(CountByStates)[colnames(CountByStates) == "state_full"] <- "region"
      
      # Join your data with the USA map data
      data_joined <- merge(usa_map, CountByStates, sort = FALSE, by = "region")
      
      # Dynamically reference the column created in `CountByStates` for fill
      plot1 <- ggplot(data_joined, aes(long, lat)) +
        geom_polygon(aes(group = group, fill = !!sym(new_col_name))) +
        coord_map("albers", lat0 = 45.5, lat1 = 29.5) +
        labs(fill = new_col_name, 
             title = "Medicare Post-Acute Care 2000-2022",
             subtitle = new_col_name,
             caption = "Based on Medicare Report")  
      
      # Print the plot
      print(plot1)
      
    })

}
