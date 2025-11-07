# Data Warehouse and Analytics Project

Welcome to the **Data Warehouse and Analytic Project** repository!
This project demonstrates a comprehensive data warehousing and analytics, from building a data warehouse to generating actionable insights. This portfolio project showcases industry best practices in data engineering and analytics.

---

## Project Overview
This project involves:

1. **Data Architecture**: Designing a modern data warehouse using Medalion Architecture **Bronze**, **Silver**, and **Gold** layers.
2. **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the data warehouse.
3. **Data Modeling**: Develping fact and dimension tables optimized for analytical queries.
4. **Analytics & Reporting**: Creating SQL-based reports to support data-driven decisions.

This repository is an excellent resource for professionals, and students looking to showcase expertise in:

* SQL Development
* Data Architect
* Data Engineering
* Building ETL Pipeline
* Data Modeling
* Data Analytics

---

## SQL Scripts Overview
This directory contains all SQL scripts used for creating, extracting, transforming, loading, and auditing data across different layers in the data warehouse. Each subfolder represents a schema in the data warehouse.

### 1. bronze (Raw Data Ingestion)
Holds raw data as-is in the source system. Typical scripts include:
* **DDL Script**: Creates tables in the bronze layer.
* **Stored Procedure**: A stored procedure is created for each of the bronze table, extracting data from the source system and loading the bronze using the **BULK INSERT** command.

### 2. silver (Data Cleansing & Transformations)
Holds cleaned and prepared data. Typical scripts include:
* **DDL Script**: Creates tables in the silver layer.
* **Stored Procedure**: A stored procedure is created for each of the silver table, extracting, transforming, & loading using the **SELECT** and **INSERT** statements.

### 3. gold (Analytics & Data Marts)
Holds business-ready data. Contains **DDL Scripts** that performs the following operations:
* creates vital business objects,
* categorize them into either **dimension** or **fact**, and
* build a newly integrated data model.

### 4. audit (Logging & Monitoring)
Holds vital executions details of the etl process, enabling easy monitoring, traceability, and debugging. Typical scripts include:
* **audit.etl_log**: Creates the etl log table. 
* **audit.etl_master_log**: Creates the etl master log table.

### 5. etl (Orchestration & Procedures)
Holds stored procedures of the bronze and silver layer, performing a full etl run when executed. Typical scripts include:
* **etl_run_master_pipeline**: Performs the full etl run.
* **etl_pipeline_control**: monitors the execution order or sequence of the stored procedures in the master procedure.

---

## Project Requirements

### Build a Data Warehouse (Data Engineering)

#### Objective

Create a mordern **data warehouse using SQL server** to consolidate sales data, enabling analytical reporting and informed decision-making.

##### Specifications

* **Data Sources**: Import data from two source systems (CRM and ERP), provided as CSV files.
* **Data Quality**: Cleanse and resolve data quality issue prior to analysis.
* **Integration**: Consolidate both data from data sources into user friendly data, enabling analytical queries.
* **Scope**: Focus on latest data only; no historization allowed.
* **Documentation**: Provide clear documentation of the data model to support business stakeholders and analytical teams.

---

## 01. Analytics and Reporting (Data Analytics)

### Objectives

Generate an SQL-based analytics that provide detailed insights into:

* **Customer Behaviour**
* **Product Performance**
* **Sales Trends**

These provide key metrics to support strategic decision-making and business growth.

---

## Data Architecture
The data architecture follows the Medalion Architecture **Bronze**, **Silver**, and **Gold** layers:

![data_architecture.png](docs/data_architecture.png)

1. **Bronze Layer**: Stores raw data as-is from the source system, enabling traceability and debugging.
2. **Silver Layer**: Stores cleaned, prepared, and transformed data. It is designed to support analysis.
3. **Gold Layer**: Houses business-ready data modeled into a star schema, supporting reporting and analytics.

---

## License
This project is lincesed under **MIT Lincense**. You are free to use, modify, or share with proper attribution.

---

## About Me
Hi there! I'm **Otusanya Toyib Oluwatimilehin**, a **First-Class Gradute** of Industrial Chemistry from Olabisi Onabanjo University. I'm an aspiring **Data Engineer and Analyst** passionate about building reliable data pipelines, efficient data models, and generating data-driven business decisions. 

<img src="https://cdn-icons-png.flaticon.com/128/724/724664.png" width="18" alt="Phone"/> **07060784176** 
<img src="https://cdn-icons-png.flaticon.com/128/732/732200.png" width="18" alt="E-mail"/> **toyibotusanya@gmail.com**
