# Data Dictionary for Gold Layer

## Overview
The **Gold Layer** is composed of business-ready data, structured to support analytical and reporting use cases. 
It consists of the following:

* **dimension tables**, and
* **fact tables**

These tables contain key business metrics that supports analysis, and thus informed-decision making.

---

### 1. gold.dim_customers
* **Purpose:** Stores customer details, enriched with demographics and geographics data
* **Columns:**

|   **Column Name**  |   **Data Type**     |   **Description**                                                                         |
|--------------------|---------------------|-------------------------------------------------------------------------------------------|
|customer_key         |INT                 |Surrogate key uniquely identifying each customer record in the dimension table.|
|customer_id          |INT                 |Unique numerical identifier assigned to each customer.|
|customer_number      |NVARCHAR(50)        |Alphanumerical identifier representing each customer, used for tracking and referencing.|
|first_name           |NVARCHAR(50)        |The customer's first name recorded in the system.|
|last_name            |NVARCHAR(50)        |The customer's last name recorded in the system.|
|country              |NVARCHAR(50)        |The customer's country of residence (e.g., 'Australia'.|
|marital_status       |NVARCHAR(50)        |The marital status of the customer (e.g., 'Married', 'Single', 'N/A'.|
|gender               |NVARCHAR(50)        |The gender of the customer (e.g., 'Male', 'Female', 'N/A'.|
|birth_date           |DATE                |The date of birth of the customer, formatted as YYYY-MM-DD (e.g., '1971-10-06'.|
|create_date          |DATE                |The date the customer record was created in the system (e.g., '2025-10-06'.|

---

#### 2. gold_dim_products
* **Purpose:** Provides detailed information about the products and their attributes
* **Columns:**

|   **Column Name**  |   **Data Type**     |   **Description**                                                                         |
|--------------------|---------------------|-------------------------------------------------------------------------------------------|
|product_key         |INT                  |Surrogate key uniquely identifying each product record in the dimension table.|
|product_id          |INT                  |Unique numerical identifier assigned to each product.|
|product_number      |NVARCHAR(50)         |Alphanumerical identifier representing each product, used for tracking and referencing.|
|product_name        |NVARCHAR(50)         |Descriptive name of the product, including key details such as type, colour, and size.|
|category_id         |NVARCHAR(50)         |A unique identifier for each product's category.|
|category            |NVARCHAR(50)         |A broader classification of products (e.g., 'Bike', 'Components'.| 
|subcategory         |NVARCHAR(50)         |A more detailed classification of products (e.g., 'Road Frames', 'Mountain Bikes'.|
|maintenance         |NVARCHAR(50)         |Indicates whether the product requires maintenance or not (e.g., 'Yes', 'No'.|
|cost                |INT                  |The cost or base price of the product measured in monetary units.|
|product_line        |NVARCHAR(50)         |The specific product line or series to which the product belongs (e.g., 'Road', 'Mountain'|
|start_date          |DATE                 |The date the product became available for sale|

---

##### 3. gold.fact_sales
* **Purpose:** Stores transactional sales data for analytical purposes
* **Columns:**

|   **Column Name**  |   **Data Type**     |   **Description**                                                                         |
|--------------------|---------------------|-------------------------------------------------------------------------------------------|
|order_number        |NVARCHAR(50)         |A unque alphanumerical identifier assigned to each sales order (e.g., 'SO54496'.|
|product_key         |INT                  |Surrogate key, linking **fact_sales** to **dim_products**.|
|customer_key        |INT                  |Surrogate key, linking **fact_sales** to **dim_customers**.| 
|order_date          |DATE                 |The date an order was placed.|
|ship_date           |DATE                 |The date the product was shipped.|
|due_date            |DATE                 |The date the product is expected to be delivered.|
|sales_amount        |INT                  |The total monetary value of the sale for the line item, in whole currency units (e.g., 25).|
|quantity            |INT                  |The number of units of the product ordered for the line item (e.g., 1).|
|price               |INT                  |The price per unit of the product for the line item, in whole currency units (e.g., 25).|
