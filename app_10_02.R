# Author : Martin DORE
# Created : June 8, 2023
# Last Modified : January 10, 2024




############ LIBRAIRIES #############
# For each library, install corresponding package if not already installed
if(!require(shiny))
  install.packages("shiny")
library(shiny)

if(!require(shinyjs))
  install.packages("shinyjs")
library(shinyjs)

if (!require(shinythemes))
  install.packages("shinythemes")
library(shinythemes)

if (!require(readxl))
  install.packages("readxl")
library(readxl)

if (!require(dplyr))
  install.packages("dplyr")
library(dplyr)

if (!require(bslib))
  install.packages("bslib")
library(bslib)

if (!require(zoo))
  install.packages("zoo")
library(zoo)

if (!require(ggplot2))
  install.packages("ggplot2")
library(ggplot2)

if (!require(progress))
  install.packages("progress")
library(progress)

if (!require(openxlsx))
  install.packages("openxlsx")
library(openxlsx)

if (!require(lmerTest))
  install.packages("lmerTest")
library(lmerTest)

if (!require(emmeans))
  install.packages("emmeans")
library(emmeans)

if(!require(cowplot))
  install.packages("cowplot")
library(cowplot)

if(!require(crayon))
  install.packages("crayon")
library(crayon)

if(!require(plotly))
  install.packages("plotly")
library(plotly)

############################################### -----



