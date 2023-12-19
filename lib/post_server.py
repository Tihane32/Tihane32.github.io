import sqlite3
from flask import Flask, jsonify
from flask_cors import CORS  # Import CORS from flask_cors
from flask_cors import cross_origin
from flask import Flask, request
app = Flask(__name__)
CORS(app) 

def get_data_by_month(table_name, month):
    with sqlite3.connect('cost.db') as conn:
        cursor = conn.cursor()
        # Assuming date is stored as a UNIX timestamp in the 'date' column
        query = f"SELECT * FROM {table_name} WHERE strftime('%m', datetime(date/1000, 'unixepoch', 'localtime')) = ?"
        print("SQL Query:", query)  # Add this line to print the SQL query
        cursor.execute(query, (month,))
        result = cursor.fetchall()
        print("Fetched Data:", result)  # Add this line to print the fetched data
        return result



@app.route('/data/<table_name>/<month>', methods=['GET'])
@cross_origin(origin='http://172.22.22.222:8000', headers=['Content-Type', 'Authorization'])
def get_data(table_name, month):
    try:
        # Validate input parameters
        # (you may want to add more comprehensive validation)
        print(month)
        
        
        # Execute your SQL query to fetch data from the specified table for the specified date range
        data = get_data_by_month(table_name, month)
        print(data)
        # Convert the data to a JSON response
        response_data = {'data': data}

        return jsonify(response_data)

    except Exception as e:
        return jsonify({'error': str(e)})




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

def create_table2(table_name, cursor):
    # Create table if it doesn't exist
    cursor.execute(f''' 
        CREATE TABLE IF NOT EXISTS "{table_name}" (
            soovitud_tunnid INT
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


@app.route('/log/automatic/<table_name>', methods=['POST'])
def receive_log2(table_name):
    log_message = request.get_json()
    print(log_message)
    print(table_name)

    with sqlite3.connect('automatic.db') as conn:
        cursor = conn.cursor()

        # Check if the table exists, create it if not
        create_table2(table_name, cursor)

        cursor.execute(f"SELECT COUNT(*) FROM {table_name} WHERE soovitud_tunnid IS NOT NULL")
        count_result = cursor.fetchone()

        if count_result and count_result[0] > 0:
            # Update the soovitud_tunnid column
            cursor.execute(f"UPDATE {table_name} SET soovitud_tunnid = ?", (log_message,))
        else:
            cursor.execute(f"INSERT INTO {table_name} (soovitud_tunnid) VALUES ({log_message})")
        conn.commit()

    return 'Log received and saved successfully\n'


if __name__ == '__main__':
    
    app.run(host='0.0.0.0', port=5500)