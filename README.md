# City Pollution Reduction Planner

An interactive R Shiny dashboard designed to optimize pollution mitigation strategies using mathematical linear programming.

---

## 📌 Overview

Greenvale faces a strict government mandate to drastically reduce its pollution footprint within a year. The city must hit specific target reductions across **10 priority pollutants** while operating on a limited budget.

The **City Pollution Reduction Planner** solves this by modeling the scenario as a linear programming optimization problem. Using the **Two-Phase Simplex Method**, the application calculates the minimum-cost allocation of units across **30 different mitigation projects** (distributed over the city's 20 barangays) that successfully satisfies all environmental targets.

<img width="1890" height="960" alt="image" src="https://github.com/user-attachments/assets/4fd33721-faa7-4bdd-a167-8a2541c013fb" />

---

## 🚀 Key Features

* **Linear Programming Engine**: Employs a custom Two-Phase Simplex algorithm to calculate exact cost-optimal deployment scenarios.
* **Categorized Project Selection**: Users can select from 30 mitigation projects divided into 5 distinct categories:
  * ⚡ Energy & Power
  * 🚌 Transport
  * 🏭 Industry & Emissions
  * 🏡 Residential & Community
  * 🌾 Land Use & Agriculture
* **Interactive Tooltips**: Hovering over projects reveals cost structures and exact pollutant-reduction metrics.
* **Step-by-Step Simplex Tableaus**: Access an interactive modal that displays step-by-step iterations and matrix transformations of the Simplex calculation (both Phase 1 and Phase 2), showing how the algorithm arrives at the optimal solution.
* **Feasibility Checks**: Instantly alerts the user if their selected combination of projects cannot mathematically meet the pollution targets (Infeasible Solution).

---

## 🛠️ Tech Stack

* **Language**: R
* **UI Framework**: `shiny`, `bslib`
* **Data Presentation**: `DT` (DataTables)
* **Optimization Engine**: Custom linear programming solver (Two-Phase Simplex approach)

---

## ⚙️ Installation & Running

### Option 1: Run Directly from GitHub (Fastest)

You can run this application directly inside your R console without downloading the repository manually. Open R/RStudio and run:

```R
# Install required packages if you don't have them
install.packages(c("shiny", "bslib", "DT"))

# Launch the app directly from GitHub
shiny::runGitHub("ashdsabandal/city-pollution-reduction-planner")
```


### Option 2: Run Locally

1. **Clone the repository**:
   ```bash
   git clone https://github.com/ashdsabandal/pollution-reduction-planner.git
   cd city-pollution-reduction-planner
   ```
2. **Install R packages**:
   Launch R or RStudio and run:
   ```R
   install.packages(c("shiny", "bslib", "DT"))
   ```
3. **Run the App**:
   * In **RStudio**: Open `app.R` and click the **Run App** button in the top-right of the editor.
   * In **R Console**: Run:
     ```R
     shiny::runApp()
     ```

---

## 📊 How the Optimization Works

The planner implements a classic linear programming optimization model:

* **Decision Variables**: $x_i \in [0, 20]$ for $i \in \{1, 2, ..., 30\}$, representing the units of project $i$ to deploy. (Max units are capped at 20, matching the number of barangays).
* **Objective Function**: Minimize Total Cost:
  $$\text{Minimize } Z = \sum_{i=1}^{30} c_i x_i$$
  where $c_i$ is the unit cost of project $i$.
* **Constraints**: Meet or exceed target reduction $T_j$ for each pollutant $j$:
  $$\sum_{i=1}^{30} r_{ij} x_i \ge T_j \quad \forall j \in \{1, 2, ..., 10\}$$
  where $r_{ij}$ is the reduction of pollutant $j$ yielded by one unit of project $i$.

The app uses the **Two-Phase Simplex Method** because the $\ge$ constraints require artificial variables in Phase 1 to construct a basic feasible solution before optimizing the cost function in Phase 2.

---

## 👤 Author

* **Ashley Mark Sabandal** (Student No: 2023-08459, Section AB-3L)
* University of the Philippines Los Baños (UPLB)
