library(shiny)
data <- read.csv('fitbitData.csv', header=TRUE, na.strings = 'NA')
fit <- lm(Cal.Burned ~ V.Active.Min, data=data)
    
shinyServer(function(input, output) {
    
    # Declare 'variables', 'Plot', 'predictor', 'df' and 'predicted' as reactive 
    # expressions, sot they will be called only when/if the input they depend on changes
    variables <- reactive({ as.numeric(input$variables) })
    Plot <- reactive({ as.numeric(input$plot) })
    predictor <- reactive({ as.numeric(input$predictor) })
    df <- reactive({ data.frame(V.Active.Min=predictor()) })
    predicted <- reactive({ round(as.numeric(predict(fit, newdata=df())),0) })
    
    # Generate head(n) of the dataset
    output$head <- renderTable({ 
        n_rows = as.numeric(input$n_rows)
#       head(data, n_rows)
    a <- data[sample(nrow(data), n_rows, replace = FALSE),]
    a[order(as.numeric(row.names(a))),]
    })
    
    # Generate a summary of the requested variables
    output$summary <- renderPrint({
         # summary(data[, variables()])
        if(length(variables() > 0)) {summary(data[, variables()])}
           else {
         cat('At least one variable must be checked to see a summary')}
    })
    
    output$boxPlot <- renderPlot({
        boxplot(data[Plot()], main="Data distribution", xlab=names(data[Plot()]))
    })
    
    output$predictedValue <- renderUI({
        HTML(paste('If, on a given day, the number of active minutes is <font color=\"blue\"><b>', 
                       predictor(), '</b></font> then, the predicted number of 
                    calories burned that day by that person is  <font color=\"blue\"><b>', 
                    predicted(), '</b></font>.' ))
    })

    output$scatterPlot <- renderPlot({
        with(data, plot(V.Active.Min, Cal.Burned, xlim=c(0,205), ylim=c(1750, 3500),
                          main='Calories burned vs. very active Minutes',
                          ylab='Calories burned', xlab='Very active minutes (daily)'))
        abline(fit, col='grey55')
        points(predictor(), predicted(), pch=19, col='blue', cex=1.7)
        legend('bottomright', 'predicted point', col='blue', pch=19)
    
    })

})