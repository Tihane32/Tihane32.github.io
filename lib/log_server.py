from flask import Flask, request
import sqlite3
from datetime import datetime

app = Flask(__name__)

# Create SQLite database and table if they don't exist
conn = sqlite3.connect('logs.db')
cursor = conn.cursor()
cursor.execute('''
    CREATE TABLE IF NOT EXISTS log_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        log_message TEXT,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
    )
''')
conn.commit()
conn.close()

@app.route('/log', methods=['POST'])
def receive_log():
    log_message = request.get_data(as_text=True)
    print(log_message)

    # Save log to the SQLite database
    conn = sqlite3.connect('logs.db')
    cursor = conn.cursor()
    cursor.execute('''
        INSERT INTO log_entries (log_message) VALUES (?)
    ''', (log_message,))
    conn.commit()
    conn.close()

    return 'Log received and saved successfully\n'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)