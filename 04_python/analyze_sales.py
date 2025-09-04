import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os

# --- 1. Load Data ---
# Set the base path to the project directory
# IMPORTANT: Adjust this if your script is not in the '04_python' subfolder
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
    print("Please make sure your CSV files are in the '01_data' folder")
    exit()

