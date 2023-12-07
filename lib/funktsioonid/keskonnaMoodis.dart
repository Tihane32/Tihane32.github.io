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
      'date_range': 'day',
      'date_from': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    };

    var url = anduriteMap[key]['Seadme_generatsioon'] == 2 //'Gen 1'
        ? Uri.parse(
            "https://shelly-77-eu.shelly.cloud/statistics/sensor/values")
        : Uri.parse(
            "https://shelly-79-eu.shelly.cloud/statistics/sensor/values");

    var res = await http.post(url, headers: headers, body: data);

    print(
        'Tprint ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()).toString()}');
    print('Tprint ${res.body}');

    if (res.statusCode != 200)
      throw Exception('http.post error: statusCode= ${res.statusCode}');

    Map<String, dynamic> jsonResponseMap = json.decode(res.body);
    List<dynamic> history = jsonResponseMap['data']['history'];

    print(
        'Tprint Gen ${anduriteMap[key]['Seadme_generatsioon']} = ; History = $history');

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
