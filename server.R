server <- function(input, output, session) {
  # 1 Set up ----
  ## 1.1 Loading screen ----
  # Call initial loading screen
  hide(
    id = "loading-content",
    anim = TRUE,
    animType = "fade"
  )
  show("app-content")

  ## 1.3 Set up cookies
  # output if cookie is unspecified
  observeEvent(input$cookies, {
    if (!is.null(input$cookies)) {
      if (!("dfe_analytics" %in% names(input$cookies))) {
        shinyalert(
          inputId = "cookie_consent",
          title = "Cookie consent",
          text = "This site uses cookies to record traffic flow using Google Analytics",
          size = "s",
          closeOnEsc = TRUE,
          closeOnClickOutside = FALSE,
          html = FALSE,
          type = "",
          showConfirmButton = TRUE,
          showCancelButton = TRUE,
          confirmButtonText = "Accept",
          confirmButtonCol = "#AEDEF4",
          timer = 0,
          imageUrl = "",
          animation = TRUE
        )
      } else {
        msg <- list(
          name = "dfe_analytics",
          value = input$cookies$dfe_analytics
        )
        session$sendCustomMessage("analytics-consent", msg)
        if ("cookies" %in% names(input)) {
          if ("dfe_analytics" %in% names(input$cookies)) {
            if (input$cookies$dfe_analytics == "denied") {
              ga_msg <- list(name = paste0("_ga_", google_analytics_key))
              session$sendCustomMessage("cookie-remove", ga_msg)
            }
          }
        }
      }
    }
  })

  observeEvent(input$cookie_consent, {
    msg <- list(
      name = "dfe_analytics",
      value = ifelse(input$cookie_consent, "granted", "denied")
    )
    session$sendCustomMessage("cookie-set", msg)
    session$sendCustomMessage("analytics-consent", msg)
    if ("cookies" %in% names(input)) {
      if ("dfe_analytics" %in% names(input$cookies)) {
        if (input$cookies$dfe_analytics == "denied") {
          ga_msg <- list(name = paste0("_ga_", google_analytics_key))
          session$sendCustomMessage("cookie-remove", ga_msg)
        }
      }
    }
  })

  observeEvent(input$remove, {
    msg <- list(name = "dfe_analytics", value = "denied")
    session$sendCustomMessage("cookie-remove", msg)
    session$sendCustomMessage("analytics-consent", msg)
  })

  cookies_data <- reactive({
    input$cookies
  })

  output$cookie_status <- renderText({
    cookie_text_stem <- "To better understand the reach of our dashboard tools, this site uses cookies to identify numbers of unique users as part of Google Analytics. You have chosen to"
    cookie_text_tail <- "the use of cookies on this website."
    if ("cookies" %in% names(input)) {
      if ("dfe_analytics" %in% names(input$cookies)) {
        if (input$cookies$dfe_analytics == "granted") {
          paste(cookie_text_stem, "accept", cookie_text_tail)
        } else {
          paste(cookie_text_stem, "reject", cookie_text_tail)
        }
      }
    } else {
      paste("Cookies consent has not been confirmed.")
    }
  })

  # 2 Main page ----
  ## 2.1 Homepage ----
  ### 2.1.1 Make links ----
  # Create link to data catalogue tab
  observeEvent(input$link_to_tabpanel_catalogue, {
    updateTabsetPanel(session, "navbar", "Data catalogue")
  })

  # Create link to publications tab
  observeEvent(input$link_to_tabpanel_pubs, {
    updateTabsetPanel(session, "navbar", "List of publications")
  })

  # Create link to accessibilty tab
  observeEvent(input$link_to_tabpanel_accessibility, {
    updateTabsetPanel(session, "navbar", "Accessibility")
  })

  # Create link to publications tab
  observeEvent(input$link_to_tabpanel_support, {
    updateTabsetPanel(session, "navbar", "Support and feedback")
  })

  ## 2.2 Table filters----
  ### 2.2.1 Filters----

  observeEvent(
    input$themeChoice, {
      updateSelectizeInput(session, "publicationChoice",
        choices = (C_AllVar %>%
          filter(
            if (is.null(input$themeChoice) == TRUE) {
              TRUE
            } else {
              Theme %in% input$themeChoice
            }
          ) %>%
          distinct(`Publication name`))$`Publication name`
      )
      updateSelectizeInput(session, "metricChoice",
        choices = (C_AllVar %>%
          filter(
            if (is.null(input$themeChoice) == TRUE) {
              TRUE
            } else {
              Theme %in% input$themeChoice
            }
            ,Metric.or.Attribute=="Metric"
          ) %>%
          distinct(Variables)%>%
            arrange(Variables))$Variables
      )
      updateSelectizeInput(session, "attributeChoice",
                           choices = (C_AllVar %>%
                                        filter(
                                          if (is.null(input$themeChoice) == TRUE) {
                                            TRUE
                                          } else {
                                            Theme %in% input$themeChoice
                                          }
                                          ,Metric.or.Attribute=="Attribute"
                                        ) %>%
                                        distinct(Variables)%>%
                                        arrange(Variables))$Variables
      )
    }
    # ,ignoreNULL = FALSE
  )

  # update a publication change
  observeEvent(
    input$publicationChoice, {
      updateSelectizeInput(session, "themeChoice",
        choices = (C_AllVar %>%
          filter(
            if (is.null(input$publicationChoice) == TRUE) {
              TRUE
            } else {
              `Publication name` %in% input$publicationChoice
            }
          ) %>%
          distinct(Theme))$Theme
      )
      updateSelectizeInput(session, "metricChoice",
        choices = (C_AllVar %>%
          filter(
            if (is.null(input$publicationChoice) == TRUE) {
              TRUE
            } else {
              `Publication name` %in% input$publicationChoice
            }
            ,Metric.or.Attribute=="Metric"
          ) %>%
          distinct(Variables)%>%
            arrange(Variables))$Variables
      )
      updateSelectizeInput(session, "attributeChoice",
                           choices = (C_AllVar %>%
                                        filter(
                                          if (is.null(input$themeChoice) == TRUE) {
                                            TRUE
                                          } else {
                                            Theme %in% input$themeChoice
                                          }
                                          ,Metric.or.Attribute=="Attribute"
                                        ) %>%
                                        distinct(Variables)%>%
                                        arrange(Variables))$Variables
      )
    }
    # ,ignoreNULL = FALSE
  )

  # update when a variable change
  observeEvent(list(input$metricChoice,input$attributeChoice),
    {
      # print(list(input$metricChoice,input$attributeChoice))
      # print((is.null(c(input$metricChoice,input$attributeChoice))))
      # print(input$metricChoice,input$attributeChoice)
      updateSelectizeInput(session, "publicationChoice",
        choices = (C_AllVar %>%
          filter(
            if (is.null(c(input$metricChoice,input$attributeChoice)) == TRUE ) {
              TRUE
            } else {
              Variables %in% c(input$metricChoice,input$attributeChoice)
            }
          ) %>%
          distinct(`Publication name`))$`Publication name`
      )
      updateSelectizeInput(session, "themeChoice",
        choices = (C_AllVar %>%
          filter(
            if (is.null(c(input$metricChoice,input$attributeChoice)) == TRUE ) {
              TRUE
            } else {
              Variables %in% c(input$metricChoice,input$attributeChoice)
            }
          ) %>%
          distinct(Theme))$Theme
      )
    },
    ignoreNULL = FALSE
  )

  ### 2.2.2 Table----
  selectedDataset <- reactive({
    C_AllVar %>%
      filter(
        if (is.null(input$themeChoice) == TRUE) {
          TRUE
        } else {
          Theme %in% input$themeChoice
        },
        if (is.null(input$publicationChoice) == TRUE) {
          TRUE
        } else {
          `Publication name` %in% input$publicationChoice
        },
        if (is.null(c(input$metricChoice,input$attributeChoice)) == TRUE ) {
              TRUE
            } else {
              Variables %in% c(input$metricChoice,input$attributeChoice)
        }
      ) %>%
      group_by(Theme, Publication, Table,`Underlying data`,AllVariables) %>% 
     # summarise(VariableCount = n())%>%
      mutate("Matched variables" = paste0(n(),": ",paste0(Variables, collapse = ", "))) %>%
      slice(1)%>%
     # count(Theme, Publication, Table, AllVariables, name = "Matched variables") %>%
      arrange(
        if (is.null(c(input$metricChoice,input$attributeChoice)) == TRUE) {
          TRUE
        } else {
          desc(`Matched variables`)
        }
      ) %>%
      select(
        if (is.null(c(input$metricChoice,input$attributeChoice))) {
          c("Theme", "Publication", "Table","Underlying data", "AllVariables")
        } else {
          c("Theme", "Publication", "Table","Underlying data", "AllVariables", "Matched variables")
        }
      )
  })

  output$hubTable2 <- renderDataTable({
    DT::datatable(
      selectedDataset(),
      options = list(
dom = "tp" # turn off search but keep pagination
        , rowCallback = JS(
          "function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {",
          "var full_text = 'Variables in this table: ' + aData[4]",
          "$('td:eq(2)', nRow).attr('data-title', full_text);",
          "}"
        ),
        columnDefs = list(list(visible = FALSE, targets = c(4)),
                          list(targets="_all", className = 'dt-top'))
      ),
      rownames = FALSE # get rid of rownames
      , escape = FALSE # allow hyperlink
    )
  })

  ## 2.3 List of publications----
  ### 2.3.2 Table----
  output$pubTable <- DT::renderDataTable({
    DT::datatable(C_Pubs,
                  options = list(columnDefs = list(list(targets="_all", className = 'dt-top')))
      # options = list(dom = "tp") # turn off search
      ,escape = FALSE # allow hyperlink
      , rownames = FALSE
    ) # get rid of rownames
  })

  # 3.Stop app -----
  session$onSessionEnded(function() {
    stopApp()
  })
}
