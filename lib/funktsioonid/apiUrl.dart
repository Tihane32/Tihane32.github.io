import 'package:flutter/material.dart';
import '../funktsioonid/graafikGen2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

//Saab seadme ID abil kätte seadme api_url-i
//Võtab mälust seadmele määratud api_url-i
getApiUrl(String ID) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? storedJsonMap = prefs.getString('seadmed');

  Map<String, dynamic> storedMap = json.decode(storedJsonMap!);

  prefs = await SharedPreferences.getInstance();
  String apiUrl = "";
  var j;
  for (var i in storedMap.values) {
    if (storedMap['Seade$j']['Seadme_ID'] == ID) {
      
    }
    j++;
  }
}
