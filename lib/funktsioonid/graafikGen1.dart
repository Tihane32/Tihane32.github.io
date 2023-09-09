import 'package:flutter/material.dart';
import '../funktsioonid/graafikGen2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

gen1GraafikLoomine(
    Map<int, dynamic> lulitus, String valitudPaev, String value) async {
  DateTime now = DateTime.now();
  int tundtana = now.hour;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? storedKey = prefs.getString('key');
  String storedKeyString = jsonDecode(storedKey!);
  Map<int, dynamic> selected = lulitus;
  Map<int, dynamic> ajutine = selected;
  for (int i = 0; i < 24; i++) {
    ajutine[i][0] = selected[i][0];
  }

  for (int i = 0; i < 24; i++) {
    String temp = selected[i][0];
    temp = temp.replaceAll(".", '');
    selected[i][0] = temp;
  }
  int paev = 0;
  int teinePaev = 0;
  if (valitudPaev == "täna") {
    paev = now.weekday - 1;
    if (now.weekday == 7) {
      teinePaev = 0;
    } else {
      teinePaev = now.weekday;
    }
  } else {
    if (now.weekday == 7) {
      paev = 0;
    } else {
      paev = now.weekday;
    }
    teinePaev = now.weekday - 1;
  }

  for (int i = 0; i < 24; i++) {
    bool temp = selected[i][2];
    String temp1;
    if (temp == true) {
      temp1 = 'on';
    } else {
      temp1 = 'off';
    }
    selected[i][2] = temp1;
  }
  List<String> graafik = [];
  for (int i = 0; i < 24; i++) {
    if (i != 0) {
      if (selected[i][2] != selected[i - 1][2]) {
        String temp = selected[i][0] + '-$paev-' + selected[i][2];
        graafik.add(temp);
      }
    } else {
      String temp = selected[i][0] + '-$paev-' + selected[i][2];
      graafik.add(temp);
    }
  }

  var headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  var data = {
    'channel': '0',
    'id': value,
    'auth_key': storedKeyString,
  };

  var url = Uri.parse('https://shelly-64-eu.shelly.cloud/device/settings');
  var res = await http.post(url, headers: headers, body: data);
  await Future.delayed(const Duration(seconds: 2));
  //Kui post läheb läbi siis:
  List<String> newList = [];
  final httpPackageJson = json.decode(res.body) as Map<String, dynamic>;

  var scheduleRules1 =
      httpPackageJson['data']['device_settings']['relays'][0]['schedule_rules'];
  for (String item in scheduleRules1) {
    List<String> parts = item.split('-');
    if (parts[1].length > 1) {
      for (int i = 0; i < parts[1].length; i++) {
        //lülituskäsk tehakse iga "-" juures pooleks ja lisatakse eraldi listi
        String newItem = '${parts[0]}-${parts[1][i]}-${parts[2]}';
        newList.add(newItem);
      }
    } else {
      newList.add(item);
    }
  }

  RegExp regExp = RegExp("-$teinePaev-");

  for (var rule in newList) {
    if (regExp.hasMatch(rule)) {
      graafik.add(rule);
    }
  }
  String graafikString = graafik.join(',');
  var headers1 = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  var data1 = {
    'channel': '0',
    'enabled': "1",
    'schedule_rules': graafikString,
    'id': value,
    'auth_key': storedKeyString,
  };

  var url1 = Uri.parse(
      'https://shelly-64-eu.shelly.cloud/device/relay/settings/schedule_rules');
  var res1 = await http.post(url1, headers: headers1, body: data1);
  print(res1.body);
  for (int i = 0; i < 24; i++) {
    String temp = selected[i][2];
    bool temp1;
    if (temp == 'on') {
      temp1 = true;
    } else {
      temp1 = false;
    }
    selected[i][2] = temp1;
  }
  for (int i = 0; i < 24; i++) {
    String temp = selected[i][0];
    temp = temp.substring(0, 2) + '.' + temp.substring(2);
    selected[i][0] = temp;
  }
}
