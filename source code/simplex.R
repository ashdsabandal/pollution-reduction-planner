# Ashley Mark Sabandal
# AB-3L

GetPivotCol <- function(CjZj) { # returns the column of the highest magnitude among the negative numbers excluding the solution column on the bottom row
  lowestNegIndex = order(CjZj)[1]
  if (CjZj[lowestNegIndex] < 0) { # if the lowest value is negative, return index
    return(lowestNegIndex)
  } else { # all values are positive, just return -1
    return(-1)
  }
}

GetPivotRow <- function(pivCol, mat, Xb) {
  TR = c()
  for (i in 1:nrow(mat)) {
    sol = Xb[i]
    pivColVal = mat[i, pivCol]
    
    # Only consider positive test ratios
    if (pivColVal > 0 && sol >= 0) {
      TR = append(TR, sol/pivColVal)
    } else {
      TR = append(TR, Inf)  # Exclude this row
    }
  }
  return(order(TR)[1])
}

CreateTableauMatrix <- function(mat, Cj, B, Cb, Xb, colNames, Zj, CjZj, Z, iter) {
  # remove NA columns
  validCols = which(!is.na(Cj))
  mat = mat[, validCols, drop = FALSE]
  Cj = Cj[validCols]
  Zj = Zj[validCols]
  CjZj = CjZj[validCols]
  colNames = colNames[validCols]
  
  nRows = nrow(mat)
  nCols = ncol(mat)
  
  # create tableau matrix
  tableau = matrix("", nrow = nRows + 4, ncol = nCols + 3)
  
  # first row: iteration and Cj values
  tableau[1, 1] = paste0("Iteration-", iter)
  tableau[1, 3] = "Cj"
  tableau[1, 4:(nCols + 3)] = round(Cj, 2)
  
  # second row: headers
  tableau[2, 1] = "B"
  tableau[2, 2] = "CB"
  tableau[2, 3] = "XB"
  tableau[2, 4:(nCols + 3)] = colNames
  
  # constraint rows
  for (i in 1:nRows) {
    tableau[i + 2, 1] = B[i]
    tableau[i + 2, 2] = round(Cb[i], 2)
    tableau[i + 2, 3] = round(Xb[i], 2)
    tableau[i + 2, 4:(nCols + 3)] = round(mat[i, ], 2)
  }
  
  # Zj row
  tableau[nRows + 3, 1] = paste0("Z=", round(Z, 2))
  tableau[nRows + 3, 3] = "Zj"
  tableau[nRows + 3, 4:(nCols + 3)] = round(Zj, 2)
  
  # Cj-Zj row
  tableau[nRows + 4, 3] = "Cj-Zj"
  tableau[nRows + 4, 4:(nCols + 3)] = round(CjZj, 2)
  
  return(tableau)
}

TwoPhaseGaussJordan <- function(mat, Cj, B, Cb, Xb, colNames, artIndeces=NULL) { 
  n = nrow(mat)
  iter = 1
  Zj = colSums(Cb * mat)
  CjZj = Cj - Zj
  Z = sum(Cb * Xb)
  
  allMat = list()
  allMat[[iter]] = list(
    mat = CreateTableauMatrix(mat, Cj, colNames[B], Cb, Xb, colNames, Zj, CjZj, Z, iter),
    msg = ""
  )
  
  while (!all(CjZj >= 0, na.rm = TRUE)) { # stop if no more negative values on Cj-Zj
    iter = iter + 1
    
    pivotCol = GetPivotCol(CjZj) # find pivot col
    pivotRow = GetPivotRow(pivotCol, mat, Xb) # find pivot row
    
    if (mat[pivotRow,pivotCol] == 0) {
      break
    }
    
    # Save pivot value BEFORE normalizing
    pivotValue = mat[pivotRow, pivotCol]
    
    # Normalize pivot row
    mat[pivotRow,] = mat[pivotRow,] / pivotValue
    Xb[pivotRow] = Xb[pivotRow] / pivotValue
    
    # Eliminate pivot column in other rows
    for (j in 1:n) { # row
      if (pivotRow == j){
        next
      }
      mult = mat[j, pivotCol]
      mat[j,] = mat[j,] - mult * mat[pivotRow,]  # Use normalized pivot row
      Xb[j] = Xb[j] - mult * Xb[pivotRow]  # Use normalized Xb value
    }
    
    toDepart = B[pivotRow]
    # Enter
    B[pivotRow] = pivotCol
    
    # do this on phase 1 only
    if (!is.null(artIndeces)) {
      # Depart if artificial variable
      if (toDepart %in% artIndeces) {
        mat[,toDepart] = NA
        Cj[toDepart] = NA
      }
    }
    
    # recompute
    Cb = Cj[B]
    Zj = colSums(Cb * mat)
    CjZj = Cj - Zj
    Z = sum(Cb * Xb)
    
    msg = paste0("Entering variable is ", colNames[pivotCol], "      ", "Leaving basis variable is ", colNames[toDepart])
    allMat[[iter]] = list(
      mat = CreateTableauMatrix(mat, Cj, colNames[B], Cb, Xb, colNames, Zj, CjZj, Z, iter),
      msg = msg
    )
  }

  return(list(
    mat = mat,
    Cj = Cj,
    B = B,
    Cb = Cb,
    Xb = Xb,
    artIndeces = artIndeces,
    Z = Z,
    allMat = allMat
    # feasible = TRUE
  ))
}

