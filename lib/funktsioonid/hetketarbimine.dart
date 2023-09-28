import 'dart:convert';
import 'token.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future voimus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  []; //Võtab mälust 'users'-i asukohast väärtused
  var seadmedJSONmap = prefs.getString('seadmed');
  //print(seadmedJSONmap);
  if (seadmedJSONmap == null) {
    return 0;
  }
  var storedMap = json.decode(seadmedJSONmap);

  String? storedKey = prefs.getString('key');

  String storedKeyString = jsonDecode(storedKey!);

  var authKey = storedKeyString;
  var i = 0;

  var j = 0;
  double voimsus = 0;
  print(storedMap);
  storedMap.forEach((key, value) async {
    {
      //print(storedMap['Seade$j']['Seadme_ID']);
      String asendus = key as String;
      var headers = {
        'Authorization': 'Bearer $getToken',
      };
      var data = {'id': asendus, 'auth_key': authKey};

      var url = Uri.parse('${value['api_url']}/device/status');
      var res = await http.post(url, headers: headers, body: data);
      //print(res.body);
      var resJson = json.decode(res.body) as Map<String, dynamic>;
      //print(resJson);
      if (value['Seadme_generatsioon'] as int == 1) {
        voimsus =
            voimsus + resJson['data']['device_status']['meters'][0]['power'];
      } else {
        voimsus =
            voimsus + resJson['data']['device_status']['switch:0']['apower'];
      }

      //print(resJson['data']['device_status']['switch:0']['voltage']);
      //print(resJson['data']['device_status']['switch:0']['current']);
      //print(resJson['data']['device_status']['switch:0']['pf']);
      //print(resJson['data']['device_status']['switch:0']['aenergy']);
      //await energia();
      j++;
    }
  });
  print(voimsus);
  print("korras");
  return voimsus;
}

/*energia() async {
  var headers = {
    'Authorization': 'Bearer $getToken()',
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
}*/
