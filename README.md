# Islander Drug Analysis

## Notebook with output available via link:
https://curlykrissi.github.io/islander-memory-analysis/code/Islander_project.html

## Project Overview

This project analyzes the **Islander dataset** to investigate how different experimental drugs influence memory improvement. The analysis evaluates whether treatment improves memory performance and examines how factors such as drug type, dosage, age group, mood, and family background may influence treatment response.

The project was conducted in **R using the tidyverse ecosystem** and demonstrates a complete data analysis workflow including exploratory analysis, statistical testing, and visualization.

---

## Research Questions

The analysis addresses the following questions:

1. Do participants show overall memory improvement after treatment?
2. Do different drugs produce different levels of improvement?
3. Does drug dosage influence memory improvement?
4. Does age affect treatment response?
5. Does emotional valence influence recall?
6. Do individuals from the same family respond similarly to treatment?

---

## Dataset

The dataset contains measurements from participants who received one of three experimental drugs.

**Key variables include:**

- **Mem_Score_Before** – memory score before treatment  
- **Mem_Score_After** – memory score after treatment  
- **Diff** – change in memory score  
- **Drug** – treatment type (A, S, T)  
- **Dosage** – administered dose level  
- **Age_group** – participant age category  
- **Happy_Sad_group** – emotional valence  
- **Family** – family identifier  

---

## Methods

### Exploratory Data Analysis
- Summary statistics by treatment group
- Distribution of memory improvement

### Statistical Testing
- **Paired t-test** to compare memory scores before and after treatment
- **ANOVA** to evaluate differences between drugs
- **Tukey HSD** post-hoc test for pairwise drug comparisons

### Modeling
- Linear models to assess the influence of predictors such as age group

### Visualization
- Dose–response plots
- Heatmaps showing family response patterns
- Grouped summary plots

---

## Key Findings

- Overall memory performance significantly improved after treatment.
- **Drug A produced the strongest improvement in memory scores.**
- Drugs S and T showed similar but weaker effects.
- Dose–response patterns suggest higher dosages may enhance treatment effectiveness.
- Age showed a modest influence on response, with middle-aged participants showing slightly larger improvements.
- Family-level patterns indicate that genetic background does not strongly determine treatment response.

---

## Technologies Used

- **R**
- **tidyverse**
- **ggplot2**
- **dplyr**
- **reshape2**
- **ggpubr**
- **knitr**

---

## Repository Structure

```text
Islander_drug_analysis/
├── code/
├── graphs/
├── data/
└── README.md
