# IU Retail A/B Testing Data Pipeline (Snowflake + dbt + Tableau)

This project simulates an **A/B testing framework** to evaluate the impact of different checkout versions on user behavior and purchase patterns for IU Retail. The end-to-end pipeline supports scalable data ingestion, transformation, and reporting using modern ELT tools.

<img width="1072" alt="Screenshot 2025-05-23 at 5 31 06 PM" src="https://github.com/user-attachments/assets/86328d86-9faf-43dc-ab58-361c7ebe7129" />

Built as part of IU Center of Education and Research in Retail’s experimentation platform
---

## 📌 Objective

To analyze the effectiveness of two checkout versions (A vs. B) on key user engagement metrics:

- Average order value
- Items in cart
- Upsell click-through
- Product category interest
- Time-based shopping trends

---

## 🛠️ Tech Stack

| Layer              | Tools Used                                       |
|-------------------|--------------------------------------------------|
| Data Generation    | Python (`faker`, `pandas`, `boto3`)              |
| Cloud Storage      | AWS S3                                           |
| Data Warehouse     | Snowflake                                        |
| Data Transformation| dbt (incremental + staging models)              |
| Business Reporting | Tableau                                          |

---

## 🔁 End-to-End Workflow

1. **Data Generation**: 
   - Simulated order data is created using Python and stored as `.csv` files.
   - Each record includes fields like `order_id`, `user_id`, `checkout_version`, `items_list`, `order_value`, and `upsell_clicked`.

2. **Data Ingestion**:
   - The `.csv` files are uploaded to an AWS S3 bucket.

3. **Staging in Snowflake**:
   - A Snowflake external stage is configured to read files from S3.
   - Raw data is copied into a staging table (`RAW_LAYER.ab_test_orders`).

4. **Data Transformation with dbt**:
   - A **staging model** standardizes formats, casts types, and parses timestamps.
   - An **incremental model** adds derived fields (purchase year, month, item array) and filters for new or changed records based on a `change_time` field.
   - Data is materialized into a clean mart table (`processed_ab_test_orders`).

5. **Dashboarding with Tableau**:
   - Tableau is connected to the Snowflake mart table.
   - Dashboards include:
     - Conversion comparison by checkout version
     - Average order value distribution
     - Heatmap of purchases over time
     - Impact of upsell clicks
     - Cart behavior patterns

---

## 📦 Dataset Schema Overview

The pipeline handles the following fields per record:

- `order_id` – Unique transaction ID
- `user_id` – Unique customer ID
- `checkout_version` – A/B version shown at checkout
- `items_in_cart` – Number of products added
- `items_list` – List of product names
- `upsell_clicked` – Boolean indicator if upsell prompt was clicked
- `order_value` – Final value of the purchase
- `date_of_purchase` – Transaction timestamp
- `change_time` – Timestamp of data ingestion (used for incremental loads)

Derived fields in the mart table include:
- `purchase_year`, `purchase_month`, `purchase_day`
- `items_array` – list of parsed items from `items_list`

---

## 📈 Tableau Dashboard Metrics

The final Tableau dashboard surfaces business insights such as:

- Average order value by checkout version
- Time-based purchasing trends (daily, weekly, monthly)
- Upsell click-through vs. order value
- Distribution of product categories per version
- Conversion patterns by number of items in cart

---

---

## 🧪 dbt Features Used

- **Incremental models**: Ensures only new or updated data is processed
- **Ephemeral models**: For reusable logic in temporary transformations
- **YAML-based Testing**: Enforced not-null and uniqueness constraints
- **Ref & Source Functions**: Clean modular dependencies for source and staging layers

---

## ✅ Benefits

- Efficient incremental loads reduce compute cost and processing time.
- Modular dbt models allow fast iteration and clear data lineage.
- Tableau integration provides fast, actionable insights for product and business teams.
- Supports experimentation at scale with structured A/B testing design.

---

## 🚀 How to Reproduce

1. Clone this repository
2. Upload `.csv` data to S3 bucket
3. Set up Snowflake external stage and raw table
4. Configure your `profiles.yml` and run:

```bash
dbt run
dbt test
