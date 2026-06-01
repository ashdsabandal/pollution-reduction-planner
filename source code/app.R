# Ashley Mark Sabandal
# AB-3L

#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#
library(shiny)
library(bslib)
library(DT)
source("solve.R")

ui = fluidPage(
  theme = bs_theme(
    primary = "#7AB86D",   
    secondary = "#F4A460",   
  ),
  
  # custom CSS 
  tags$head(
    tags$style(HTML("
      body {
        font-family: 'Playfair Display', 'Georgia', 'Times New Roman', serif;
      }
      .btn {
        border-radius: 20px;
        padding: 10px 24px;
        font-weight: 500;
        border: none;
        box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        transition: all 0.3s ease;
      }
      
      .btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.12);
      }
      
      .btn-primary {
        background: linear-gradient(135deg, #7AB86D 0%, #88C399 100%); 
        color: white;
      }
      
      .btn-secondary {
        background: linear-gradient(135deg, #F4A460 0%, #F7C27B 100%); 
        color: white;
      }

      
      h1, h2, h3, h4 {
        color: #2D3B2F;
        font-weight: 600;
      }
      
      h1 {
        margin-bottom: 16px;
        font-size: 2.5em;
      }
      
      .category-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 20px;
        margin: 24px 0;
      }
      
      .category-card {
        background: white;
        padding: 24px;
        border-radius: 16px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        transition: all 0.3s ease;
      }
      
      .category-card:hover {
        box-shadow: 0 4px 16px rgba(112,174,99,0.2);
      }
      
      .category-header {
        display: flex;
        align-items: center;
        gap: 12px;
        margin-bottom: 16px;
        padding-bottom: 12px;
        border-bottom: 2px solid #F0F7ED;
      }
      
      .category-icon {
        font-size: 2em;
        line-height: 1;
      }
      
      .category-title {
        font-size: 1.2em;
        font-weight: 600;
        color: #2D3B2F;
        margin: 0;
      }
      
      .category-count {
        font-size: 0.9em;
        color: #7AB86D;
        font-weight: 500;
      }
      
      .category-card .checkbox-group-input label {
        display: block;
        padding: 10px 12px;
        margin: 6px 0;
        background: #F8FAF5;
        border-radius: 8px;
        transition: all 0.2s ease;
        cursor: pointer;
      }
      
      .category-card .checkbox-group-input label:hover {
        background: #F0F7ED;
        transform: translateX(4px);
      }
      
      .category-card .checkbox-group-input input[type='checkbox'] {
        margin-right: 10px;
        cursor: pointer;
      }
      
      .dataTables_wrapper {
        background: white;
        padding: 20px;
        border-radius: 16px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        margin: 20px 0;
      }
      
      table.dataTable {
        border-collapse: separate;
        border-spacing: 0;
      }
      
      table.dataTable thead th {
        background: linear-gradient(135deg, #7AB86D 0%, #88C399 100%);
        color: white;
        font-weight: 600;
        padding: 14px;
        border: none;
      }
      
      table.dataTable tbody tr {
        transition: background-color 0.2s ease;
      }
      
      table.dataTable tbody tr:hover {
        background-color: #F0F7ED;
      }
      
      hr {
        border: none;
        height: 2px;
        background: linear-gradient(90deg, transparent, #7AB86D, transparent);
        margin: 30px 0;
      }
      
      .main-background {
        background: url('mainbg.jpg') no-repeat center center;
        background-size: cover;
        padding: 60px 20px;
        min-height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
        position: relative;
      }
      .planner-result-background {
        background: rgba(122, 184, 109, 0.15); 
        backdrop-filter: blur(10px);          
        min-height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
        padding: 40px 20px;
      }
      
      .main-card1 {
        position: relative;
        background: transparent;
        padding: 40px;
        border-radius: 24px;
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.25);
        max-width: 800px;
        z-index: 1;
        color: #f0f0f0;
        line-height: 1.8;
        font-size: 1.2em; 
      }
      
      .main-card1 h1 {
        color: #e0ffe0;
        font-weight: 700;
        font-size: 3em; 
        margin-bottom: 20px;
      }
      
      .main-card1 p {
        color: #ddd;
        font-size: 1.1em; 
        margin-bottom: 24px;
      }
      
      .main-card1 .btn {
        font-weight: 600;
        font-size: 1.2em; 
        text-shadow: 0 1px 2px rgba(0,0,0,0.3);
      }
      
      .main-card2 {
        background: white;
        padding: 30px 60px; 
        border-radius: 24px;
        box-shadow: 0 4px 16px rgba(0,0,0,0.08);
        margin: 20px auto;
        max-width: 1500px;  
        width: 90%;         
      }
      
      .main-card {
        background: white;
        padding: 40px;
        border-radius: 24px;
        box-shadow: 0 4px 16px rgba(0,0,0,0.08);
        margin: 20px auto;
        max-width: 1200px;
      }
      
      .app-intro {
        font-size: 1.2em;
        color: #5A6C5B;
        margin-bottom: 32px;
        line-height: 1.5;
        text-align: justify;
      }
      
      .custom-checkbox-row {
        margin-bottom: 8px;
        display: flex;
        align-items: center;
        gap: 8px;
      }
      
      .modal-dialog {
        width: 95% !important;
        max-width: 1200px; 
      
      }

      .dataTables_wrapper {
        width: 100%;
        overflow-x: auto;  
      }
      
      .dataTable {
        width: 100% !important;  
        table-layout: auto;     
      }
    "))
  ),
  
  uiOutput("mainUI")
)

plannerUI <- function() {
    
  div(class = "planner-result-background",
    div(class = "main-card2",
        h2("🌿 Select Your Projects"),
        p("Pick the mitigation projects to see their impact", 
          style = "color: #5A6C5B; margin-bottom: 24px;"),
        
        br(), 
        actionButton("selectAllButton", "Select All", class = "btn-primary"),
        actionButton("clearAllButton", "Reset All", class = "btn-secondary"),
        
        hr(),
        # renderUI for checkbox
        uiOutput("dynamicCheckboxes"),
        
        hr(),

        div(style = "text-align: center; margin-top: 20px;",
            actionButton("solveButton", "Evaluate Projects", class = "btn-lg btn-primary")
        )
    )
  )
}

resultUI <- function() {
  div(class = "planner-result-background",

    
    div(class = "main-card2",
        
    actionButton("backToPlanner", "← Back to Planner", class = "btn-secondary"),
    br(),
    br(),
    
    h2("📊 Selected Projects Overview"),
    p("Here's how your selected projects reduce pollution", 
      style = "color: #5A6C5B; margin-bottom: 24px;"),
    
    # display selected projects names
    uiOutput("chosenProjects"),
    
    # optimized cost display
    uiOutput("optimizedCostUI"),
    
    # renderUI for breakdown table
    DT::dataTableOutput("breakdownTable"),
    
    # renderUI for pollution table
    DT::dataTableOutput("pollutionTable"),
    hr(),
    div(style = "text-align: center; margin-top: 20px;",
        actionButton("showIterations", "Show Iteration Tableaus", class = "btn-secondary")
    )
        
    ),
    
  )
}

server <- function(input, output, session) {
  
  # reactive values
  vals = reactiveValues(checkedProjects = c(), breakdownTable = data.frame(), pollutionTable = data.frame(), iterations = list(phase1 = c(), phase2 = c()), pollutantPerProject = list(), pollutions = c(), optimized_cost = NULL, objective_function = NULL)
  data = readDefaultData()
  projects = data$projects
  pollutions = data$pollutions
  pollutantPerProject = data$pollutantPerProject
  objective_function = data$objective_function
  
  # project categories by index
  categories = list(
    list(
      title = "Energy & Power",
      icon = "⚡",
      id = "EnergyPower",
      indices = c(1, 2, 3, 4, 12, 16)  # Large Solar Park, Small Solar, Wind Farm, Gas-to-renewables, Waste Methane, Industrial Energy Efficiency
    ),
    list(
      title = "Transport",
      icon = "🚌",
      id = "Transport",
      indices = c(6, 7, 8, 20, 21, 24, 25)  # Catalytic Converters, Diesel Bus, Traffic Signal, Rail Electrification, EV Charging, Heavy-Duty Truck, Port/Harbor
    ),
    list(
      title = "Industry & Emissions",
      icon = "🏭",
      id = "IndustryEmissions",
      indices = c(5, 11, 17, 23, 26, 29)  # Boiler Retrofit, Industrial Scrubbers, Natural Gas Leak, Industrial VOC, Black Carbon, Industrial process change
    ),
    list(
      title = "Residential & Community",
      icon = "🏘️",
      id = "ResidentialCommunity",
      indices = c(9, 10, 19, 28, 30)  # Low-Emission Stove, Residential Insulation, Clean Cookstove, Household LPG, Behavioral demand-reduction
    ),
    list(
      title = "Land Use & Agriculture",
      icon = "🌾",
      id = "LandUseAgriculture",
      indices = c(13, 14, 15, 18, 22, 27)  # Landfill Gas-to-energy, Reforestation, Urban Tree Canopy, Agricultural Methane, Biochar, Wetlands
    )
  )
  
  # main page
  output$mainUI = renderUI({
    div(class = "main-background",
        div(class = "main-card1", style = "text-align: center;",
            h1("City Pollution Reduction Planner"),
            p("Welcome to Greenvale's Pollution Reduction Planner!  
The city of Greenvale has been mandated by the national government to drastically reduce its pollution footprint within the next year. The environmental commission has identified ten priority pollutants that must meet annual reduction targets. To achieve these reductions, Greenvale can choose from a menu of 30 mitigation options, ranging from renewable energy projects to reforestation and improved public transport systems. Ready to start planning Greenvale’s cleaner, greener future? Click the button below!", 
              class = "app-intro"),
            br(),
            actionButton("toPlanner", "Get Started", class = "btn-lg btn-primary")
        )
    )
  })
  
  
  # planner page
  observeEvent(input$toPlanner, {
    
    # load the planner UI
    output$mainUI = renderUI({
      plannerUI()  
    })
    
    # render checkboxes dynamically in category cards
    output$dynamicCheckboxes = renderUI({
      
      # build all category cards
      category_cards = lapply(categories, function(cat) {
        
        # get projects for this category
        cat_projects = projects[cat$indices]
        cat_projects = cat_projects[!is.na(cat_projects)]

        # category header ui
        header = div(
          class = "category-header",
          span(class = "category-icon", cat$icon),
          div(
            div(class = "category-title", cat$title),
            div(class = "category-count", paste0("(", length(cat_projects), " projects)"))
          )
        )
        
        #  custom checkboxes w/ tooltip 
        project_boxes = lapply(seq_along(cat_projects), function(i) {
          proj = cat_projects[i]
          proj_indx = match(proj, projects)
          proj_id = paste0("chk_", cat$id, "_", i)   # unique input id
          
          # use checkboxInput so Shiny binds the input properly
          # wrap the checkboxInput in a tooltip trigger (tooltip accepts a tag)
          
          # create a vertical list of project info
          tooltip_content = tags$div(
            tags$div(paste0("$", objective_function[proj_indx])),  # first line with just $
            lapply(seq_along(pollutions), function(j) {
              tags$div(paste0(pollutions[j], "= ", pollutantPerProject[proj_indx, j]))
            })
          )
          
          bslib::tooltip(
            checkboxInput(
              inputId = proj_id,
              label = proj,
              value = proj_indx %in% vals$checkedProjects
            ),
            tooltip_content,  
            placement = "right"
          )
        })
        
        # return full category card
        div(
          class = "category-card",
          header,
          div(class = "category-items", project_boxes)
        )
      })
      
      div(class = "category-grid", category_cards)
    })
    
  })
  
  
  # observe changes in any category checkbox and store checked project indices
  observe({
    all_selected = c()  # initialize empty vector to collect selected indices
    
    # loop over all categories
    for (cat in categories) {
      # get projects for this category (skip NA)
      cat_projects = projects[cat$indices]
      cat_projects = cat_projects[!is.na(cat_projects)]
      
      # loop through projects in this category
      for (i in seq_along(cat_projects)) {
        # generate the checkbox input ID
        proj_id = paste0("chk_", cat$id, "_", i)
        
        # get the checkbox value (TRUE if checked)
        val = input[[proj_id]]
        
        # if checked, store the corresponding project index
        if (!is.null(val) && isTRUE(val)) {
          proj_index = cat$indices[i]   # <-- store index, not name
          all_selected = c(all_selected, proj_index)
        }
      }
    }
    
    # update reactive value with all checked project indices
    vals$checkedProjects = all_selected
  })
  
  
  
  # result page
  observeEvent(input$solveButton, {
    
    if (length(vals$checkedProjects) == 0){
      showModal(modalDialog(
        title = "Oops!",
        "You haven't selected any projects yet. Please choose at least one to continue.",
        easyClose = TRUE,
        footer = modalButton("Close"),
        size = "s"
      ))
      
      return() 
      
    } else {
      output$mainUI = renderUI({
        resultUI()  
      })
      
      ans = SolveProjects(vals$checkedProjects)
      breakdownTable = ans$breakdownTable
      pollutionTable = ans$pollutionTable
      optimized_cost = ans$optimized_cost
      
      

      vals$optimized_cost = optimized_cost
      vals$iterations$phase1 = ans$allMat$phase1
      vals$iterations$phase2 = ans$allMat$phase2
        
      
      if (!is.null(breakdownTable)) {
        breakdownTable = data.frame(
          breakdownTable,
          stringsAsFactors = FALSE
        )
        
        colnames(breakdownTable) = c(
          "Mitigation Project",
          "Number of Project Units",
          "Cost ($)"
        )
      } else {
        breakdownTable = data.frame()
      }
      
      # pollution table
      if (nrow(breakdownTable) > 0) {
        pollutionTable = data.frame(
          pollutionTable,
          stringsAsFactors = FALSE
        )
        
        colnames(pollutionTable) = c(
          "Pollutant",
          "Total Reduction",
          "Target Reduction"
        )
        
      } else {
        pollutionTable = data.frame(
          pollutionTable,
          stringsAsFactors = FALSE
        )
        
        colnames(pollutionTable) = c(
          "Pollutant",
          "Maximum Possible Reduction",
          "Target Reduction"
        )
      }
      # render chosen projects
      output$chosenProjects <- renderUI({
        # render chosen projects
        output$chosenProjects = renderUI({
          if (length(vals$checkedProjects) == 30) {
            div(
              style = "font-size: 1.3em; font-weight: 600; color: #7AB86D; margin-bottom: 8px;",
              "You selected all the possible mitigation projects"
            )
          } else if (length(vals$checkedProjects) > 0) {
            selected = projects[vals$checkedProjects]
            # split roughly in two columns
            half = ceiling(length(selected)/2)
            col1 = selected[1:half]
            col2 = selected[(half+1):length(selected)]
            
            tagList(
              div(
                style = "font-size: 1.3em; font-weight: 600; color: #7AB86D; margin-bottom: 8px;",
                paste("You selected", length(selected), "mitigation projects")
              ),
              div(
                style = "display: flex; gap: 40px; font-size: 1.1em; color: #5A6C5B; margin-bottom: 16px;",
                div(
                  style = "flex: 1;",
                  tags$ul(lapply(col1, tags$li))
                ),
                div(
                  style = "flex: 1;",
                  tags$ul(lapply(col2, tags$li))
                )
              )
            )
          } else {
            NULL
          }
        })
        
      })
      
      # render optimized cost
      output$optimizedCostUI <- renderUI({
        if (!is.null(vals$optimized_cost)) {
          div(
            style = "font-size: 1.3em; font-weight: 600; color: #7AB86D; margin-bottom: 16px;",
            paste0("Optimized Cost: $", format(vals$optimized_cost, big.mark = ","))
          )
        } else {
          div(
            style = "font-size: 1.3em; font-weight: 600; color: #D9534F; margin-bottom: 16px;",
            "This selection is infeasible. The target pollution reductions cannot be met with the chosen projects."
          )
        }
      })
      
      # render breakdownTable
      output$breakdownTable = DT::renderDataTable({
        DT::datatable(
          breakdownTable,
          rownames = FALSE,
          options = list(
            paging = FALSE,
            searching = TRUE,
            info = FALSE,
            ordering = FALSE
          ),
          selection = "none",
          caption = htmltools::tags$caption(
            style = 'caption-side: top; text-align: center; font-weight: bold; font-size: 1.5em;',
            'Solution and Cost Breakdown'
          )
        )
      })
      
      # render pollutionTable
      output$pollutionTable = DT::renderDataTable({
        DT::datatable(
          pollutionTable,
          rownames = FALSE,
          options = list(
            paging = FALSE,
            searching = TRUE,
            info = FALSE,
            ordering = FALSE
          ),
          selection = "none",
          caption = htmltools::tags$caption(
            style = 'caption-side: top; text-align: center; font-weight: bold; font-size: 1.5em;',
            'Pollution Reduction Summary'
          )  
        )
      })
      
      # render iteration tables
      output$iterationTables = renderUI({
        
        ui_list = list()
        
        # PHASE 1
        if (length(vals$iterations$phase1) > 0) {
          phase1_ui = lapply(seq_along(vals$iterations$phase1), function(i) {
            iter = vals$iterations$phase1[[i]]
            tagList(
              h4(paste0("Phase 1 - Iteration ", i)),
              if (iter$msg != "") p(iter$msg, style = "color: #5A6C5B;"),
              DT::renderDataTable({
                datatable(
                  as.data.frame(iter$mat),
                  rownames = FALSE,
                  colnames = rep("", ncol(iter$mat)),
                  options = list(
                    paging = FALSE,
                    searching = FALSE,
                    info = FALSE,
                    ordering = FALSE,
                    dom = 't'
                  ),
                  selection = "none"
                )
              })
            )
          })
          ui_list = append(ui_list, phase1_ui)
          ui_list = append(ui_list, list(
            p("Since all Cj-Zj ≥ 0, phase 1 is done", style = "color: #7AB86D; font-weight: 500;")
          ))
        } else {
          ui_list = append(ui_list, list(p("No Phase 1 iterations", style = "color: #5A6C5B;")))
        }
        
        # PHASE 2
        if (length(vals$iterations$phase2) > 0) {
          phase2_ui = lapply(seq_along(vals$iterations$phase2), function(i) {
            iter = vals$iterations$phase2[[i]]
            tagList(
              h4(paste0("Phase 2 - Iteration ", i)),
              if (iter$msg != "") p(iter$msg, style = "color: #5A6C5B;"),
              DT::renderDataTable({
                datatable(
                  as.data.frame(iter$mat),
                  rownames = FALSE,
                  colnames = rep("", ncol(iter$mat)),
                  options = list(
                    paging = FALSE,
                    searching = FALSE,
                    info = FALSE,
                    ordering = FALSE,
                    dom = 't'
                  ),
                  selection = "none"
                )
              })
            )
          })
          ui_list = append(ui_list, phase2_ui) 
        } else {
          ui_list = append(ui_list, list(
            p("This solution is not feasible because an artificial variable appears in the basis with positive value",
              style = "color: #D9534F; font-weight: 500;")
          ))
        }
        
        tagList(ui_list)
        
      })
      
    }
    
  })

  
  # select all projects
  observeEvent(input$selectAllButton, {
    # update all category checkboxes
    for (cat in categories) {
      cat_projects = projects[cat$indices]
      cat_projects = cat_projects[!is.na(cat_projects)]
      
      for (i in seq_along(cat_projects)) {
        proj_id = paste0("chk_", cat$id, "_", i)
        updateCheckboxInput(session, proj_id, value = TRUE)
      }
    }
  })
  
  # clear all projects
  observeEvent(input$clearAllButton, {
    # update all category checkboxes to empty
    for (cat in categories) {
      cat_projects = projects[cat$indices]
      cat_projects = cat_projects[!is.na(cat_projects)]
      
      for (i in seq_along(cat_projects)) {
        proj_id = paste0("chk_", cat$id, "_", i)
        updateCheckboxInput(session, proj_id, value = FALSE)
      }
    }
    
  })
  observeEvent(input$showIterations, {
    showModal(modalDialog(
      title = "Iteration Tableaus",
      size = "l",  
      easyClose = TRUE,
      header = modalButton("Close"),
      footer = modalButton("Close"),
      uiOutput("iterationTables") 
        
    ))
  })
  
  # from result to planner
  observeEvent(input$backToPlanner, {
    output$mainUI = renderUI({
      plannerUI()  
    })
    
    # re-render the category checkboxes with current selections
    output$dynamicCheckboxes = renderUI({
      
      # build the category cards
      category_cards = lapply(categories, function(cat) {
        # get projects for this category
        cat_projects = projects[cat$indices]
        cat_projects = cat_projects[!is.na(cat_projects)]
        
        # category header ui
        header = div(
          class = "category-header",
          span(class = "category-icon", cat$icon),
          div(
            div(class = "category-title", cat$title),
            div(class = "category-count", paste0("(", length(cat_projects), " projects)"))
          )
        )
        
        #  custom checkboxes w/ tooltip 
        project_boxes = lapply(seq_along(cat_projects), function(i) {
          proj = cat_projects[i]
          proj_indx = match(proj, projects)
          proj_id = paste0("chk_", cat$id, "_", i)   # unique input id
          
          # use checkboxInput so Shiny binds the input properly
          # wrap the checkboxInput in a tooltip trigger (tooltip accepts a tag)

          # create a vertical list of project info
          tooltip_content = tags$div(
            tags$div(paste0("$", objective_function[proj_indx])),  # first line with just $
            lapply(seq_along(pollutions), function(j) {
              tags$div(paste0(pollutions[j], "= ", pollutantPerProject[proj_indx, j]))
            })
          )
          
          bslib::tooltip(
            checkboxInput(
              inputId = proj_id,
              label = proj,
              value = proj_indx %in% vals$checkedProjects
            ),
            tooltip_content,  
            placement = "right"
          )
        })
        
        div(class = "category-card",
            header,
            div(class = "category-items", project_boxes)
        )
      })
      
      div(class = "category-grid", category_cards)
    })
    
  })
}

# Run the application 
shinyApp(ui = ui, server = server)