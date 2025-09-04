import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os

# --- 1. Load Data ---
# This script assumes it is located in the '04_python' folder.
# The 'base_path' points up one level and then into the '01_data' folder.
# This makes the script portable as long as the folder structure is maintained.
base_path = os.path.join('..', '01_data') 

customers_path = os.path.join(base_path, 'customers.csv')
products_path = os.path.join(base_path, 'products.csv')
orders_path = os.path.join(base_path, 'orders.csv')

print("Loading data...")
try:
    customers_df = pd.read_csv(customers_path)
    products_df = pd.read_csv(products_path)
    orders_df = pd.read_csv(orders_path)
    print("Data loaded successfully.")
except FileNotFoundError as e:
    print(f"Error loading data: {e}")
    print("Please make sure your CSV files are in the '01_data' folder and you are running this script from '04_python'.")
    exit()

# --- 2. Clean and Preprocess Data ---
print("\nCleaning and preprocessing data...")
# Convert date columns to datetime objects for time-based analysis
orders_df['order_date'] = pd.to_datetime(orders_df['order_date'])
customers_df['signup_date'] = pd.to_datetime(customers_df['signup_date'])

# Standardize text data for consistency
orders_df['channel'] = orders_df['channel'].str.title()
orders_df['payment_method'] = orders_df['payment_method'].str.replace('_', ' ').str.title()

# --- 3. Merge DataFrames ---
# Create one master DataFrame containing all information for our analysis
print("Merging data...")
# Merge orders with products to get price and product details
df = pd.merge(orders_df, products_df, on='product_id', how='left')
# Merge the result with customers to get customer details
df = pd.merge(df, customers_df, on='customer_id', how='left')

# Create a new 'revenue' column for financial calculations
df['revenue'] = df['quantity'] * df['price']

# Create a separate dataframe for financial analysis that excludes returned orders
df_sales = df[df['returned'] == 'N'].copy()
print("Data merged and preprocessed.")

