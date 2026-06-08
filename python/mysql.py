"""
ETL Pipeline: Load cleaned AI Job Market dataset into MySQL

Purpose:
- Extract cleaned data from CSV
- Establish connection with MySQL database
- Load data into a MySQL table
- Verify successful data transfer

Author: Data Project
"""

# ----------------------------
# 1. Import Libraries
# ----------------------------
import pandas as pd
from sqlalchemy import create_engine
import os
from dotenv import load_dotenv


# ==================================================
# 2. Load Environment Variables
# ==================================================
# Reads database credentials from .env file
load_dotenv() 
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_HOST = os.getenv("DB_HOST")
DB_NAME = os.getenv("DB_NAME") 


# ----------------------------
# 3. Extract (load data)
# ----------------------------
df = pd.read_csv(r"C:\AI_Job_Market_Project\data\Cleaned_job_dataset.csv")



# ----------------------------
# 4. Load (Connect to MYSQL)
# ----------------------------
engine = create_engine(
    f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}/{DB_NAME}"
)


# ----------------------------
# 5. Test Connection
# ----------------------------
with engine.connect() as conn:
    print("MySQL connection successful")



# ------------------------------
# 6. Load Data into MYSQL Table
# ------------------------------
df.to_sql(
    name="ai_job_market",
    con=engine,
    if_exists="replace",   # use append in production
    index=False,
    chunksize= 1000        # improves performance for large data
)


# ----------------------------
# 7. Final Confirmation
# ----------------------------
print("ETL process completed: data loaded into MySQL successfully")








