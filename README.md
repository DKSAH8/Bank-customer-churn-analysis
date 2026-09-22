# 🏦 Bank Customer Churn Analysis

<div align="center">

![Python](https://img.shields.io/badge/Python-3.13.9-blue?style=for-the-badge&logo=python)
![SQL](https://img.shields.io/badge/SQL-MySQL-orange?style=for-the-badge&logo=mysql)
![Pandas](https://img.shields.io/badge/Pandas-2.3.3-green?style=for-the-badge&logo=pandas)
![Status](https://img.shields.io/badge/Status-Complete-success?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)

**An end-to-end data analytics project identifying the key drivers of customer churn in a retail banking portfolio, with actionable retention strategies.**

[Overview](#-project-overview) • [Key Findings](#-key-findings) • [Tech Stack](#-tech-stack) • [Structure](#-repository-structure) • [Insights](#-business-insights) • [Recommendations](#-strategic-recommendations)

</div>

---

## 📌 Project Overview

Customer churn is one of the most expensive problems in retail banking — acquiring a new customer costs **5–7x more** than retaining an existing one. This project performs a comprehensive analysis of **10,000 bank customers** to answer three critical business questions:

1. **Who** is churning and where?
2. **Why** are they churning?
3. **What** can be done to retain them?

The analysis combines **SQL querying**, **Python-based exploratory data analysis (EDA)**, and **business storytelling** to deliver a 360° view of churn behavior.

### 🎯 Business Problem
> *"The bank is losing ~20% of its customers annually, including high-value, high-salary segments. Identify root causes and propose data-backed retention strategies."*

---

## 🔍 Key Findings at a Glance

| Metric | Value | Insight |
|--------|-------|---------|
| **Total Customers** | 10,000 | Full portfolio analyzed |
| **Churned Customers** | 2,037 | Significant revenue loss |
| **Churn Rate** | **20.37%** | 1 in 5 customers leaves |
| **Average Balance** | $76,485.89 | High-value base at risk |
| **Average Credit Score** | 651 | Fair-to-good range |
| **Highest Balance** | $250,898.09 | Premium customers matter |
| **Avg. Customer Salary** | $100,090.24 | Churned users earn well |

### 🚨 Top 5 Drivers of Churn
1. **Geography** — Germany has the highest churn (~32%) vs. France & Spain
2. **Age** — Customers aged **35–50** churn most frequently
3. **Product Count** — Customers with **only 1 product** churn heavily
4. **Activity Status** — Inactive members churn 2x more than active ones
5. **Credit Score** — "Fair" and "Poor" credit segments show elevated exits

---

## 🛠 Tech Stack

| Layer | Tools Used |
|-------|------------|
| **Language** | Python 3.13.9, SQL |
| **Data Manipulation** | Pandas, NumPy |
| **Visualization** | Matplotlib, Seaborn |
| **Database** | MySQL |
| **Environment** | Jupyter Notebook, Anaconda |
| **Reporting** | PDF report, Markdown |

---

## 📁 Repository Structure

Bank-customer-churn-analysis/
│
├── 📂 data/
│ └── Bank_Customer_Churn.csv # Raw dataset (10,000 rows, 14 columns)
│
├── 📂 notebooks/
│ └── Banking_Customer_Churn.ipynb # Full EDA, cleaning & visualizations
│
├── 📂 pdf/
│ └── Bank_Customer_Churn.pdf # Screenshots of 
|
├── 📂 power bi/
│ └── Banking Customer Churn Analytics Dashboards. pbix # Executive summary report, etc.
│
├── 📂 sql/
│ └── Bank_Customer_Churn.sql # Executive summary report # 24 business queries (joins, CTEs, window functions)
│
├── gitignore LICENSE
├── LICENSE
└── README.md
