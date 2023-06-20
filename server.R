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
  # Create link to overview tab
  observeEvent(input$link_to_tabpanel_catalogue, {
    updateTabsetPanel(session, "navbar", "Data catalogue")
  })

  ## 2.2 DataHub filters----
  ### 2.2.1 Filters----

  observeEvent(input$publicationChoice, {
    updateSelectizeInput(session, "variableChoice",
      choices = (C_AllVar %>%
        filter(Publication %in% input$publicationChoice) %>%
        distinct(Variables))$Variables
    )
    updateSelectizeInput(session, "sourceChoice",
      choices = (C_AllVar %>%
        filter(Publication %in% input$publicationChoice) %>%
        distinct(Source))$Source
    )
  })

  observeEvent(input$sourceChoice, {
    updateSelectizeInput(session, "publicationChoice",
      choices = (C_AllVar %>%
        filter(Source %in% input$sourceChoice) %>%
        distinct(Publication))$Publication
    )
    updateSelectizeInput(session, "variableChoice",
      choices = (C_AllVar %>%
        filter(Source %in% input$sourceChoice) %>%
        distinct(Variables))$Variables
    )
  })

  observeEvent(input$variableChoice, {
    updateSelectizeInput(session, "publicationChoice",
      choices = (C_AllVar %>%
        filter(Variables %in% input$variableChoice) %>%
        distinct(Publication))$Publication
    )
    updateSelectizeInput(session, "sourceChoice",
      choices = (C_AllVar %>%
        filter(Variables %in% input$variableChoice) %>%
        distinct(Source))$Source
    )
  })

  ### 2.2.2 Table----
  selectedDataset <- reactive({
    C_AllVar %>%
      filter(
        if (is.null(input$sourceChoice) == TRUE) {
          TRUE
        } else {
          Source %in% input$sourceChoice
        },
        if (is.null(input$publicationChoice) == TRUE) {
          TRUE
        } else {
          Publication %in% input$publicationChoice
        },
        if (is.null(input$variableChoice) == TRUE) {
          TRUE
        } else {
          Variables %in% input$variableChoice
        }
      )
  })

  output$hubTable2 <- renderDataTable({
    DT::datatable(
      selectedDataset() %>%
        distinct(Source, Publication, Table),
      options = list(dom = "tp") # turn off search but keep pagination
      , rownames = FALSE
    ) # get rid of rownames
  })

  ## 2.3 List of publications----
  ### 2.3.2 Table----
  output$pubTable <- DT::renderDataTable({
    DT::datatable(C_Pubs,
      options = list(dom = "t") # turn off search
      , escape = FALSE # allow hyperlink
      , rownames = FALSE
    ) # get rid of rownames
  })

  # 3.Stop app -----
  session$onSessionEnded(function() {
    stopApp()
  })
}
