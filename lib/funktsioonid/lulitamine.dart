/*
Trevor Uuna, Jaakob Lambot 27.03.2023
TalTech
*/
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void lulitamine(String seade) async {
  print('lülitus $seade');
  //Kõikide Shellyde on/off lülitamine

  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? storedJsonMap = prefs.getString('seadmed');

  Map<String, dynamic> storedMap = json.decode(storedJsonMap!);

  prefs = await SharedPreferences.getInstance();

  var j = 0;
  for (var i in storedMap.values) {
    if (storedMap['Seade$j']['Seadme_ID'] == seade) {
      var id = storedMap['Seade$j']['Seadme_ID'];
      var olek = storedMap['Seade$j']['Seadme_olek'];
      print('olek: $olek');
      if (olek == 'on') {
        olek = 'off';
      } else {
        olek = 'on';
      }
      storedMap['Seade$j']['Seadme_olek'] = olek;
      print(storedMap['Seade$j']);
      print('uus olek: $olek');
      await prefs.setString('seadmed', json.encode(storedMap));
      print(storedMap);
      String? storedKey = prefs.getString('key');

      String storedKeyString = jsonDecode(storedKey!);
      print(storedKeyString);

      var headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      var data = {
        'channel': '0',
        'turn': olek,
        'id': id,
        'auth_key': storedKeyString,
      };

      var url =
          Uri.parse('https://shelly-64-eu.shelly.cloud/device/relay/control');
      var res = await http.post(url, headers: headers, body: data);
      print(res.body);
      print(storedKeyString);
    }

    j++;
  }
}