###################### UI #####################
ui <- navbarPage( # pour avoir plusieurs pages (tabPanels)
  useShinyjs(),
  
  
  # Choose theme
  theme = shinytheme("flatly"),
  # Application title
  title = "Lactation Curves",
  
  ## Page n°1  : Data Cleaning ----
  # tabPanel("Data Cleaning",
  #          h4("Before uploading your \"Raw\" data make sure you have the right
  #             naming for the columns."),
  #          h4("Column's order don't have importance."),
  #          div(
  #            HTML('<table>
  #              <tr>
  #                <th>Wrong name</th>
  #                <th>  -->  </th>
  #                <th>  Good name</th>
  #              </tr>
  #              <tr>
  #                <td>Production Date</td>
  #                <td></td>
  #                <td>Date</td>
  #              </tr>
  #              <tr>
  #                <td>Production</td>
  #                <td></td>
  #                <td>Daily_MY</td>
  #              </tr>
  #              <tr>
  #                <td>Lactation Rank</td>
  #                <td></td>
  #                <td>LN</td>
  #              </tr>
  #              <tr>
  #                <td>Cow ID</td>
  #                <td></td>
  #                <td>ID</td>
  #              </tr>
  #              <tr>
  #                <td>Treatment</td>
  #                <td></td>
  #                <td>TRT</td>
  #              </tr>
  #            </table>')
  #          ),
  #          
  #          # line separator
  #          hr(style = "border-top: 1px solid #A9A9A9;"),
  #          
  #          # Select Data file
  #          fileInput(inputId = "fileRaw",
  #                    label = "Upload RAW data (.xlsx)",
  #                    accept = c(".xlsx")),
  #          
  #          #line separator
  #          hr(style = "border-top: 1px solid #A9A9A9;"),
  #          
  #          #head of cleaned data
  #          verbatimTextOutput("head_cleaned"),
  #          
  #          # Action Button download 
  #          downloadButton("downloadCleaned", "Download Cleaned Data"),
  #          
  #          #line separator
  #          hr(style = "border-top: 1px solid #A9A9A9;"),
  # ),
  ## Page n°2 : Data Importation + Outliers ----
  tabPanel("Data Importation",
           
           # Side bar Menu
           sidebarLayout(
             sidebarPanel(
               # Select Data file
               fileInput(inputId = "fileData",
                         label = "Upload CLEANED data (.xlsx)",
                         accept = c(".xlsx")),
               
               # Checkbox to indicate if there is only one lactation
               # checkboxInput("one_lact", "Only one lactation"),
               
               # Select Metadata file
               fileInput(inputId = "fileMeta",
                         label = "Upload MetaData (.xlsx)",
                         accept = c(".xlsx")),
               
               # List of cows
               selectInput("id", "Select Cow", choices = NULL),
               
               # Checkboxes to remove outliers
               checkboxGroupInput("num_lact",
                                  "Remove Outliers : select lactation(s)",
                                  choices = NULL,
                                  selected = NULL),
               checkboxInput("complete_cow", "COW"),
               
               # Action Button Remove
               actionButton("remove", "Remove !"),
               
               # Horizontal line separator 
               hr(style = "border-top: 1px solid #A9A9A9;"),  
               
               
               # checkbox to indicate if we want to alter all data or only selected cow 
               checkboxInput("all_cows", "All Cows"),
               p("If [All Cows] is selected, modifications will impact all dataframe
                 (default only selected cow) "),
               
               # Horizontal line separator 
               hr(style = "border-top: 1px solid #A9A9A9;"),
               
               # Date Range selector
               dateRangeInput("date_range_keep", 
                              "Select starting and ending date to keep"),
               
               # Action Button keep from date
               actionButton("keep_date", 'Select date'),
               
               # Date Range selector
               dateRangeInput("date_range_remove", 
                              "Select starting and ending date to remove"),
               
               # Action Button keep from date
               actionButton("remove_date", 'Remove date'),               
               
               # horizontal line separator
               hr(style = "border-top: 1px solid #A9A9A9;"),
               
               sliderInput("sliderDIM", "Choose DIM (last lactation)",
                           min = 0, max = 300, value = c(25,50)),
               actionButton("remove_dim", "Remove DIM"),
               
               # horizontal line separator
               hr(style = "border-top: 1px solid #A9A9A9;"),   
               
               # Action Button download 
               downloadButton("downloadData", "Download DataSet")
             ),
             # Main Panel with plot and table
             mainPanel(
               tabsetPanel(
                 tabPanel("Plot",
                          # Visualisation plot
                          plotOutput("plotLN"),
                          # line separator
                          hr(style = "border-top: 1px solid #A9A9A9;"),
                          # histogram
                          plotlyOutput("hist_ln_trt"),
                          #line separator
                          hr(style = "border-top: 1px solid #A9A9A9;"),
                          h3("Summary (during trial)"),
                          # summary
                          verbatimTextOutput("dataTRT"),
                 ),
                 tabPanel("Table",
                          # Data Table for selected cow
                          dataTableOutput("dataCow")
                 )
               )
             )
           )
  ),
  
  ## Page n°3 : Visualisation ----
  tabPanel("Visualisation",
           
           #plot Daily_My vs LN
           plotOutput("plot_meanLN"),
           # horizontal line separator
           hr(style = "border-top: 1px solid #A9A9A9;"),
           
           h1("Visualisation of Production for last lactation (during trial)"),
           plotlyOutput("plot_ln_trt_no_facet"),
           plotlyOutput("plot_ln_trt_facet"),
           plotlyOutput("plot_ln_trt_stat_sum"),
           hr(style = "border-top: 1px solid #A9A9A9;"),
           
           
           # plot production vs ln vs trt
           plotlyOutput("plot_prod_ln_trt"),
           
           hr(style = "border-top: 1px solid #A9A9A9;"),
           # plo production vs ln vs trt
           plotlyOutput("plot_prod_ln4_trt"),
           
           hr(style = "border-top: 1px solid #A9A9A9;"),
           # plo production vs ln vs trt
           plotlyOutput("plot_prod_trt_ln4"),
           
           hr(style = "border-top: 1px solid #A9A9A9;"),
           # plo production vs ln vs trt
           plotlyOutput("plot_prod_trt"),
           
           hr(style = "border-top: 1px solid #A9A9A9;"),
           # plot production vs ln n & n-1 vs trt
           plotlyOutput("plot_n_n1"),
  ),
  
  ## Page n°4 : Stats ----
  tabPanel("Statistical Analysis",
           sidebarLayout(
             sidebarPanel(
               # Selector for limit between old and young multiparous
               sliderInput("age_limit",
                           "Select limit between YOUNG/OLD Multiparous (>)",
                           min = 1,
                           max = 7,
                           value = 2,
                           step = 1),
               p("Value is stored in Lactation_Rank variable"),
               # indicating available variables
               selectizeInput("var_lmer", "Available Variable", choices = NULL, selected = NULL, multiple = T),
               
               # text input for model's formula
               textInput("txt_lmer",
                         "Enter model's formula",
                         value = "Daily_MY_smooth ~ as.factor(DIM)* TRT.x+ LN.x * TRT.x +(1|ID)"),
               actionButton("build_model", "Build Model"),
               
             ),
             mainPanel(
               plotlyOutput("plot_lmer"),
               # dataTableOutput("df_pred"),
               h3("Anova of the model : "),
               tableOutput("summary_lmer"),
               
               h3("Emmeans of the model : "),
               tableOutput("emmeans_lmer"),
               tableOutput("contrast_lmer"),
               hr(style = "border-top: 1px solid #A9A9A9;"),
               
               
               tableOutput("emmeans_lmer_ln"),
               tableOutput("contrast_lmer_ln"),
               hr(style = "border-top: 1px solid #A9A9A9;"),
               
               tableOutput("emmeans_lmer_trt"),
               tableOutput("contrast_lmer_trt")
               
             )
           )
  ),
  
  ## Page n°5 : Indicators creation ----
  tabPanel("Indicators Creation",
           sidebarLayout(
             sidebarPanel(
               actionButton("create_indic", "Create indicators"),
               downloadButton("downloadIndic", "Download indicators")
             ),
             mainPanel(
               tableOutput("sum_indic"),
               plotOutput("boxplot_indic"),
               h3("Mean of indicators"),
               tableOutput("mean_indic"),
               hr(style = "border-top: 1px solid #A9A9A9;"),
               
               h3("ANOVA on indicators"),
               verbatimTextOutput("ANOVA_indic"),
             )
           ))
)
#########################################################




###################### SERVER ###########################
server <- function(input, output, session) {
  # define maximum size for input files
  options(shiny.maxRequestSize=10000*1024^2)
  
  # define reactive values (common to UI and SERVER)
  values = reactiveValues(df = NULL,
                          df_meta = NULL,
                          df_cleaned = NULL,
                          df_TRT = NULL,
                          df_lmer = NULL,
                          df_pred_lmer = NULL,
                          mod_lmer = NULL,
                          summary_indicators = NULL)
  
  ## ------------- DATA CLEANING ----------------
  observeEvent(input$fileRaw, {
    tryCatch({
      raw = read_excel(input$fileRaw$datapath)
      
      # modifying columns types
      raw$ID = as.factor(raw$ID)
      raw$Date = as.Date(raw$Date)
      
      # Removing rows whithout MY values or zeros value
      raw$Daily_MY[raw$Daily_MY==0] = NA
      raw = raw[complete.cases(raw$Daily_MY),]
      
      # Changing TRT for previous lactation
      # if cow is treated, it is only for last lactation
      raw = na.omit(raw)
      raw = raw %>%
        group_by(ID) %>%
        mutate(maxLN = max(LN))
      
      raw = raw %>% mutate(TRT = ifelse(LN < maxLN, "CTRL", TRT))
      raw = raw %>% select(-maxLN)
      
      values$df_cleaned = raw
      showNotification("Cleaned_Data is ready to be downloaded", type = "message" )
    },error = function(e){
      showNotification("Wrong type of file", type = "error")
      reset("fileRaw")
    })
    
  })
  
  
  ### ---- Downloading cleaned data ----
  output$downloadCleaned = downloadHandler(
    filename = "_Cleaned.xlsx",
    content = function(file){
      openxlsx::write.xlsx(values$df_cleaned, file)
    }
  )
  
  output$HeadMeta <- renderImage({
    # Specify the image file path or URL
    filename <- "Head_Meta.PNG"
    
    # Return a list containing the necessary information about the image
    list(src = filename, contentType = "image/jpeg")
  }, deleteFile = FALSE)
  
  output$HeadRaw <- renderImage({
    # Specify the image file path or URL
    filename <- "Head_Raw.PNG"
    
    # Return a list containing the necessary information about the image
    list(src = filename, contentType = "image/jpeg")
  }, deleteFile = FALSE)
  
  
  # Head of data_cleaned
  output$head_cleaned = renderPrint({
    req(input$fileRaw)
    head(values$df_cleaned)
  })
  
  #-------------- DATA IMPORTATION --------------
  # Data file
  observeEvent(input$fileData, {
    tryCatch({
      data = read_excel(input$fileData$datapath)
      
      data$TRT <- as.factor(data$TRT)
      data$ID <- as.factor(data$ID)
      data$Date <- as.Date(data$Date)
      
      data = data[complete.cases(data$Daily_MY),]
      
      data = data %>% 
        group_by(ID, LN) %>% 
        mutate(Daily_MY_smooth = rollmean(x = Daily_MY, 3, fill=NA))
      
      # data = data[complete.cases(data) & is.finite(data), ]
      data = data %>% group_by(ID) %>% 
        mutate(maxLN = max(LN))
      
      # Suppression des NAs
      values$df = na.omit(data)
      
      # creating df_TRT 
      # for each cow keep only last lactation and previous one
      df_previous = data %>%
        group_by(ID) %>% 
        filter(LN == maxLN-1) %>% 
        mutate(Prev_Daily_MY = Daily_MY_smooth) %>% 
        select(-Daily_MY, -Daily_MY_smooth)
      df_last = data %>%
        group_by(ID) %>% 
        filter(LN == maxLN)
      df_TRT = df_last %>% 
        right_join(df_previous, by = c("ID", "DIM"))
      df_TRT = df_TRT %>% 
        mutate(Gap_Daily_MY = Daily_MY_smooth - Prev_Daily_MY)
      df_TRT <- df_TRT %>%
        group_by(ID) %>%
        filter(row_number() <= 100) %>%
        ungroup()
      
    },
    error = function(e){
      showNotification("Wrong type of file", type = "error")
      # values$df = NULL
      reset("fileData")  
    })
    
    tryCatch({
      df_TRT <- df_TRT %>%
        group_by(ID) %>%
        mutate(Trend_Loess = predict(loess(Daily_MY ~ DIM, span = 0.5), newdata = data.frame(DIM)))
      
      df_TRT = df_TRT[complete.cases(df_TRT$Daily_MY_smooth),]
      
      df_TRT = df_TRT %>% 
        mutate(Week = ceiling(DIM / 7))
      
      values$df_TRT = df_TRT
      message("data ok")
    }, error = function(e){
      showNotification("Error Loess, verify one lactation", type = "error")
    })
    
    
  })
  
  # MetaData file
  observeEvent(input$fileMeta, {
    tryCatch({
      meta = read_excel(input$fileMeta$datapath)
      
      meta$Calving_Date = as.Date(meta$Calving_Date)
      meta$Start_LSC = as.Date(meta$Start_LSC)
      meta$End_LSC = as.Date(meta$End_LSC)
      meta$ID = as.factor(meta$ID)
      message("meta ok")
      values$df_meta = meta
    },error = function(e){
      showNotification("Wrong type of file", type = "error")
      reset("fileMeta")
      # reset("fileData")
    })
  })
  
  
  # Adding information from the MetaData
  # Define a reactive value to track if the event has already been executed
  eventExecuted <- reactiveVal(FALSE)
  
  observeEvent({
    input$fileData
    input$fileMeta
  },
  {
    if (!eventExecuted() && !is.null(input$fileData) && !is.null(input$fileMeta)) {
      # Combining meta and df
      meta <- values$df_meta
      df_TRT <- values$df_TRT
      
      df_TRT <- df_TRT %>% 
        left_join(meta, by = join_by(ID))
      
      # Removing post treatment data for last lactation
      df_TRT <- df_TRT[!(df_TRT$Date.x >= df_TRT$Calving_Date & df_TRT$Date.x <= df_TRT$Start_LSC & df_TRT$Date.x >= df_TRT$End_LSC), ]
      
      values$df_TRT <- na.omit(df_TRT)
      
      # Set the eventExecuted reactive value to TRUE to indicate that the event has been executed
      eventExecuted(TRUE)
    }
  },
  ignoreInit = TRUE
  )
  
  
  
  # Update ID selection
  observe({
    updateSelectInput(session, "id", choices = unique(values$df$ID))
  })
  
  # Update checkboxes with corresponding lactation numbers
  observeEvent(df_cow(), {
    choices = unique(df_cow()$LN)
    choices = sort(choices, decreasing = T) 
    updateCheckboxGroupInput(session, "num_lact", choices = choices)
  })
  
  # Subdataframe with chosen cow
  df_cow = reactive({
    return(subset(values$df, values$df$ID == input$id))
  })
  
  #Plot Lactation Curves 
  output$plotLN = renderPlot({
    req(input$fileData)
    #req(input$fileMeta)
    df_cow = df_cow()
    plot(x=1:200, rep(0,200),
         main = paste("Evolution of Daily_MY depending on Lactation Number                  for cow : ", input$id),
         ylim = c(0,75), ylab = "Daily MY",
         xlim = c(0,300), xlab = "DIM",
         col = 0
    )
    # Set symbol types
    symbols <- 1:7
    # Add lines with symbols
    for (ln in 1:7) {
      df_ln = df_cow %>% filter(LN == ln)
      lines(x = df_ln$DIM,
            y = df_ln$Daily_MY,
            col = ln,
            pch = symbols[ln],
            type="o",
            cex = 0.5,
            ylim = c(0, 75)
      )
      
    }
    # Add legend with symbols and colors
    legend("bottomright",
           legend = 7:1,
           col = 7:1,
           lty = 1,
           lwd = 2,
           pch = symbols)
  })
  
  # Remove selected outliers in data 
  observeEvent(input$remove, { 
    req(input$fileData)
    
    complete_cow = input$complete_cow
    if(complete_cow){ #if "all cow" button is selected
      temp = values$df[!values$df$ID == input$id,]
      values$df = temp
    }
    else{ #if only some lactations are selected
      temp = values$df[!(values$df$ID==input$id & values$df$LN %in% input$num_lact),]
      values$df = temp
    }
    # Uncheck 'COW' checkox
    updateCheckboxInput(session, "complete_cow", value = FALSE)
  })
  
  # Keep data from selected dates
  observeEvent(input$keep_date, {
    req(input$fileData)
    
    start_date = input$date_range_keep[1]
    end_date = input$date_range_keep[2]
    
    # if modifications are on all cows
    if(input$all_cows){
      temp = subset(values$df, (Date >= start_date) & (Date <= end_date))
    }
    else{
      temp = subset(values$df,  ID != input$id | (Date >= start_date) | (Date <= end_date))
    }
    values$df = temp
  })
  
  
  # Remove data from selected dates
  observeEvent(input$remove_date, {
    req(input$fileData)
    
    start_date = input$date_range_remove[1]
    end_date = input$date_range_remove[2]
    
    # if modifications are on all cows
    if(input$all_cows){
      temp = subset(values$df, (Date < start_date) | (Date > end_date))
    }
    else{
      temp = subset(values$df,  ID != input$id | (Date >= start_date) | (Date <= end_date))
    }
    values$df = temp
  })
  
  # Remove data from selected DIM (for last lactation)
  observeEvent(input$remove_dim, {
    req(input$fileData)
    start_dim = input$sliderDIM[1]
    end_dim = input$sliderDIM[2]
    max_ln = df_cow()$maxLN[1]
    message(max_ln)
    # if modifications are on all cows
    if(input$all_cows){
      temp = subset(values$df,(DIM < start_dim) | (DIM > end_dim) |LN != maxLN)
    }
    else{
      max_ln = df_cow()$maxLN[1]
      temp = subset(values$df,  ID != input$id | (DIM < start_dim) | (DIM > end_dim) |LN != max_ln)
    }
    values$df = temp
  })
  
  observeEvent({
    input$one_lact
  },
  {
    message("one lact ok")
  })
  
  # update df_TRT after deleting some rows or selecting one_lact
  observeEvent({
    input$one_lact
    
    input$remove_date
    input$keep_date
    input$remove
    input$remove_dim
  },{
    req(input$fileData)
    data = values$df
    # creating df_TRT 
    # for each cow keep only last lactation an previous one
    
    if(!input$one_lact){ # if there is more than one lactation
      df_previous = data %>%
        group_by(ID) %>% 
        filter(LN == maxLN-1) %>% 
        mutate(Prev_Daily_MY = Daily_MY_smooth) %>% 
        select(-Daily_MY, -Daily_MY_smooth)
    }
    else{ # if there is only one lactation
      df_previous = data %>% 
        group_by(ID) %>% 
        filter(LN == maxLN) %>% 
        mutate(Prev_Daily_MY = Daily_MY_smooth) %>% 
        select(-Daily_MY, -Daily_MY_smooth)
    }
    
    df_last = data %>% group_by(ID) %>% 
      filter(LN == maxLN)
    df_TRT = df_last %>% 
      right_join(df_previous, by = c("ID", "DIM"))
    df_TRT = df_TRT %>% 
      mutate(Gap_Daily_MY = Daily_MY_smooth - Prev_Daily_MY)
    df_TRT <- df_TRT %>%
      group_by(ID) %>%
      filter(row_number() <= 100) %>%
      ungroup()
    
    
    tryCatch({
      df_TRT <- df_TRT %>%
        group_by(ID) %>%
        mutate(Trend_Loess = predict(loess(Daily_MY ~ DIM, span = 0.5), newdata = data.frame(DIM)))
      
    }, error = function(e){
      showNotification("Error Loess, verify one lactation", type = "error")
    })
    
    
    df_TRT = df_TRT[complete.cases(df_TRT$Daily_MY_smooth),]
    
    df_TRT = df_TRT %>% 
      mutate(Week = ceiling(DIM / 7))
    
    values$df_TRT = df_TRT
    message("data ok")
    
    
    df_TRT = df_TRT %>% 
      mutate(Week = ceiling(DIM / 7))
    df_TRT = df_TRT[complete.cases(df_TRT$Daily_MY_smooth),]
    
    if(input$one_lact){
      names(df_TRT)[names(df_TRT) == 'TRT'] <- 'TRT.x'
    }
    values$df_TRT = df_TRT
  })
  
  
  
  
  # --- Downloading dataset into excel sheet ---
  output$downloadData = downloadHandler(
    filename = 'Removed_Outliers.xlsx',
    content = function(file){
      openxlsx::write.xlsx(values$df, file)
    }
  )
  
  # Data table for selected cow
  output$dataCow = renderDataTable({
    df_cow()
  })
  
  # Summary of df_TRT
  output$dataTRT = renderPrint({
    req(input$fileData)
    summary(values$df_TRT)
  })
  
  # Plot with daily mean of production for each LN
  output$plot_meanLN = renderPlot({
    req(input$fileData)
    
    df_ln = list()
    mean_ln = list()
    for(i in unique(values$df$LN)){
      df_i = values$df %>% filter(LN == i)
      df_ln[[i]] = df_i
      mean_ln[i] = df_i %>%
        group_by(DIM) %>% 
        summarise(Daily_Mean = mean(Daily_MY)) %>% 
        select(Daily_Mean)
    }
    i = 0
    plot(x=1:200, rep(0,200),
         main = "Evolution of Daily_MY depending on Lactation Number",
         ylim = c(0,70), ylab = "Avg Daily MY",
         xlim = c(0,300), xlab = "DIM",
         col = 0)
    for(m in mean_ln){
      i = i + 1
      lines(x= 1:length(m), y = m, col = i)
    }
    legend("bottomright", legend=sort(unique(values$df$LN), decreasing = T),
           col=sort(unique(values$df$LN), decreasing = T), lty=1, lwd=2)
  })
  
  # -------- LAST LACTATION VIZ -----------
  # Plot PRODUCTION vs TRT vs LN
  output$plot_prod_ln_trt = renderPlotly({
    req(input$fileData)
    
    df_TRT = values$df_TRT
    # Convert LN.x to factor
    df_TRT$LN.x <- as.factor(df_TRT$LN.x)
    
    # Create the plot
    p <- ggplotly(
      ggplot(df_TRT) +
        geom_smooth(aes(x = DIM, y = Daily_MY_smooth, color = LN.x)) +
        facet_wrap(~ TRT.x) +
        labs(title = "Production vs TRT vs LN") +
        theme(legend.title = element_blank()) +
        theme(legend.position = "right") +
        scale_color_manual(values = unique(df_TRT$LN.x),
                           labels = unique(df_TRT$LN.x),
                           name = "LN.x") + 
        theme_classic()
    )
    # Display the plot
    p
  })
  
  output$plot_ln_trt_facet = renderPlotly({
    req(input$fileData)
    
    plot = ggplotly(
      ggplot(data = values$df_TRT, aes(x=DIM, y=Daily_MY))+
        geom_line(aes(alpha = 0.2, color = TRT.x, group=ID), show.legend = F, linewidth = 0.25)+
        stat_summary(aes(group = TRT.x, color = TRT.x), geom = "line", fun = mean, size = 2)+
        scale_color_manual(values = c("#A6A6A6","#00B050")) +
        facet_wrap(~LN.x) +
        ggtitle("Evolution of Daily_MY by parity (during trial)") +
        theme_classic()
    )
    plot
  })
  
  output$plot_ln_trt_no_facet = renderPlotly({
    req(input$fileData)
    
    plot =ggplotly(
      ggplot(data = values$df_TRT, aes(x=DIM, y=Daily_MY))+
        geom_line(aes(alpha = 0.2, color = TRT.x, group=ID), show.legend = F, linewidth = 0.25)+
        stat_summary(aes(group = TRT.x, color = TRT.x), geom = "line", fun = mean, size = 2)+
        scale_color_manual(values = c("#A6A6A6","#00B050")) +
        ggtitle("Evolution of Daily_MY (during trial)") +
        theme_classic()
    )
    
    plot
  })
  
  
  output$plot_ln_trt_stat_sum = renderPlotly({
    req(input$fileData)
    
    plot = ggplotly(
      ggplot(data = values$df_TRT)+
        stat_summary(aes(group = TRT.x, color = TRT.x, x = DIM, y = Daily_MY), geom = "line", fun = mean, size = 2)+
        stat_summary(aes(group = TRT.x, color = TRT.x, x = DIM, y = Prev_Daily_MY, linetype = "dashed"), geom = "point", fun = mean, size = 1.5)+
        facet_wrap(~TRT.x) +
        scale_color_manual(values = c("#A6A6A6","#00B050")) +
        ggtitle("Evolution of Daily_MY (during trial : _ & previous lactation :..)") +
        theme_classic()
    )
    
    # plot = ggplot(data = values$df_TRT) +
    #   stat_summary(aes(group = TRT.x, color = TRT.x, x = DIM, y = Daily_MY, linetype = "Mean"), 
    #                geom = "line", fun = mean, size = 2) +
    #   stat_summary(aes(group = TRT.x, color = TRT.x, x = DIM, y = Prev_Daily_MY, shape = "Prev_Daily_MY"),
    #                geom = "point", fun = mean, size = 2) +
    #   facet_wrap(~TRT.x) + 
    #   scale_color_manual(name = "Treatment", values = c("#A6A6A6", "#00B050")) +
    #   scale_linetype_manual(name = "Summary Statistic", values = "solid", guide = guide_legend(override.aes = list(color = NA))) +
    #   scale_shape_manual(name = "Summary Statistic", values = 16, guide = guide_legend(override.aes = list(color = "black", linetype = "dashed"))) +
    #   ggtitle("Evolution of Daily_MY (during trial)") +
    #   theme_classic()
    plot
  })
  
  # Last lactation for Young Multiparous (LN < 4)
  output$plot_prod_ln4_trt = renderPlotly({
    req(input$fileData)
    
    df_TRT = values$df_TRT
    df_TRT$LN.x = as.numeric(df_TRT$LN.x)
    df_TRT_LN4 = df_TRT %>%  filter(LN.x < 4)
    df_TRT_LN4$LN.x = as.factor(df_TRT_LN4$LN.x)
    # Create the plot
    
    p <- ggplotly(
      ggplot(df_TRT_LN4) +
        geom_smooth(aes(x = DIM, y = Daily_MY, color = LN.x)) +
        facet_wrap(~ TRT.x) +
        labs(title = "Production vs TRT vs LN < 4") +
        theme(legend.title = element_blank()) +
        theme(legend.position = "right") +
        scale_color_manual(values = unique(df_TRT_LN4$LN.x),
                           labels = unique(df_TRT_LN4$LN.x),
                           name = "LN.x") + 
        theme_classic()
    )
    # Display the plot
    p
    
  })
  
  
  output$plot_prod_trt_ln4 = renderPlotly({
    req(input$fileData)
    
    df_TRT = values$df_TRT
    df_TRT$LN.x = as.numeric(df_TRT$LN.x)
    df_TRT_LN4 = df_TRT %>%  filter(LN.x < 4)
    df_TRT_LN4$LN.x = as.factor(df_TRT_LN4$LN.x)
    
    p <- ggplotly(
      ggplot(df_TRT_LN4) +
        geom_smooth(aes(x = DIM, y = Daily_MY_smooth, color = TRT.x)) +
        labs(title = "Production vs TRT for LN < 4") +
        theme(legend.title = element_blank()) +
        theme(legend.position = "right") +
        scale_color_manual(values = c( "#A6A6A6","#00B050"))+
        theme_classic()
    )
    # Display the plot
    p
  })
  
  
  output$plot_prod_trt = renderPlotly({
    req(input$fileData)
    df_TRT = values$df_TRT
    
    p <- ggplotly(
      ggplot(df_TRT) +
        geom_smooth(aes(x = DIM, y = Daily_MY_smooth, color = TRT.x)) +
        labs(title = "Production vs TRT") +
        theme(legend.title = element_blank()) +
        theme(legend.position = "right") +
        scale_color_manual(values = c( "#A6A6A6","#00B050")) +
        theme_classic()
    )
    # Display the plot
    p
  })
  
  
  # lactation n & n-1 vs TRT
  output$plot_n_n1 = renderPlotly({
    req(input$fileData)
    # req(!input$one_lact)
    
    df_TRT = values$df_TRT
    p <- ggplotly(
      ggplot(df_TRT) +  
        geom_smooth(aes(x = DIM, y = Daily_MY_smooth, color = TRT.x)) +
        geom_smooth(aes(x = DIM, y = Prev_Daily_MY, color = TRT.x), linetype = "dashed") +
        labs(title = "Production vs TRT with lactation n & n-1") +
        theme(legend.title = element_blank()) +
        theme(legend.position = "right") +
        scale_color_manual(values = c( "#A6A6A6","#00B050")) + 
        theme_classic()
    )
    # Display the plot
    p
  })
  
  
  # histogram
  output$hist_ln_trt = renderPlotly({
    req(input$fileData)
    
    summary_trt = values$df_TRT %>% 
      group_by(ID) %>% 
      summarise(TRT = TRT.x[1], LN = LN.x[1])
    
    p <- ggplotly(
      ggplot(summary_trt, aes(x=LN, fill=TRT)) +
        geom_bar( color="black", position = 'dodge', width = 0.75) +
        scale_fill_manual(values=c( "#A6A6A6","#00B050")) +
        scale_x_continuous(breaks = unique(summary_trt$LN)) +
        scale_y_continuous(breaks = 1:200, labels = scales::comma) +
        theme_classic() +
        labs(fill="", title = "Repartition of Lactation Number for last lactation (during trial)")
    )
    p
  })
  
  
  
  
  # updating available variables
  observeEvent(values$df_lmer,{
    updateSelectizeInput(session, "var_lmer", choices = names(values$df_lmer), selected = names(values$df_lmer))
  })
  
  # ---- LMER MODELS ----
  observeEvent(input$build_model, {
    # adding columns indicating wheter cow is "old" or not
    limit = input$age_limit
    
    tryCatch({
      values$df_lmer = values$df_TRT %>% 
        mutate(Lactation_Rank = ifelse(LN.x > limit, "OLD", "YOUNG"))
      values$df_lmer$Lactation_Rank = as.factor(values$df_lmer$Lactation_Rank)
      # Create and fit lmer model
      values$mod_lmer <- lmer(formula = as.formula(input$txt_lmer), 
                              control = lmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 1e5)),
                              data = values$df_lmer)
      # predict values
      values$df_pred_lmer <- data.frame(values$df_TRT, Prediction = predict(values$mod_lmer))
    }, error = function(e) {
      # Handle the error here
      showNotification("Invalid formula provided", type = "error")
    })
  })
  
  
  # plot result of prediction
  output$plot_lmer = renderPlotly({
    req(input$build_model)
    req(input$fileData)
    
    formula = input$txt_lmer
    
    if (grepl("DIM", formula)){
      plot = ggplot(data=values$df_pred_lmer, aes(x=DIM, y=Prediction, group=ID))+
        geom_point(aes(alpha=0.2), show.legend = F, size = 0.25)+
        geom_line(aes(alpha=0.2), show.legend = F, linewidth = 0.5)+
        stat_summary(aes(group=TRT.x, color = TRT.x), geom="line", fun=mean, size=2.5)+
        scale_color_manual(values=c("#A6A6A6","#00B050")) +
        facet_wrap(~TRT.x) +
        ggtitle("Prediction of Daily_MY", subtitle = paste("with  formula : ", input$txt_lmer )) +
        theme_classic()
    }
    else{
      plot = ggplot(data=values$df_pred_lmer, aes(x=Week, y=Prediction, group=ID))+
        geom_point(aes(alpha=0.2), show.legend = F, size = 0.25)+
        geom_line(aes(alpha=0.2), show.legend = F, linewidth = 0.5)+
        stat_summary(aes(group=TRT.x, color = TRT.x), geom="line", fun=mean, size=2.5)+
        scale_color_manual(values=c("#A6A6A6","#00B050")) +
        facet_wrap(~TRT.x) +
        ggtitle("Prediction of Daily_MY", subtitle = paste("with  formula : ", input$txt_lmer )) +
        theme_classic()
    }
    ggplotly(plot)
  })
  
  output$df_pred = renderDataTable({
    req(input$fileData)
    values$df_pred_lmer
  })
  
  # table result of prediction
  output$summary_lmer = renderTable({
    req(input$build_model)
    req(input$fileData)
    
    anova_lmer<- as.data.frame(anova(values$mod_lmer))[, c(3, 6)] %>%
      mutate(Variable = rownames(.)) %>%
      relocate(Variable, .before = NumDF)
    
    anova_lmer
  },
  rownames = T)
  
  # table output for emmeans
  output$emmeans_lmer = renderTable({
    req(input$build_model)
    req(input$fileData)
    
    formula = input$txt_lmer
    if (grepl("DIM", formula) & !grepl("Week", formula)){ # if formula contains DIM
      emmeans_lmer <- as.data.frame(emmeans(values$mod_lmer, pairwise ~ TRT.x | DIM, adjust = "Tukey")$emmeans)[,1:7]
    }
    else if(grepl("Week", formula) &  !grepl("DIM", formula)){ # if formula contains Week
      emmeans_lmer = as.data.frame(emmeans(values$mod_lmer, pairwise ~ TRT.x | Week, adjust = "Tukey")$emmeans)[,1:7]
    }
    else # default : NULL
    {
      emmeans_lmer = as.data.frame(NULL)
    }
    
    emmeans_lmer
  })
  
  # pvalues for precedent emmeans
  output$contrast_lmer = renderTable({
    req(input$build_model)
    req(input$fileData)
    
    formula = input$txt_lmer
    if (grepl("DIM", formula) & !grepl("Week", formula)){ # if formula contains DIM
      contrast <- as.data.frame(emmeans(values$mod_lmer, pairwise ~ TRT.x | DIM, type = "response")$contrasts)[, c(1,2,7)]
    }
    else if(grepl("Week", formula) &  !grepl("DIM", formula)){ # if formula contains Week
      contrast <- as.data.frame(emmeans(values$mod_lmer, pairwise ~ TRT.x | Week, type = "response")$contrasts)[, c(1,2,7)]
    }
    else # default : NULL
    {
      contrast = as.data.frame(NULL)
    }
    contrast
  })
  
  # emmeans depending on lactation rank
  output$emmeans_lmer_ln = renderTable({
    req(input$build_model)
    req(input$fileData)
    
    formula = input$txt_lmer
    if (grepl("Lactation_Rank", formula)){ # if formula contains Lactation_Rank
      emmeans_lmer <- as.data.frame(emmeans(values$mod_lmer, pairwise ~ TRT.x | Lactation_Rank, adjust = "Tukey")$emmeans)[,1:7]
    }
    else # default : NULL
    {
      emmeans_lmer = as.data.frame(NULL)
    }
    
    emmeans_lmer
  })
  
  # pvalues for precedent emmeans
  output$contrast_lmer_ln = renderTable({
    req(input$build_model)
    req(input$fileData)
    
    formula = input$txt_lmer
    if (grepl("Lactation_Rank", formula)){ # if formula contains Lactation_Rank
      contrast <- as.data.frame(emmeans(values$mod_lmer, pairwise ~ TRT.x | Lactation_Rank, type = "response")$contrasts)[, c(1,2,7)]
    }
    else # default : NULL
    {
      contrast = as.data.frame(NULL)
    }
    contrast
  })
  
  
  
  # emmeans depending on TRT
  output$emmeans_lmer_trt = renderTable({
    req(input$build_model)
    req(input$fileData)
    
    emmeans_lmer <- as.data.frame(emmeans(values$mod_lmer, pairwise ~ TRT.x, adjust = "Tukey")$emmeans)[,1:6]
    
    emmeans_lmer
  })
  
  # pvalue for precedent emmeans
  output$contrast_lmer_trt = renderTable({
    req(input$build_model)
    req(input$fileData)
    contrast <- as.data.frame(emmeans(values$mod_lmer, pairwise ~ TRT.x, type = "response")$contrasts)[, c(1,2,6)]
    contrast
  })
  
  
  
  # ---- INDICATORS CREATION ----
  output$sum_indic = renderTable({
    req(input$fileData)
    req(input$create_indic)
    
    summ_indic = values$df_TRT %>% 
      group_by(ID) %>%
      summarise(MaxMY_Trend = max(Trend_Loess),
                DIM_Max_MY = which.max(Trend_Loess),
                TRT= TRT.x[1],
                Slope_Before_Peak = (MaxMY_Trend - Daily_MY_smooth[1]) / (DIM_Max_MY - DIM[1]),
                Slope_After_Peak = (Daily_MY_smooth[n()] - MaxMY_Trend) / (DIM[n()] - DIM_Max_MY)) %>%
      filter(is.finite(MaxMY_Trend),
             is.finite(DIM_Max_MY),
             is.finite(TRT),
             is.finite(Slope_Before_Peak),
             is.finite(Slope_After_Peak))
    
    # summ_indic_clean <- summ_indic[is.finite(rowSums(summ_indic)) & complete.cases(summ_indic), ]
    
    values$summary_indicators = summ_indic
    return(head(summ_indic, n = 5))
  })
  
  
  # ANOVA + emmeans on indicators
  output$ANOVA_indic = renderPrint({
    req(input$fileData)
    req(input$create_indic)
    summ_indic = values$summary_indicators
    
    study_vars = c("MaxMY_Trend", "DIM_Max_MY", "Slope_Before_Peak", "Slope_After_Peak")
    # perform lm models + ANOVA + emmans on each var
    for(var in study_vars){
      formula = as.formula(paste(var, "~TRT"))
      model_lm = lm(formula, data = summ_indic)
      cat("-------------", var, "-------------\n" )
      cat("\n--- ANOVA --- :\n")
      print(anova(model_lm))
      cat("\n---- EMMEANS --- :\n")
      print(emmeans(model_lm, pairwise ~ TRT))
    }
  })
  
  
  # Means of indicators
  output$mean_indic = renderTable({
    req(input$fileData)
    req(input$create_indic)
    summ_indic = values$summary_indicators
    
    # Display means of each variable based on TRT status
    means <- aggregate(summ_indic[, c("MaxMY_Trend", "DIM_Max_MY", "Slope_Before_Peak", "Slope_After_Peak")], by = list(TRT = summ_indic$TRT), FUN = mean)
    colnames(means)[1] <- "TRT"  # Rename the grouping column
    
    # Display the means
    means
  })
  
  
  output$downloadIndic = downloadHandler(
    filename = "_Indicators.xlsx",
    content = function(file){
      openxlsx::write.xlsx(values$summary_indicators, file)
    }
  )
  
  output$boxplot_indic = renderPlot({
    req(input$fileData)
    req(input$create_indic)
    
    # Boxplot for MaxMY_Trend
    p1 <- ggplot(data = values$summary_indicators, aes(x = TRT, y = MaxMY_Trend, fill = TRT)) +
      geom_boxplot() +
      scale_fill_manual(values = c("#A6A6A6", "#00B050")) +
      theme_minimal()
    
    # Boxplot for DIM_Max_MY
    p2 <- ggplot(data = values$summary_indicators, aes(x = TRT, y = DIM_Max_MY, fill = TRT)) +
      geom_boxplot() +
      scale_fill_manual(values = c("#A6A6A6", "#00B050")) +
      theme_minimal()
    
    # Boxplot for Slope before peak
    p3 <- ggplot(data = values$summary_indicators, aes(x = TRT, y = Slope_Before_Peak, fill = TRT)) +
      geom_boxplot() +
      scale_fill_manual(values = c("#A6A6A6", "#00B050")) +
      theme_minimal()
    
    # Boxplot for Slope after peak
    p4 <- ggplot(data = values$summary_indicators, aes(x = TRT, y = Slope_After_Peak, fill = TRT)) +
      geom_boxplot() +
      scale_fill_manual(values = c("#A6A6A6", "#00B050")) +
      theme_minimal()
    
    # Combine the plots
    plot_combined <- plot_grid(p1, p2,p3,p4,  ncol = 2)
    
    # Display the combined plots
    plot_combined
  })
  
}
##################################################



################## RUN APP #####################
# Add show case options to run with code appearing
shinyApp(ui, server, options = list())
#shinyApp(ui, server, options = list(display.mode = "showcase"))
################################################