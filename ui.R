# 1. Set up page, header, js and css ----
## 1.1 Set up page and browser info ----
fluidPage(
  title = tags$head(tags$link(
    rel = "shortcut icon",
    href = "dfefavicon.png"
  )),
  shinyjs::useShinyjs(),
  useShinydashboard(),
  # Setting up cookie consent based on a cookie recording the consent:
  # https://book.javascript-for-r.com/shiny-cookies.html
  tags$head(
    tags$script(
      src = paste0(
        "https://cdn.jsdelivr.net/npm/js-cookie@rc/",
        "dist/js.cookie.min.js"
      )
    ),
    tags$script(src = "cookie-consent.js")
  ),
  tags$head(
    tags$link(
      rel = "stylesheet",
      type = "text/css",
      href = "dfe_shiny_gov_style.css"
    )
  ),
  
  # Set metadata for browser
  tags$html(lang = "en"),
  tags$head(
    tags$meta(name = "application_name", content = "Unit for Future Skills - Skills data catalogue"),
    tags$meta(name = "description", content = "Data dashboard presenting a skills data catalogue from the Unit for Future Skills in the Department for Education."),
    tags$meta(name = "subject", content = "Education data dashboards.")
  ),
  
  # Set title for search engines
  HTML("<title>Skills data catalogue</title>"),
  # Setting up cookie consent based on a cookie recording the consent:
  # https://book.javascript-for-r.com/shiny-cookies.html
  tags$head(
    tags$script(
      src = paste0(
        "https://cdn.jsdelivr.net/npm/js-cookie@rc/",
        "dist/js.cookie.min.js"
      )
    ),
    tags$script(src = "cookie-consent.js")
  ),
  tags$head(includeHTML(("google-analytics.html"))),
  
  ## 1.2. Internal CSS ----
  tags$head(
    tags$style(
      HTML(
        "

    /* remove the max width of the main panel so spreads across screen*/
.govuk-width-container {
    max-width: 100%;
}

/* styles for menu button*/
    #menuButton {
      display: none;
      width: auto;
    }

    .menuBtn {
      color: #fff;
      float: left;
      padding: 10px;
    }

        .menuBtn:focus {
      color: #fff;
      background-color: #000;
    }

/* for mobile*/
    @media (max-width: 767px) {
      .nav-stacked {
        display: none;
      }
      .nav-stacked.active {
        display: block;
      }

      #menuButton {
        display: block;
      }

      .menuBtn.active {
        background-color: #fff;
        color: #000;
      }
    }

 /* overwrite ccs to keep margin*/
@media (min-width:1020px) {
    .govuk-width-container {
        margin-right: max(30px, calc(15px + env(safe-area-inset-left)));
        margin-left: max(30px, calc(15px + env(safe-area-inset-left)))
    }
    @supports (margin:max(calc(0px))) {
        .govuk-width-container {
            margin-right: max(30px, calc(15px + env(safe-area-inset-left)));
            margin-left: max(30px, calc(15px + env(safe-area-inset-left)))
        }
    }
}

"
      )
    ),
    ## 1.3. Javascript and HTML banner----
    # Collapsible menu js
    tags$script(
      HTML(
        '
    /* javascript function for menu button */
    function collapseMenu() {
      var x = document.getElementById("navbar");
      x.classList.toggle("active");

      var x = document.getElementById("menuButton");
      x.classList.toggle("active");
    }
    '
      )
    )
  ),
  
  # Force the top nav bar to left align and centre the title
  HTML(
    '<header class="govuk-header" role="banner">
    <div class="govuk-header__container">
    <div class="govuk-header__logo" style="width: 15%; margin-left: 15px;float:left;">
    <a href="https://www.gov.uk/government/organisations/department-for-education" class="govuk-header__link govuk-header__link--homepage">
    <span class="govuk-header__logotype">
   <img src="images/DfE_logo.png" class="govuk-header__logotype-crown-fallback-image"/>
    <span class="govuk-header__logotype-text">DfE</span>
    </span>
    </a>
    </div>
    <div class="govuk-header__content" style="width: 70%; text-align: center;float:left;">
    <a href="https://www.gov.uk/government/groups/unit-for-future-skills" class="govuk-header__link govuk-header__link--service-name" style="font-size: 24px;">Unit for Future Skills - Skills data catalogue</a>
    </div>
        <a href="javascript:void(0);" id="menuButton" class="menuBtn" onclick="collapseMenu()">
    <i class="fa fa-bars" style="font-size:24px;"></i></a>
    </div>
    </header>'
  ),
  
  # Add bug header
  HTML(
    '<div class="govuk-phase-banner govuk-width-container govuk-main-wrapper" id="beta banner" style="margin-left:0px;margin-right:0px">
  <p class="govuk-phase-banner__content">
    <strong class="govuk-tag govuk-phase-banner__content__tag ">beta</strong>
    <span class="govuk-phase-banner__text">We are aware of performance issues that require some users to reload the page. We are working to fix this.
</span>
  </p>
</div>'
  ),
  
  # 2 Main page ----
  navlistPanel(
    id = "navbar",
    widths = c(2, 10),
    well = FALSE,
    selected = "Data catalogue",
    
    ## 2.1 User guide ----
    tabPanel(
      "User guide",
      ### 2.1.1 Intro ----
      fluidRow(column(
        12,
        h1("Skills data catalogue"),
        p(
          "The Skills data catalogue provides helps access skills data. "
        ),
        p(
          "This dashboard is produced by the ",
          # "To access the additional dashboards developed to help users further understand the labour market outcomes of training use the links below, or from the ",
          a(
            href = "https://www.gov.uk/government/groups/unit-for-future-skills",
            "Unit for Future Skills",
            .noWS = c("after")
          ),
          ", an analytical and research unit within the Department for Education. For more information on the Unit's aims and to access additional dashboards and data to help users further understand the labour market outcomes of training visit our",
          a(
            href = "https://www.gov.uk/government/groups/unit-for-future-skills",
            "webpage.",
            .noWS = c("after")
          ),
          # " webpage."
        )
      )),
      # end intro text row
      
      ### 2.1.2 Contents ----
      fluidRow(column(
        12,
        div(
          class = "panel panel-info",
          div(
            class = "panel-heading",
            style = "color: white;font-size: 18px;font-style: bold; background-color: #1d70b8;",
            h2("How to use this dashboard")
          ),
          div(
            class = "panel-body",
            p("Use the navigation bar on the left to select the tab you want to view."),
            h2("Dashboard structure"),
            tags$ul(
              tags$li(actionLink("link_to_tabpanel_catalogue", "Data catalogue"), " - this tab has a searchable catalogue of skills data."),
            )
          )
        )
      )),
      # end of dashboard contents row
      
      ### 2.1.3 Version control ----
      fluidRow(column(
        12,
        div(
          class = "panel panel-info",
          div(
            class = "panel-heading",
            style = "color: white;font-size: 18px;font-style: bold; background-color: #1d70b8;",
            h2("Update history")
          ),
          div(
            class = "panel-body",
            h2("Latest update"),
            p("xx June 2023 (1.0.0)"),
            tags$ul(
              tags$li("First release.")
            ),
            tags$details(
              label = "Previous updates",
              inputId = "PreviousUpdate",
              p(
                p("xx/xx/xx (0.0.0)"),
                tags$ul(
                  tags$li("xxx")
                )
              )
            ),
            h2("Future development"),
            p(
              "The dashboard will be kept up to date with the latest data shortly after it is released. If there are further data or dashboard features that you would find useful please contact us at ",
              a(
                href = "mailto:ufs.contact@education.gov.uk",
                "ufs.contact@education.gov.uk",
                .noWS = c("after")
              ),
              "."
            )
          )
        )
      )) # end of version control row
    ),
    # end of homepage Panel
    
    ## 2.4 Download hub ----
    tabPanel(
      "List of publications",
      fluidRow(column(
        12,
        h1("Skills data sources"),
        p(
          "Use the filters to find a relevant dataset."
        )
      )),
      ### 2.4.2 Datahub table ----
      fluidRow(column(
        12,
        dataTableOutput("pubTable")
      ))
    #   br(),
    #   fluidRow(column(
    #     3,
    #     downloadButton(
    #       outputId = "hubDownload",
    #       label = "Download this data",
    #       icon = shiny::icon("download"),
    #       class = "downloadButton"
    #     )
    #   )),
     ),
    
    ## 2.4 Download hub filters----
    tabPanel(
      "Data catalogue",
      fluidRow(column(
        12,
        h1("Skills data sources"),
        p(
          "Use the filters to find a relevant dataset."
        )
      )),
      ## 2.4.1 Datahub filters ----
      fluidRow(column(12, h2("Inputs"))),
      fluidRow(
        column(
          4,
          selectizeInput(
            "sourceChoice",
            multiple = TRUE,
            label = NULL,
            options = list(placeholder = "Choose a source"),
            choices = C_AllVar %>%
              # filter(if(is.null(input$variableChoice) == TRUE) {TRUE} else {Variables %in% input$variableChoice}
              #        ,if(is.null(input$publicationChoice) == TRUE) {TRUE} else {Publication %in% input$publicationChoice})%>%
              distinct(Source)
          )
        ),
        column(
          4,
          selectizeInput(
            "publicationChoice",
            multiple = TRUE,
            label = NULL,
            options = list(placeholder = "Choose a publication"),
            choices = 
              C_AllVar %>%
              # filter(if(is.null(input$sourceChoice) == TRUE) {TRUE} else {Source %in% input$sourceChoice}
              #        ,if(is.null(input$variableChoice) == TRUE) {TRUE} else {Variables %in% input$variableChoice})%>%
              distinct(Publication)
          )
          #uiOutput("publicationInput")
        ),
        column(
          4,
          selectizeInput(
            "variableChoice",
            multiple = TRUE,
            label = NULL,
            options = list(placeholder = "Choose variables"),
            choices = C_AllVar %>%
              # filter(if(is.null(input$sourceChoice) == TRUE) {TRUE} else {Source %in% input$sourceChoice}
              #        ,if(is.null(input$publicationChoice) == TRUE) {TRUE} else {Publication %in% input$publicationChoice}
              # )%>%
              distinct(Variables)
            
          )
          #uiOutput("variableInput")
        )
      ),
      ### 2.4.2 Datahub table ----
      fluidRow(column(
        12,
        dataTableOutput("hubTable2")
      )),
      br(),
      fluidRow(column(
        3,
        downloadButton(
          outputId = "hubDownload",
          label = "Download this data",
          icon = shiny::icon("download"),
          class = "downloadButton"
        )
      )),
    ),
    
    ## 2.8 Accessibility ----
    tabPanel(
      "Accessibility",
      fluidRow(
        column(
          width = 12,
          h1("Accessibility statement"),
          p(
            "This accessibility statement applies to the Skills data catalogue dashboard.
            This dashboard is run by the Department for Education. We want as many people as possible to be able to use this application,
            and have actively developed this dashboard with accessibilty in mind."
          ),
          h2("WCAG 2.1 compliance"),
          p(
            "We follow the reccomendations of the ",
            a(href = "https://www.w3.org/TR/WCAG21/", "WCAG 2.1 requirements. "),
            "This application has been checked using the ",
            a(href = "https://github.com/ewenme/shinya11y", "Shinya11y tool "),
            ", which did not detect accessibility issues.
             This dashboard also fully passes the accessibility audits checked by the ",
            a(href = "https://developers.google.com/web/tools/lighthouse", "Google Developer Lighthouse tool"),
            ". This means that this dashboard:"
          ),
          tags$div(tags$ul(
            tags$li("uses colours that have sufficient contrast"),
            tags$li(
              "allows you to zoom in up to 300% without the text spilling off the screen"
            ),
            tags$li(
              "has its performance regularly monitored, with a team working on any feedback to improve accessibility for all users"
            )
          )),
          h2("Limitations"),
          p(
            "We recognise that there are still potential issues with accessibility in this dashboard, but we will continue
             to review updates to technology available to us to keep improving accessibility for all of our users. For example, these
            are known issues that we will continue to monitor and improve:"
          ),
          tags$div(tags$ul(
            tags$li(
              "Keyboard navigation through the interactive charts is currently limited, and some features are unavailable for keyboard only users"
            ),
            tags$li(
              "Alternative text in interactive charts is limited to titles and could be more descriptive (although this data is available in csv format)"
            )
          )),
          h2("Feedback"),
          p(
            "If you have any feedback on how we could further improve the accessibility of this dashboard, please contact us at",
            a(href = "mailto:statistics.development@education.gov.uk", "statistics.development@education.gov.uk")
          ),
          br()
        )
      )
    ),
    # End of accessibility tab
    
    ## 2.9 Support ----
    tabPanel(
      "Support and feedback",
      support_links() # defined in R/supporting_links.R))
    )
  ),
  # End of navBarPage
  # 3 Footer ----
  
  shinyGovstyle::footer(TRUE)
)
