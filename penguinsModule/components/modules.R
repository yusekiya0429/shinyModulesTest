
analysisPlotsUI <- function(id, axixsList){
    ns <- NS(id)
    tagList(
        selectInput(ns('X_col'), 'X軸：', axixsList, selected = axixsList[1]),
        selectInput(ns('Y_col'), 'Y軸：', axixsList, selected = axixsList[2]),
        plotOutput(ns("penguins_scatterPlot")),
        gt_output(ns("penguins_analysisRes"))
    )
}

analysisPlots <- function(input, output, session, selectSpecies, submit){
    
    analysisData <- reactive({
        penguinsdata %>% 
            filter(species == selectSpecies())
    })
    
    M_res <- reactive({
        M_data <- analysisData() %>% 
            filter(sex == "male") %>%
            select(one_of(c(input$X_col, input$Y_col)))
        colnames(M_data) <- c("X_col", "Y_col")
        res <- glm(Y_col ~ X_col, 
            data = M_data,
            family = gaussian)
        return(res)
    })
    
    F_res <- reactive({
        F_data <- analysisData() %>%
            filter(sex == "female") %>%
            select(one_of(c(input$X_col, input$Y_col)))
        colnames(F_data) <- c("X_col", "Y_col")
        res <- glm(Y_col ~ X_col, 
            data = F_data,
            family = gaussian)
        return(res)
    })
    resTable <- reactive({
        tibble(
            selectSpecies = selectSpecies(),
            X = input$X_col,
            Y = input$Y_col,
            回帰式_male = paste0("y = ", format(M_res()$coefficients[2], digits = 2, scientific = FALSE), "x + ", format(M_res()$coefficients[1], digits = 2, scientific = FALSE)),
            回帰式_female = paste0("y = ", format(F_res()$coefficients[2], digits = 2, scientific = FALSE), "x + ", format(F_res()$coefficients[1], digits = 2, scientific = FALSE))
        )
    })
    
    observeEvent(submit(), {
        resultsList$results <- bind_rows(resultsList$results, resTable())
    })
    
    scatterPlot <- reactive({
        plotdata <- analysisData() %>% 
            select(one_of(c(input$X_col, input$Y_col, "sex")))
        colnames(plotdata) <- c("X_col", "Y_col", "sex")
        
        plots <- plotdata %>%
            ggplot(aes(x = X_col, y = Y_col, color = sex)) +
            geom_point() +
            geom_smooth(method = "lm") +
            xlab(input$X_col) +
            ylab(input$Y_col)
        return(plots)
    })
    output$penguins_scatterPlot <- renderPlot({scatterPlot()})
        
    output$penguins_analysisRes <- render_gt({resTable()})
}

