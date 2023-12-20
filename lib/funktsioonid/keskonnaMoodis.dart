import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:testuus4/parameters.dart';
import 'package:http/http.dart' as http;

keskonnaMoodis() async {
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
      'channel': '0',
      'date_range': 'day',
      'date_from': DateFormat('yyyy-MM-dd').format(DateTime.now()).toString() +
          " 00:00:00",
    };

    var url =
        Uri.parse("${anduriteMap[ID]['api_url']}/statistics/sensor/values");

    var res = await http.post(url, headers: headers, body: data);

    if (res.statusCode != 200)
      throw Exception('http.post error: statusCode= ${res.statusCode}');

    Map<String, dynamic> jsonResponseMap = json.decode(res.body);
    List<dynamic> history = jsonResponseMap['data']['history'];

    if (history.isNotEmpty) {
      double lastTemperature = history.last['max_temperature'];
      lastTemperature = ((lastTemperature * mod).round().toDouble() / mod);
      anduriteMap[key]['temp'] = lastTemperature.toString();
      double lastMoisture = history.last['humidity'];
      lastMoisture = ((lastMoisture * mod).round().toDouble() / mod);
      anduriteMap[key]['niiskus'] = lastMoisture.toString();
    } else {
      anduriteMap[key]['temp'] = 'xx';
      anduriteMap[key]['niiskus'] = 'xx';
    }
  });
}
