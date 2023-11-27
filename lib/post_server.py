from flask import Flask, jsonify, request
import sqlite3

app = Flask(__name__)

# Your existing code for creating the SQLite database table

@app.route('/data/<table_name>', methods=['GET'])
def get_data(table_name):
    try:
        conn = sqlite3.connect('data.db')
        cursor = conn.cursor()

        # Execute your SQL query to fetch data from the specified table
        query = f"SELECT * FROM {table_name}"
        cursor.execute(query)
        data = cursor.fetchall()

        # Convert the data to a JSON response
        response_data = {'data': data}

        conn.close()

        return jsonify(response_data)

    except Exception as e:
        return str(e)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5500)
