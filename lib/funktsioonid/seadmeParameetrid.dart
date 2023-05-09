import 'dart:convert';
import 'token.dart';
import 'package:http/http.dart' as http;

void main() async {
  var headers = {
    'Authorization':
        'Bearer $getToken()',
  };
  var data = {
    'id': '80646f81ad9a',
    'auth_key':
        'MTcxYTNjdWlk99F3FBAA1664CCBA1DB1A6FE1A156072DB6AF5A8F1B4A1B0ACB7C82002649DADF1114D97483D4E12'
  };

  var url = Uri.parse('https://shelly-64-eu.shelly.cloud/device/status');
  var res = await http.post(url, headers: headers, body: data);
  //print(res.body);
  var resJson = json.decode(res.body) as Map<String, dynamic>;
  print(resJson);
  print(resJson['data']['device_status']['meters'][0]['power']);
  //print(resJson['data']['device_status']['switch:0']['apower']);
  //print(resJson['data']['device_status']['switch:0']['voltage']);
  //print(resJson['data']['device_status']['switch:0']['current']);
  //print(resJson['data']['device_status']['switch:0']['pf']);
  //print(resJson['data']['device_status']['switch:0']['aenergy']);
  //await energia();
}

energia() async {
  var headers = {
    'Authorization':
        'Bearer $getToken()',
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
