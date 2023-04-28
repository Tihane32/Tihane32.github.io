import 'dart:convert';

import 'package:http/http.dart' as http;

void main() async {
  var headers = {
    'Authorization':
        'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJwd2QiLCJpYXQiOjE2ODI1Mjk3NDcsInVzZXJfaWQiOiIxNTE0MDQ0Iiwic24iOiIxIiwidXNlcl9hcGlfdXJsIjoiaHR0cHM6XC9cL3NoZWxseS02NC1ldS5zaGVsbHkuY2xvdWQiLCJuIjo4NzQ5LCJleHAiOjE2ODI2MTYxNDd9.SV0T6T8CgTfJJ40qBgCtyRJ1owqgxTfkPXUgW-uooDQ',
  };
  var data = {
    'id': '30c6f7828098',
    'auth_key':
        'MTcxYTNjdWlk99F3FBAA1664CCBA1DB1A6FE1A156072DB6AF5A8F1B4A1B0ACB7C82002649DADF1114D97483D4E12'
  };

  var url = Uri.parse('https://shelly-64-eu.shelly.cloud/device/status');
  var res = await http.post(url, headers: headers, body: data);
  //print(res.body);
  var resJson = json.decode(res.body) as Map<String, dynamic>;
  //print(resJson);
  print(resJson['data']['device_status']['switch:0']['apower']);
  print(resJson['data']['device_status']['switch:0']['voltage']);
  print(resJson['data']['device_status']['switch:0']['current']);
  print(resJson['data']['device_status']['switch:0']['pf']);
  print(resJson['data']['device_status']['switch:0']['aenergy']);
  await energia();
}

energia() async {
  var headers = {
    'Authorization':
        'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJwd2QiLCJpYXQiOjE2ODI3MTI3ODIsInVzZXJfaWQiOiIxNTE0MDQ0Iiwic24iOiIxIiwidXNlcl9hcGlfdXJsIjoiaHR0cHM6XC9cL3NoZWxseS02NC1ldS5zaGVsbHkuY2xvdWQiLCJuIjo0ODkxLCJleHAiOjE2ODI3OTkxODJ9.bYPlbAuHARSarJ6J_8l8PLzJG463YePltVS5jxKR-QI',
    //'Content-Type': 'application/x-www-form-urlencoded',
  };
  print('siin');
  var data = {
    'id': '30c6f7828098',
    'channel': '0',
    'date_range': 'custom',
    'date_from': '2023-04-01 00:00:00',
    'date_to': '2023-04-30 23:59:59',
  };

  var url = Uri.parse(
      'https://shelly-64-eu.shelly.cloud/statistics/relay/consumption');
  var res = await http.post(url, headers: headers, body: data);
  if (res.statusCode != 200)
    throw Exception('http.post error: statusCode= ${res.statusCode}');
  print(res.body);
  final jsonData = json.decode(res.body);
  final historyData = jsonData['data']['history'] as List<dynamic>;
  print(historyData);
}
