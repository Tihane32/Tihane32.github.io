import json
from flask import Flask, request
from flask_cors import CORS  # Import the CORS extension
import sqlite3
app = Flask(__name__)
CORS(app)
def create_table(table_name, cursor, log_pairs):
    # Create table if it doesn't exist
    cursor.execute(f''' 
        CREATE TABLE IF NOT EXISTS "{table_name}" (
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
            date INT UNIQUE,
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

@app.route('/log/cost_daily/<table_name>', methods=['POST'])
def receive_log(table_name):
    log_message = request.get_json()
    print(log_message)
    
    # Process log data
    log_data = process_log_data(log_message)

    with sqlite3.connect('cost.db') as conn:
        cursor = conn.cursor()

        # Check if the table exists, create it if not
        create_table(table_name, cursor, log_data)

        # Iterate through log_data and insert only if date does not exist
        for entry in log_data:
            date_value = entry[0]
            
            # Check if the date already exists in the table
            cursor.execute(f"SELECT COUNT(*) FROM {table_name} WHERE date = ?", (date_value,))
            count = cursor.fetchone()[0]

            # If the date does not exist, insert the record
            if count == 0:
                cursor.execute(f"INSERT INTO {table_name} (date, cost, consumption) VALUES (?, ?, ?)", entry)

        conn.commit()

    return 'Log received and saved successfully\n'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
