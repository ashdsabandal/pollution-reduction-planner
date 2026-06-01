# Ashley Mark Sabandal
# AB-3L

# library(readxl)
library(readr)
source("simplex.R")

readDefaultData <- function() {
  data = read_csv("dataset.csv", col_names = FALSE)
  
  projects = as.character(data[1, 2:(ncol(data)-1)])
  pollutions = as.character(data[[1]][2:(nrow(data)-2)])
  pollution_constraints = as.matrix(data[2:(nrow(data)-2),2:ncol(data)])
  pollution_constraints <- apply(pollution_constraints, 2, as.numeric)
  
  max_projects = as.numeric(data[nrow(data), 2:(ncol(data)-1)])
  
  objective_function = as.numeric(data[nrow(data)-1, 2:(ncol(data)-1)])
  pollutantPerProject = t(pollution_constraints[, -ncol(pollution_constraints)])

  return(list(
    pollutantPerProject = pollutantPerProject,
    objective_function = objective_function,
    projects = projects,
    pollutions = pollutions,
    max_projects = max_projects,
    pollution_constraints = pollution_constraints

  ))

}

SolveProjects <- function(checked_projects) { # accepts which indeces from the 30 projects are chosen, returns the answer from minimization
  # get default data
  data = readDefaultData()
  objective_function = data$objective_function
  projects = data$projects
  all_projects = data$projects
  pollutions = data$pollutions
  max_projects = data$max_projects
  pollution_constraints = data$pollution_constraints
  
  # remove unchecked projects from the computation
  excluded_projects =  setdiff(1:30, checked_projects)
  
  if (length(excluded_projects) > 0) {
    objective_function = objective_function[-excluded_projects]
    projects = projects[-excluded_projects]
    max_projects = max_projects[-excluded_projects]
    pollution_constraints = pollution_constraints[, -excluded_projects]
  }
  
  project_constraints = cbind(diag(length(max_projects)), max_projects)
  colnames(project_constraints) = NULL

  
  ans = Simplex(objective_function, pollution_constraints, project_constraints, c())
  pollutionTable = c()

  if (!is.null(ans$solution)) {
    breakdownTable = c()
    for (i in 1:length(ans$solution)) {
      if (ans$solution[i] > 0) {
        breakdownTable = rbind(breakdownTable, c(projects[i], round(ans$solution[i], 2), round(ans$solution[i] * objective_function[i], 2)))
      }
    }
    for (i in 1:length(pollutions)) {
      reduction = sum(pollution_constraints[i, -ncol(pollution_constraints)] * ans$solution)
      pollutionTable = rbind(pollutionTable, c(pollutions[i], round(reduction, 2), pollution_constraints[i, ncol(pollution_constraints)]))
    }

    return(list(
      optimized_cost = ans$optimized_cost,
      breakdownTable = breakdownTable,
      pollutionTable = pollutionTable,
      allMat = list(
        phase1 = ans$allMat$phase1,
        phase2 = ans$allMat$phase2
      )
    ))
  } else {
    # if no solution, just return the computation mats, and pollution table where all projects are maxed in 20 units to see if really not feasible
    for (i in 1:length(pollutions)) {
      reduction = sum(pollution_constraints[i, -ncol(pollution_constraints)] * 20)
      pollutionTable = rbind(pollutionTable, c(pollutions[i], round(reduction, 2), pollution_constraints[i, ncol(pollution_constraints)]))
    }
    return(list(
      pollutionTable = pollutionTable,
      allMat = list(
        phase1 = ans$allMat$phase1,
        phase2 = ans$allMat$phase2
      )
    ))
  }
  
}
