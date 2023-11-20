from flask import Flask, request
import sqlite3
from datetime import datetime

app = Flask(__name__)

# Create SQLite database and table if they don't exist
conn = sqlite3.connect('logs.db')
cursor = conn.cursor()
cursor.execute('''
    CREATE TABLE IF NOT EXISTS log_entries (
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
        COST_MONTHLY TEXT,
        DEVICE TEXT,
        UNIQUE (COST_MONTHLY, DEVICE)
    )
''')
conn.commit()
conn.close()

@app.route('/log', methods=['POST'])
def receive_log():
    log_message = request.get_data(as_text=True)
    print(log_message)

    # Parse the log message and extract key-value pairs
    log_pairs = {}
    for pair in log_message.split(';'):
        key, value = pair.split('::')
        log_pairs[key.strip()] = value.strip()

    # Extract values or set defaults if keys are missing

    # Add any missing columns dynamically to the table
    conn = sqlite3.connect('logs.db')
    cursor = conn.cursor()

    # Get the current columns in the table
    cursor.execute("PRAGMA table_info(log_entries)")
    existing_columns = [column[1] for column in cursor.fetchall()]
    print(existing_columns)

    # Add missing columns to the table
    for key in log_pairs.keys():
        if key not in existing_columns:  # Exclude timestamp
            cursor.execute(f"ALTER TABLE log_entries ADD COLUMN {key} TEXT")

    # Check if 'COST_MONTHLY' is in the log message before performing the check
    if 'COST_MONTHLY' in log_pairs:
        # Check if a row with the same 'COST_MONTHLY' value already exists for the given 'DEVICE'
        query_check = """
            SELECT 1 
            FROM log_entries 
            WHERE COST_MONTHLY LIKE ? AND DEVICE = ?
        """
        check_values = (f"%{log_pairs['COST_MONTHLY']}%", log_pairs['DEVICE'])
        existing_row = cursor.execute(query_check, check_values).fetchone()

        # If the row already exists, return without inserting a new row
        if existing_row:
            conn.close()
            return 'Row already exists, not inserting a new row\n'

    # Create the SQL query dynamically based on the keys in log_pairs
    columns = ', '.join(log_pairs.keys())
    placeholders = ', '.join(['?'] * len(log_pairs))
    query = f"INSERT INTO log_entries ({columns}) VALUES ({placeholders})"

    # Execute the query with values from log_pairs
    cursor.execute(query, tuple(log_pairs.values()))
    conn.commit()
    conn.close()

    return 'Log received and saved successfully\n'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
