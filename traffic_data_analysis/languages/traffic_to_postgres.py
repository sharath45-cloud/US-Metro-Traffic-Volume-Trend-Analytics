import os
import pandas as pd
from sqlalchemy import create_engine

Db_user = 'postgres'
Db_Name = 'postgres'
Db_host = 'localhost'
Db_port = '5432'
Db_password = '152911'

CSV_file_path = r'C:\Users\shara\pythonstart\traffic_data_final.csv'

def load_and_clean_data(file_path):
    if not os.path.exists(file_path):
        print(f"[ERROR] Source file not found at: {file_path}")
        return None
    try:
        df = pd.read_csv(file_path)               
        df.columns = df.columns.str.lower()
        print(f"[INFO] Successfully loaded and cleaned {len(df)} rows.")
        return df
    except Exception as e:
        print(f"[ERROR] Failed to read or clean file: {e}")
        return None

def main():
    print("[INFO] Starting Data Pipeline...")
    
    df = load_and_clean_data(CSV_file_path)
    if df is None:
        return
        
    try:
        connection_string = f'postgresql://{Db_user}:{Db_password}@{Db_host}:{Db_port}/{Db_Name}'
        engine = create_engine(connection_string)
        
        print("[INFO] Ingesting data into PostgreSQL...")
        df.columns = df.columns.str.lower().str.replace(' ', '_').str.replace('-', '_')
        df.to_sql('traffic_data', con=engine, if_exists='replace', index=False)
        
        print("[SUCCESS] Data Pipeline executed successfully. Data loaded to pgAdmin.")
        
    except Exception as e:
        print(f"[CRITICAL] Pipeline execution failed: {e}")

if __name__ == "__main__":
    main()
