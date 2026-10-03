
function(input, output, session) {
    output$resultsTable <- render_gt(
        resultsList$results
    )
    callModule(analysisPlots, "analysisTab", reactive(input$selectSpecies), reactive(input$submit))    
    
    observe(
        print(resultsList$results)
    )
    
}
