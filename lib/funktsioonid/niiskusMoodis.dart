import 'dart:convert';
import 'dart:math';
import 'package:testuus4/main.dart';
import 'token.dart';
import 'package:http/http.dart' as http;

niiskusMoodis() async {
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

    print('Tprint: data $data');

    var url =
        Uri.parse('https://shelly-79-eu.shelly.cloud/statistics/sensor/values');
    var res = await http.post(url, headers: headers, body: data);
    print('Tprint: res: $res');

    if (res.statusCode != 200)
      throw Exception('http.post error: statusCode= ${res.statusCode}');

    Map<String, dynamic> jsonResponseMap = json.decode(res.body);
    List<dynamic> history = jsonResponseMap['data']['history'];

    if (history.isNotEmpty) {
      double lastMoisture = history.last['humidity'];
      anduriteMap[key]['niiskus'] = lastMoisture.toString();
    } else {
      anduriteMap[key]['niiskus'] = 'xx';
    }
  });
}
