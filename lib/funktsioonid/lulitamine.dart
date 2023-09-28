/*
Trevor Uuna, Jaakob Lambot 27.03.2023
TalTech
*/
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void lulitamine(String seade) async {
  //Kõikide Shellyde on/off lülitamine

  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? storedJsonMap = prefs.getString('seadmed');

  Map<String, dynamic> storedMap = json.decode(storedJsonMap!);

  prefs = await SharedPreferences.getInstance();

  var j = 0;
  storedMap.forEach((key, value) async {
    if (key == seade) {
      var id = key;
      var olek = value['Seadme_olek'];
      if (olek == 'on') {
        olek = 'off';
      } else {
        olek = 'on';
      }
      value['Seadme_olek'] = olek;
      await prefs.setString('seadmed', json.encode(storedMap));
      String? storedKey = prefs.getString('key');

      String storedKeyString = jsonDecode(storedKey!);

      var headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      var data = {
        'channel': '0',
        'turn': olek,
        'id': id,
        'auth_key': storedKeyString,
      };
      print(value["api_url"]);
      var url = Uri.parse('${value["api_url"]}/device/relay/control');
      var res = await http.post(url, headers: headers, body: data);
    }

    j++;
  });
}
