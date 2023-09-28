import 'package:http/http.dart' as http;
import 'dart:convert';
import 'token.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future tarbimine(tarbimiseMap, Function updateTarbimine) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  []; //Võtab mälust 'users'-i asukohast väärtused
  var seadmedJSONmap = prefs.getString('seadmed');
  //print(seadmedJSONmap);
  if (seadmedJSONmap == null) {
    return 0;
  }
  Map<String, dynamic> storedMap = json.decode(seadmedJSONmap);
  DateTime currentDateTime = DateTime.now();

  // Calculate the first day of the current month
  DateTime firstDayOfMonth =
      DateTime(currentDateTime.year, currentDateTime.month);

  // Calculate the last day of the current month
  DateTime lastDayOfMonth =
      DateTime(currentDateTime.year, currentDateTime.month + 1, 0);
  var j = 0;
  var tarbimine = 0.0;
  String token = await getToken();
  storedMap.forEach((key, value) async {
    //await Future.delayed(const Duration(seconds: 3));
    //print(storedMap['Seade$j']['Seadme_ID']);
    String asendus = key.toString();
      String asendus1 = value['Seadme_nimi'].toString();
    //print(token);
    var headers = {
      'Authorization': 'Bearer $token',
    };
    var data = {
      'id': asendus,
      'channel': '0',
      'date_range': 'custom',
      'date_from': '$firstDayOfMonth',
      'date_to': '$lastDayOfMonth',
    };

    var url = Uri.parse(
        '${value["api_url"]}/statistics/relay/consumption');
    var res = await http.post(url, headers: headers, body: data);
    //print(res.body);
    var resJson = json.decode(res.body) as Map<String, dynamic>;

    if (resJson['data']['units']['consumption'] == 'Wh') {
      double ajutine = resJson['data']['total'] / 1000.0;
      tarbimine = tarbimine + ajutine;
      tarbimiseMap["$asendus1"] = ajutine;
    } else {
      double ajutine = resJson['data']['total'] * 1.0;
      tarbimine = tarbimine + ajutine;
      tarbimiseMap["$asendus1"] = ajutine;
    }

    //print(resJson);

    //print(resJson['data']['device_status']['switch:0']['voltage']);
    //print(resJson['data']['device_status']['switch:0']['current']);
    //print(resJson['data']['device_status']['switch:0']['pf']);
    //print(resJson['data']['device_status']['switch:0']['aenergy']);
    //await energia();
    j++;
  });
  updateTarbimine(tarbimiseMap);

  return tarbimine;
}
