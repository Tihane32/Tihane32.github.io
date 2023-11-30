from flask import Flask, jsonify
import sqlite3

app = Flask(__name__)

def get_data_by_month_range(table_name, start_date, end_date):
    try:
        # Extract month and year from start and end dates
        start_month, start_year = start_date.split('-')[1], start_date.split('-')[0]
        end_month, end_year = end_date.split('-')[1], end_date.split('-')[0]

        with sqlite3.connect('cost.db') as conn:
            cursor = conn.cursor()
            cursor.execute('''
                SELECT * FROM {}
                WHERE strftime('%Y-%m', datetime(date, 'unixepoch', 'localtime')) BETWEEN ? AND ?
            '''.format(table_name), (f"{start_year}-{start_month}", f"{end_year}-{end_month}"))
            return cursor.fetchall()

    except Exception as e:
        raise e

@app.route('/data/<table_name>/<month>', methods=['GET'])
def get_data(table_name, month):
    try:
        # Validate input parameters
        # (you may want to add more comprehensive validation)
        print(month)
        
        if not table_name or not start_date or not end_date:
            return jsonify({'error': 'Invalid input parameters'})

        # Execute your SQL query to fetch data from the specified table for the specified date range
        data = get_data_by_month_range(table_name, start_date, end_date)

        # Convert the data to a JSON response
        response_data = {'data': data}

        return jsonify(response_data)

    except Exception as e:
        return jsonify({'error': str(e)})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5500)
