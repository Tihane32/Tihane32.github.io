import 'dart:convert';
import 'package:testuus4/main.dart';
import 'token.dart';
import 'package:http/http.dart' as http;

tempMoodis() async {
  var headers = {
    'Authorization': 'Bearer $getToken()',
  };
  anduriteMap.forEach((key, value) async {
    String id = '';
    String key = '';

    id = key;
    key = anduriteMap[key]['Cloud_key'];

    var data = {
      'id': id,
      'auth_key': key,
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
      print('Last Temperature: $lastTemperature');
      anduriteMap[key]['temp'] = lastTemperature.toString();
    } else {
      print('No temperature data available.');
      anduriteMap[key]['temp'] = 'xx';
    }
  });
}
