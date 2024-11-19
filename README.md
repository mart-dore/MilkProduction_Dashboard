# Milk Production Analysis

## 📚 Overview

This project involves a **Milk Production Analysis** and was developed as part of my work as a **freelance Data Analyst**. The project utilizes an **RShiny** application to provide a comprehensive analysis of milk production data. Users can upload their own `data.xlsx` files to explore various analytical insights related to milk production trends and metrics.  

One of the main features of this dashboard is to enable *non-expert* in data analysis to conduct a complete statistical and machine learning study in an intuitive and straightforward manner. The primary objective is to facilitate the comparison of milk production between two distinct groups, providing clear insights and actionable results through user-friendly tools and visualizations.

## 🛠 Files and Directories

- **Data/**: Contains sample datasets for testing the application.
- **app.R**: The main R script that launches the RShiny application, providing an interactive user interface for data analysis.
- **data.xlsx**: A sample dataset to demonstrate the functionality of the application.
- **README.md**: Project description and instructions on how to use the application.


## Dashboard Pages
### Data Importation
Allows you to import your dataset, clean the data (remove outliers, missing values...) and choose a range of date to focus on. And then download dataset to save changes.
![image](https://github.com/user-attachments/assets/e274a9fc-e9f6-4115-b6c7-70cbae91e219)

### Data Visualisation
Differents interactive plotly plots to understand repartition of the data and differences between groups.
![image](https://github.com/user-attachments/assets/725d4553-83c6-40f2-a55f-9dbdfc23d021)


### Statistical Analysis
Allows you to choose the formula of a multiple linear regression model and visualise it.
![image](https://github.com/user-attachments/assets/53282a3f-56b9-48ad-a75d-59050b74a4fb)

### Indicator Creation
To create indicators/KPIs to compare both groups.
![image](https://github.com/user-attachments/assets/7b4c587c-c59b-475f-964a-3e575482ea97)


## 📡 Live Demo

You can try the application live by visiting: [**LIVE DEMO**](https://martindore.shinyapps.io/Milk_Production_Analysis/)

## 🚀 How to Use on your own

1. Clone the repository:
   ```bash
   git clone [repository URL]
   ```
   
2. Run the RShiny application:
   ```R
   shiny::runApp("app.R")
   ```

4. Upload your `data.xlsx` file within the application interface to start analyzing the milk production data.

## 📂 Project Structure

```
├── app.R                   # R script for the RShiny application
├── data.xlsx               # Sample dataset for demonstration
└── README.md               # Project description
```

## 📝 Future Enhancements

- Add more visualizations to enhance data interpretation.
- Implement machine learning models for predictive analytics based on the milk production data.
- Allow users to customize their analysis parameters for more tailored insights. 
