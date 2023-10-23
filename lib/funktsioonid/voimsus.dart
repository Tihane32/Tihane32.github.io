import 'dart:convert';
import 'token.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/main.dart';

/// The function `voimus` retrieves data from stored preferences, makes HTTP requests to retrieve device
/// status, calculates power consumption, and returns the total power consumption.
///
/// Returns:
///   the value of the variable "voimsus", which represents the total power consumption calculated in
/// the function.

energia() async {
  var headers = {
    'Authorization': 'Bearer $getToken()',
    //'Content-Type': 'application/x-www-form-urlencoded',
  };

  var data = {
    'id': "4855199d7c38",
    'auth_key':
        "MTcxYTNjdWlk99F3FBAA1664CCBA1DB1A6FE1A156072DB6AF5A8F1B4A1B0ACB7C82002649DADF1114D97483D4E12"
  };

  var url = Uri.parse('https://shelly-64-eu.shelly.cloud/device/status');
  var res = await http.post(url, headers: headers, body: data);

  if (res.statusCode != 200)
    throw Exception('http.post error: statusCode= ${res.statusCode}');
  print(res.body);
  final jsonData = json.decode(res.body);
  print(res.body);
  print(jsonData['data']['device_status']['switch:0']);
}

energia2() async {
  var headers = {
    'Authorization': 'Bearer $getToken2()',
    //'Content-Type': 'application/x-www-form-urlencoded',
  };

  var data = {
    'id': "30c6f7828098",
    'auth_key':
        "MTcxYTNjdWlk99F3FBAA1664CCBA1DB1A6FE1A156072DB6AF5A8F1B4A1B0ACB7C82002649DADF1114D97483D4E12"
  };

  var url = Uri.parse('https://shelly-64-eu.shelly.cloud/device/status');
  var res = await http.post(url, headers: headers, body: data);

  if (res.statusCode != 200)
    throw Exception('http.post error: statusCode= ${res.statusCode}');
  print(res.body);
  final jsonData = json.decode(res.body);
  print("--------------------------");
  print("${jsonData['data']['device_status']['switch:0']["current"]}");
  print("${jsonData['data']['device_status']['switch:0']["apower"]}");
  print("${jsonData['data']['device_status']['switch:0']["voltage"]}");
  print("${jsonData['data']['device_status']['switch:0']["pf"]}");
  print("--------------------------");
}