Phase1 <- function(obj, greaterEqCons, lessEqCons, equalCons) { # >= : -surplus +artificial        <= : +slack        = : +artificial
  
  # move sol column to Xb for all constraint types
  Xb = c()
  if (!length(lessEqCons) == 0 && nrow(lessEqCons) > 0) {
    Xb = c(Xb, lessEqCons[,ncol(lessEqCons)])
    lessEqCons = lessEqCons[, -ncol(lessEqCons), drop=FALSE]
  }
  if (!length(greaterEqCons) == 0 && nrow(greaterEqCons) > 0) {
    Xb = c(Xb, greaterEqCons[,ncol(greaterEqCons)])
    greaterEqCons = greaterEqCons[, -ncol(greaterEqCons), drop=FALSE]
  }
  if (!length(equalCons) == 0 && nrow(equalCons) > 0) {
    Xb = c(Xb, equalCons[,ncol(equalCons)])
    equalCons = equalCons[, -ncol(equalCons), drop=FALSE]
  }
  
  # determine the number of decision variables (max columns among all constraint types)
  nDecisionVars = 0
  if (!length(lessEqCons) == 0 && nrow(lessEqCons) > 0) {
    nDecisionVars = max(nDecisionVars, ncol(lessEqCons))
  }
  if (!length(greaterEqCons) == 0 && nrow(greaterEqCons) > 0) {
    nDecisionVars = max(nDecisionVars, ncol(greaterEqCons))
  }
  if (!length(equalCons) == 0 && nrow(equalCons) > 0) {
    nDecisionVars = max(nDecisionVars, ncol(equalCons))
  }
  
  firstSlackIndex = nDecisionVars + 1
  
  # add slack variable for <=
  nSlack = 0
  if (!length(lessEqCons) == 0 && nrow(lessEqCons) > 0) {
    nSlack = nrow(lessEqCons)
    lessEqCons = cbind(lessEqCons, diag(nSlack))
  }
  if (!length(greaterEqCons) == 0 && nrow(greaterEqCons) > 0) {
    greaterEqCons = cbind(greaterEqCons, matrix(0, nrow = nrow(greaterEqCons), ncol = nSlack))
  }
  if (!length(equalCons) == 0 && nrow(equalCons) > 0) {
    equalCons = cbind(equalCons, matrix(0, nrow = nrow(equalCons), ncol = nSlack))
  }
  
  # initialize basis with slack variables if any
  B = c()
  colNames = paste0("x", 1:nDecisionVars)
  if (nSlack > 0) {
    B = firstSlackIndex:(firstSlackIndex+nSlack-1)
    colNames = c(colNames, paste0("s", 1:nSlack))
  }
  
  # subtract surplus variable for >=
  nSurp = 0
  if (!length(greaterEqCons) == 0 && nrow(greaterEqCons) > 0) {
    nSurp = nrow(greaterEqCons)
    greaterEqCons = cbind(greaterEqCons, -1 * diag(nSurp))
  }
  if (!length(lessEqCons) == 0 && nrow(lessEqCons) > 0) {
    lessEqCons = cbind(lessEqCons, matrix(0, nrow = nrow(lessEqCons), ncol = nSurp))
  }
  if (!length(equalCons) == 0 && nrow(equalCons) > 0) {
    equalCons = cbind(equalCons, matrix(0, nrow = nrow(equalCons), ncol = nSurp))
  }
  
  colNames = c(colNames, paste0("s", (nSlack+1):(nSlack+1+nSurp)))  
  
  # initialize Cj with zeros for decision variables, slack, and surplus
  nVarsBeforeArt = nDecisionVars + nSlack + nSurp
  Cj = numeric(nVarsBeforeArt)
  
  # add artificial variable for >= constraints
  nArtFromGreater = 0
  if (!length(greaterEqCons) == 0 && nrow(greaterEqCons) > 0) {
    nArtFromGreater = nrow(greaterEqCons)
    greaterEqCons = cbind(greaterEqCons, diag(nArtFromGreater))
  }
  if (!length(lessEqCons) == 0 && nrow(lessEqCons) > 0) {
    lessEqCons = cbind(lessEqCons, matrix(0, nrow = nrow(lessEqCons), ncol = nArtFromGreater))
  }
  if (!length(equalCons) == 0 && nrow(equalCons) > 0) {
    equalCons = cbind(equalCons, matrix(0, nrow = nrow(equalCons), ncol = nArtFromGreater))
  }
  
  # add artificial variable for = constraints
  nArtFromEqual = 0
  if (!length(equalCons) == 0 && nrow(equalCons) > 0) {
    nArtFromEqual = nrow(equalCons)
    equalCons = cbind(equalCons, diag(nArtFromEqual))
  }
  if (!length(lessEqCons) == 0 && nrow(lessEqCons) > 0) {
    lessEqCons = cbind(lessEqCons, matrix(0, nrow = nrow(lessEqCons), ncol = nArtFromEqual))
  }
  if (!length(greaterEqCons) == 0 && nrow(greaterEqCons) > 0) {
    greaterEqCons = cbind(greaterEqCons, matrix(0, nrow = nrow(greaterEqCons), ncol = nArtFromEqual))
  }
  
  colNames = c(colNames, paste0("a", 1:(nArtFromEqual+nArtFromGreater)))
  
  # store artificial variable indices
  nArt = nArtFromGreater + nArtFromEqual
  artIndeces = (length(Cj)+1):(length(Cj)+nArt)
  
  # set Cj values for artificial variables (all 1s for Phase 1 objective)
  Cj = c(Cj, rep(1, nArt))
  
  # add artificial variables to basis
  B = c(B, artIndeces)
  Cb = Cj[B]
  
  # merge all constraint types into one matrix
  mat = NULL
  if (!length(lessEqCons) == 0 && nrow(lessEqCons) > 0) {
    mat = lessEqCons
  }
  if (!length(greaterEqCons) == 0 && nrow(greaterEqCons) > 0) {
    if (is.null(mat)) {
      mat = greaterEqCons
    } else {
      mat = rbind(mat, greaterEqCons)
    }
  }
  if (!length(equalCons) == 0 && nrow(equalCons) > 0) {
    if (is.null(mat)) {
      mat = equalCons
    } else {
      mat = rbind(mat, equalCons)
    }
  }
  
  ans = TwoPhaseGaussJordan(mat, Cj, B, Cb, Xb, colNames, artIndeces)
  # when all Cj-Zj imply optimal solution but at least one artificial variable present in the basis with positive value. Then the problem has no feasible solution
  # filter the B with the artificial variables only, store its indeces
  presentArt = which(ans$B %in% ans$artIndeces)
  if (length(presentArt) > 0) {
    # check if there is a > 0 value
    if (any(ans$Xb[presentArt] > 0)) {
      return(list(
        mat = ans$mat,
        Cj = ans$Cj,
        B = ans$B,
        Cb = ans$Cb,
        Xb = ans$Xb,
        artIndeces = ans$artIndeces,
        Z = ans$Z,
        allMat = ans$allMat,
        feasible = FALSE
      ))
    }
  } 
  
  return(list(
    mat = ans$mat,
    Cj = ans$Cj,
    B = ans$B,
    Cb = ans$Cb,
    Xb = ans$Xb,
    artIndeces = ans$artIndeces,
    Z = ans$Z,
    allMat = ans$allMat,
    feasible = TRUE
  ))
}

