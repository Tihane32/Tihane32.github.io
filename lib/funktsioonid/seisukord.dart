import 'package:http/http.dart' as http;
import 'package:testuus4/main.dart';
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
 
    Map<String, dynamic> storedMap = seadmeteMap;

    
    storedMap.forEach((key, value) async {
      var id = key;

      if (vastus['data']['devices_status']['$id'] == null) {
        value['Seadme_olek'] = 'Offline';

        await prefs.setString('seadmed', json.encode(storedMap));
      } else {
        if (value['Seadme_generatsioon'] == 1) {
          var asendus = vastus['data']['devices_status']['$id']['relays'];
          bool ison = asendus[0]["ison"];
          String olek;
          if (ison == false) {
            olek = 'off';
          } else {
            olek = 'on';
          }
          value['Seadme_olek'] = olek;

          await prefs.setString('seadmed', json.encode(storedMap));
          seadmeteMap = storedMap;
        } else {
          var asendus =
              vastus['data']['devices_status']['$id']['switch:0']['output'];
          String olek;
          if (asendus == false) {
            olek = 'off';
          } else {
            olek = 'on';
          }
          value['Seadme_olek'] = olek;

          await prefs.setString('seadmed', json.encode(storedMap));
          seadmeteMap = storedMap;
        }
      }

      
    });
  
  print('seisukordmap: $seadmeteMap');
}
