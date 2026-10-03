
page_fluid(
    navset_tab(
        nav_panel("selectTab",
                  selectInput(
                      inputId = "selectSpecies",
                      label = "解析したい種を選んでください",
                      choices = penguinsList,
                      selected = NULL, 
                      multiple = FALSE)
                  ,

                  gt_output("resultsTable")
                  ),
        nav_panel(
            "analysisTab",
            analysisPlotsUI("analysisTab", axixsList),
            actionButton("submit", "完了") 
        )
    )
)
