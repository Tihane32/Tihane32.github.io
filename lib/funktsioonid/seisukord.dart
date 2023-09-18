import 'package:http/http.dart' as http;
import 'token.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


seisukord() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token =
      await getToken(); //Kutsub funktsiooni getTokeni, mis on vajalik sisselogimiseks

  //Kutsub kasutaja
  var headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  var url = Uri.parse('https://shelly-64-eu.shelly.cloud/device/all_status');
  var res = await http.post(url, headers: headers);
  if (res.statusCode != 200)
    throw Exception('http.post error: statusCode= ${res.statusCode}');
  var vastus = json.decode(res.body);
  vastus as Map<String, dynamic>;
  String? storedJsonMap = prefs.getString('seadmed');
  if (storedJsonMap != null) {
    Map<String, dynamic> storedMap = json.decode(storedJsonMap);

    var i = 0;
    for (String Seade in storedMap.keys) {
      var id = storedMap['Seade$i']['Seadme_ID'];

      if (vastus['data']['devices_status']['$id'] == null) {
        storedMap['Seade$i']['Seadme_olek'] = 'Offline';

        await prefs.setString('seadmed', json.encode(storedMap));
      } else {
        if (storedMap['Seade$i']['Seadme_generatsioon'] == 1) {
          var asendus = vastus['data']['devices_status']['$id']['relays'];
          bool ison = asendus[0]["ison"];
          String olek;
          if (ison == false) {
            olek = 'off';
          } else {
            olek = 'on';
          }
          storedMap['Seade$i']['Seadme_olek'] = olek;

          await prefs.setString('seadmed', json.encode(storedMap));
        } else {
          var asendus =
              vastus['data']['devices_status']['$id']['switch:0']['output'];
          String olek;
          if (asendus == false) {
            olek = 'off';
          } else {
            olek = 'on';
          }
          storedMap['Seade$i']['Seadme_olek'] = olek;

          await prefs.setString('seadmed', json.encode(storedMap));
        }
      }

      i++;
    }
  }

}
