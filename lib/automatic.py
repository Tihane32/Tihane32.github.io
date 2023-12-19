import sqlite3
from flask import Flask, jsonify
from flask_cors import CORS  # Import CORS from flask_cors
from flask_cors import cross_origin
from flask import Flask, request





def get_data(table_name):
   
        
        # Execute your SQL query to fetch data from the specified table for the specified date range
       
        with sqlite3.connect('automatic.db') as conn:
            cursor = conn.cursor()
            # Assuming date is stored as a UNIX timestamp in the 'date' column
            query = f"SELECT soovitud_tunnid FROM {table_name}"
            print("SQL Query:", query)  # Add this line to print the SQL query
            cursor.execute(query)
            result = cursor.fetchall()
            print("Fetched Data:", result)
        # Convert the data to a JSON response
        response_data = result

        print(response_data)
        
        return response_data
        
    
    
def get_table_names(database_path):
    connection = sqlite3.connect(database_path)
    cursor = connection.cursor()

    # Query to retrieve all table names
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
    
    # Fetch all table names
    table_names = cursor.fetchall()

    # Clean up
    cursor.close()
    connection.close()

    # Extract table names from the result
    table_names = [name[0] for name in table_names]

    return table_names

    


database_path = 'automatic.db'
table_names = get_table_names(database_path)



for table in table_names:
    print("Table name:", table)
    soovitudTund=get_data(table)
    soovitudTund=soovitudTund[0][0]
    print(soovitudTund)