Phase2 <- function(mat, Cj, B, Cb, Xb, artIndeces, obj, phase1Mats) {
  nVar = length(obj)
  colNames = paste0("x", 1:nVar)
  colNames = c(colNames, paste0("s", 1:(length(Cj) - nVar)))
  
  # restore original objective function values
  # extend obj with zeros for slack and surplus variables
  length(obj) = length(Cj)
  obj[is.na(obj)] = 0
  
  Cj = obj
  
  # remove artificial variable columns
  mat = mat[,-artIndeces]
  Cj = Cj[-artIndeces]
  colNames = colNames[-artIndeces]
  
  # recalculate Cb, Zj, and CjZj with new objective function
  Cb = Cj[B]
  Zj = colSums(Cb * mat, na.rm = TRUE)
  CjZj = Cj - Zj
  Z = sum(Cb * Xb)
  
  Phase2Tableau = TwoPhaseGaussJordan(mat, Cj, B, Cb, Xb, colNames)
  if (is.null(Phase2Tableau)) {
    return(NULL)
  } else {
    solution = c()
    for (i in 1:nVar) {
      if (i %in% Phase2Tableau$B) {
        solution[i] = Phase2Tableau$Xb[which(Phase2Tableau$B == i)]
      } else{
        solution[i] = 0
      }
    }
    return(list(
      solution = solution,
      optimized_cost = Phase2Tableau$Z,
      allMat = list(
        phase1 = phase1Mats,
        phase2 = Phase2Tableau$allMat
      )
    ))
  }
}

# two-phase algorithm references: 
# https://cbom.atozmath.com/example/CBOM/Simplex.aspx?q=tp&q1=E1

Simplex <- function(obj, greaterEqCons = NULL, lessEqCons = NULL, equalCons = NULL) { 
  Phase1Ans = Phase1(obj, greaterEqCons, lessEqCons, equalCons)
  # no solution
  if (!Phase1Ans$feasible) {
    return(list(
      allMat = list(
        phase1 = Phase1Ans$allMat,
        phase2 = NULL
      )
    ))
  } else {
    mat = Phase1Ans$mat
    Cj = Phase1Ans$Cj
    B = Phase1Ans$B
    Cb = Phase1Ans$Cb
    Xb = Phase1Ans$Xb
    artIndeces = Phase1Ans$artIndeces
    phase1Mats = Phase1Ans$allMat
    # return solution, optimized cost, allmat
    return(Phase2(mat, Cj, B, Cb, Xb, artIndeces, obj, phase1Mats))
  }
}