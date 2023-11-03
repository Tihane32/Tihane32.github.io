import 'package:http/http.dart' as http;
import 'dart:convert';
import '../main.dart';
import 'token.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<double> tarbimine(tarbimiseMap, Function updateTarbimine) async {
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

  await Future.forEach(storedMap.entries, (entry) async {
    String key = entry.key;
    Map<String, dynamic> value = entry.value;

    String asendus = key.toString();
    String asendus1 = value['Seadme_nimi'].toString();

    var headers = {
      'Authorization': 'Bearer ${tokenMap[asendus]}',
    };
    var data = {
      'id': asendus,
      'channel': '0',
      'date_range': 'custom',
      'date_from': '$firstDayOfMonth',
      'date_to': '$lastDayOfMonth',
    };

    var url = Uri.parse('${value["api_url"]}/statistics/relay/consumption');
    var res = await http.post(url, headers: headers, body: data);
    var resJson = json.decode(res.body) as Map<String, dynamic>;
    if (resJson == null || resJson.toString()=="{isok: false, errors: {device_not_found: Your device has not been connected to the cloud!}}") {
      return 0;
    }
    print(resJson);
    if (resJson['data']['units']['consumption'] == 'Wh') {
      double ajutine = resJson['data']['total'] / 1000.0;
      tarbimine += ajutine;
      tarbimiseMap["$asendus1"] = ajutine;
    } else {
      double ajutine = resJson['data']['total'] * 1.0;
      tarbimine += ajutine;
      tarbimiseMap["$asendus1"] = ajutine;
    }

    await updateTarbimine(tarbimiseMap);
    j++;
  });
  print("lopp $tarbimine");
  return tarbimine;
}
