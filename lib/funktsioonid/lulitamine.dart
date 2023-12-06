/*
Trevor Uuna, Jaakob Lambot 27.03.2023
TalTech
*/
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:testuus4/main.dart';
import 'package:testuus4/parameters.dart';
/// The function `lulitamine` toggles the on/off state of all Shelly devices based on the provided
/// `seade` parameter.
///
/// Args:
///   seade (String): The parameter "seade" is a String that represents the device identifier.
void lulitamine(String seade) async {
  //Kõikide Shellyde on/off lülitamine

  SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs = await SharedPreferences.getInstance();

  var j = 0;

  /// The code block `seadmeteMap.forEach((key, value) async { ... })` is iterating over each key-value
  /// pair in the `seadmeteMap` map.
  seadmeteMap.forEach((key, value) async {
    print("selline");
    print(seadmeteMap[key]);

    if (key == seade) {
      var id = key;
      var olek = value['Seadme_olek'];
      print(value['Seadme_olek']);
      if (olek == 'on') {
        olek = 'off';
      } else {
        olek = 'on';
      }
      value['Seadme_olek'] = olek;

      

      
      var res;
      do {
        var headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
        };

        var data = {
          'channel': '0',
          'turn': olek,
          'id': id,
          'auth_key': value["Cloud_key"],
        };
        print(data);
        print(value["api_url"]);
        var url = Uri.parse('${value["api_url"]}/device/relay/control');
        res = await http.post(url, headers: headers, body: data);
        print(res.body);
        if(res.body.toString() ==
          """{"isok":false,"errors":{"max_req":"Request limit reached!"}}"""){
          await Future.delayed(Duration(seconds: 2));
        }
      } while (res.body.toString() ==
          """{"isok":false,"errors":{"max_req":"Request limit reached!"}}""");

      print("switch $olek");
      print(res.body);
      String seadmedMap = json.encode(seadmeteMap);
      await prefs.setString('seadmed', seadmedMap);
    }

    j++;
  });
}
