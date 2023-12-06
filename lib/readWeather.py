import requests

url = "https://www.yr.no/api/v0/locations/2-588409/forecast"

headers = {
    "Accept": "*/*",
    "Accept-Language": "et,et-EE;q=0.8,en-US;q=0.5,en;q=0.3",
    "Accept-Encoding": "gzip, deflate, br",
    "Referer": "https://www.yr.no/nb/v^%^C3^%^A6rvarsel/timetabell/2-588409/Estland/Harju/Tallinna^%^20linn/Tallinn?i=0",
   
}

response = requests.get(url, headers=headers)

if response.status_code == 200:
    data = response.json()
    short_intervals = data['shortIntervals']

    for interval in short_intervals:
        start_time = interval['start']
        temperature = interval['temperature']['value']
        print(f"Start Time: {start_time}, Temperature: {temperature}°C")
else:
    print(f"Request failed with status code {response.status_code}")
    try:
        print(response.json())
    except Exception as e:
        print(f"Failed to parse error response: {e}")
