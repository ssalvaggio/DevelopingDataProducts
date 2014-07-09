library(shiny)

shinyUI(fluidPage(
    titlePanel('Monitoring of Daily Physical Activity and Calories Burned'),
    p('Salvino A. Salvaggio, PhD - July 2014'),br(),
    # Info
    h4('Supporting documentation'),
        p('The World Health Organisation consider that obesity, diabetes, and 
          hypertension are a new plague that is going to cause millions of deaths 
          and sick people as well as a dramatic --and unsustainable-- increase 
          in healthcare costs. The Center for Diseae Control and Prevention', 
          a(href='http://www.cdc.gov/obesity/data/adult.html', 'estimated'),
          'that the annual medical 
          cost of obesity in the U.S. was $147 billion in 2008 U.S. dollars, while 
          the medical costs for people who are obese were $1,429 higher than those of normal weight. 
          Fortunately, prevention of chronic metabolic diseases is quite simple: 
          a lifelong balanced nutrition coupled with an active lifestyle are mostly
          sufficient to protect us.'),
        p('The data analyzed come from a Fitbit activity monitor and Fitbit 
            app installed on a smartphone. Each row provides the daily figures for several variables 
            collected on one single individual over the period 24 Nov 2013 - 10 May 2014. 
            The dataset used here is a subset of a much larger dataset (many more variables).
            Complete dataset and info available ', 
            a(href='https://dl.dropboxusercontent.com/u/278538/Fitbit_data_20140621.zip', 'here'),'.'),
        p('To interact with this page, you can use the widgets in the lefthand column: 
             \'Overview\' allows to select how many rows of the dataset you want to preview;
            in \'Summary\' you can choose the variables to summarize and display; \'Boxplot\' 
            and the related Boxplot tab let you choose which variable to see as a boxplot; and \'Prediction\'
            requires a number of minutes as a predictor and predicts the expected daily calories
            burned accordingly and plot the outcome.'),
    br(),
    
    sidebarLayout(
        sidebarPanel(
            # Input number of rows to visualize        
                    h4('Overview'),
                    selectInput(inputId = 'n_rows', h5('Number of observations to view:'), 
                                c('5 rows' = 5, '10 rows' = 10, '20 rows' = 20), 
                                selected=5),
                    HTML('<hr style="border-color: lightgrey;">'),
            
            # Select variables to appear in summary
                    h4('Summary'),
                        checkboxGroupInput('variables', 
                                        label = h5('Choose variable(s) to be summarized:'), 
                                        c('Calories In'= 2, 'Calories Burned' = 3, 'Daily Steps' = 4, 
                                          'Walked Distance (km)' = 5,
                                          'Very Active Minutes' = 6),
                                        selected = 2:4),
                    HTML('<hr style="border-color: lightgrey;">'),

            # Select variables to be plot
            h4('Boxplot'),
            radioButtons('plot', 
                               label = h5('Choose variable to be plotted:'), 
                               c('Calories In'= 2, 'Calories Burned' = 3, 'Daily Steps' = 4, 
                                 'Walked Distance (km)' = 5,
                                 'Very Active Minutes' = 6),
                               selected = 2),
            HTML('<hr style="border-color: lightgrey;">'),
            
            # Choose number of mins to feed prediction model (lm)
                    h4('Prediction'),
                    sliderInput('predictor', label = h5('Please, provide the number of ', em('very 
                                                      active minutes,'), 'then the model 
                                                      predicts the estimated
                                                      calories burned that day:'),
                                min = 0, max = 200, value = 60)
                      ),
        
        mainPanel(
            # Display output: dataset
                h4('Overview'),
                tableOutput('head'),

            HTML('<div style=\'background-color:#FAFAFA; padding:15px;\'>'),

            # Display output: summary stats

                tabsetPanel(type = 'tabs', selected = 'Summary',
                            tabPanel('Summary',
                                     h4('Summary'),
                                     br(),
                                     verbatimTextOutput('summary')
                                     ),
                            tabPanel('Boxplot', 
                                     h4('Boxplot'),
    
                                     plotOutput('boxPlot'))
                            ),
            
            HTML('</div>'),
            br(),
            
            # Display output: prediction based on lm
                h4('Prediction'),
                uiOutput('predictedValue'),
                plotOutput('scatterPlot')   
        )
                    
    )
))