import 'dart:convert';
import 'dart:math';
import 'package:testuus4/main.dart';
import 'token.dart';
import 'package:http/http.dart' as http;

tempMoodis() async {
  num mod = pow(10.0, 1);
  anduriteMap.forEach((key, value) async {
    String ID = '';
    String KEY = '';

    ID = key;
    KEY = anduriteMap[key]['Cloud_key'];

    var headers = {
      'Authorization': 'Bearer ${tokenMap[key]}',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    var data = {
      'id': ID,
      'auth_key': KEY,
    };

    var url =
        Uri.parse('https://shelly-79-eu.shelly.cloud/statistics/sensor/values');
    var res = await http.post(url, headers: headers, body: data);

    if (res.statusCode != 200)
      throw Exception('http.post error: statusCode= ${res.statusCode}');

    Map<String, dynamic> jsonResponseMap = json.decode(res.body);
    List<dynamic> history = jsonResponseMap['data']['history'];

    if (history.isNotEmpty) {
      double lastTemperature = history.last['max_temperature'];
      lastTemperature = ((lastTemperature * mod).round().toDouble() / mod);
      anduriteMap[key]['temp'] = lastTemperature.toString();
    } else {
      anduriteMap[key]['temp'] = 'xx';
    }
  });
}
