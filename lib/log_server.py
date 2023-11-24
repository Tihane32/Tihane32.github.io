import json
from flask import Flask, request
import sqlite3

app = Flask(__name__)

def create_table(table_name, cursor, log_pairs):
    # Create table if it doesn't exist
    cursor.execute(f''' 
        CREATE TABLE IF NOT EXISTS "{table_name}" (
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
            date INT,
            cost DOUBLE,
            consumption DOUBLE
            
        )
    ''')



def process_log_data(log_message):
    # Convert the log_message dictionary into a list of tuples (date, cost, consumption)
    log_data = [
        (
            int(timestamp),
            entry.get('cost', 0.0),           # Get 'cost' value or default to 0.0
            entry.get('consumption', 0.0)     # Get 'consumption' value or default to 0.0
        )
        for timestamp, entry in log_message.items()
    ]
    return log_data


@app.route('/log/<table_name>', methods=['POST'])
def receive_log(table_name):
    log_message = request.get_json()
    print(log_message)
    
    # Process log data
    log_data = process_log_data(log_message)

    with sqlite3.connect('logs.db') as conn:
        cursor = conn.cursor()

        # Check if the table exists, create it if not
        create_table(table_name, cursor, log_data)
      
       

        # Execute the query with values from log_data
        # Execute the query with values from log_data
        cursor.executemany(f"INSERT INTO {table_name} (date, cost, consumption) VALUES (?, ?, ?)", log_data)


        conn.commit()

    return 'Log received and saved successfully\n'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
