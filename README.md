# Milk Production Analysis — R Shiny Dashboard

A dashboard built during a **freelance Data Analyst engagement**, so that people with no
statistics background could run a complete comparative study on their own production data —
cleaning, visualisation, regression and KPIs — without writing a line of R.

**▶ [Try the live application](https://martindore.shinyapps.io/Milk_Production_Analysis/)**

![R](https://img.shields.io/badge/R-276DC3?style=flat-square&logo=r&logoColor=white)
![Shiny](https://img.shields.io/badge/Shiny-276DC3?style=flat-square&logo=rstudio&logoColor=white)
![Plotly](https://img.shields.io/badge/Plotly-3F4F75?style=flat-square&logo=plotly&logoColor=white)

---

## The problem

The client needed to compare milk production between two groups of animals and decide whether
the difference was real or noise. They had the data and the domain expertise; what they did not
have was a statistician on call every time a new question came up.

So the deliverable was not an analysis. It was a tool that lets them run the analysis themselves,
as many times as they want, on data they upload.

## What the dashboard does

### 1. Data import and cleaning
Upload an `.xlsx` file, remove outliers and missing values, restrict to a date range, then
download the cleaned dataset to keep the changes.

![Data import](https://github.com/user-attachments/assets/e274a9fc-e9f6-4115-b6c7-70cbae91e219)

### 2. Interactive visualisation
Plotly charts to inspect distributions and compare the two groups.

![Visualisation](https://github.com/user-attachments/assets/725d4553-83c6-40f2-a55f-9dbdfc23d021)

### 3. Statistical analysis
Build a multiple linear regression by choosing the formula interactively, then visualise the fit.

![Statistical analysis](https://github.com/user-attachments/assets/53282a3f-56b9-48ad-a75d-59050b74a4fb)

### 4. Indicator creation
Define custom KPIs to compare the two groups on the metrics that matter to the business.

![Indicators](https://github.com/user-attachments/assets/7b4c587c-c59b-475f-964a-3e575482ea97)

## Design decisions

- **Everything is reactive to the upload.** No dataset is hardcoded; the app works on any file
  matching the expected column structure.
- **Cleaning is exposed, not hidden.** The user decides what counts as an outlier and sees the
  effect immediately — a black-box cleaning step would have destroyed trust in the output.
- **The cleaned data is downloadable.** The tool does not hold the client's data hostage.

## Running it locally

```bash
git clone https://github.com/mart-dore/MilkProduction_Dashboard
cd MilkProduction_Dashboard
```

```r
shiny::runApp("app_10_02.R")
```

Then upload `data.xlsx` (included as a sample) through the interface.

Requires: `shiny`, `plotly`, `readxl`, `dplyr`, `ggplot2`.

## Project structure

```
├── app_10_02.R    # The full Shiny application: UI + server
├── data.xlsx      # Sample dataset, to try the app immediately
└── README.md
```

## Next steps

- Predictive modelling on production trends, not just descriptive comparison
- Export a formatted report from the app, so results can be shared without the app
- Column mapping at upload time, to accept files that do not match the expected schema

## License

MIT — see [LICENSE](LICENSE).
