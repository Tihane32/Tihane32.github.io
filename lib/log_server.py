import json
from flask import Flask, request
import sqlite3

app = Flask(__name__)

def create_table(table_name, cursor, log_pairs):
    # Create table if it doesn't exist
    cursor.execute(f''' 
                   CREATE TABLE IF NOT EXISTS "{table_name}" (
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
            consumption DOUBLE,
            cost DOUBLE,
            date INT
        )
    ''')

    # Check if each key in log_pairs corresponds to a column in the table
    for key in log_pairs.keys():
        cursor.execute(f"PRAGMA table_info({table_name})")
        columns = cursor.fetchall()
        column_names = [column[1] for column in columns]

        # If the key is not already a column, add it to the table
        if key not in column_names:
            cursor.execute(f"ALTER TABLE {table_name} ADD COLUMN {key} TEXT")

@app.route('/log/<table_name>', methods=['POST'])
def receive_log(table_name):
    log_message = request.get_data(as_text=True)
    #print(log_message)

    # Parse the log message and extract key-value pairs
    log_pairs = {}
    table_pairs = {}

    # Extract key-value pairs from the modified log message
    table_name="data"
   
    with sqlite3.connect('logs.db') as conn:
        cursor = conn.cursor()

        # Check if the table exists, create it if not
        create_table(table_name, cursor, log_pairs)
      
        # Create the SQL query dynamically based on the keys in log_pairs
        columns = ', '.join(log_pairs.keys())
        placeholders = ', '.join(['?'] * len(log_pairs))
        query = f"INSERT INTO {table_name} ({columns}) VALUES ({placeholders})"

        # Execute the query with values from log_pairs
        cursor.execute(query, tuple(log_pairs.values()))
        conn.commit()

    return 'Log received and saved successfully\n'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
