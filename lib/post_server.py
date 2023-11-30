from flask import Flask, jsonify
import sqlite3

app = Flask(__name__)

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

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5500)
