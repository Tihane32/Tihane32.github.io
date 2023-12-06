import 'package:flutter/material.dart';
import '../funktsioonid/graafikGen2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/main.dart';
import 'package:testuus4/parameters.dart';
/// The function `gen1GraafikLoomine` creates a graph based on the provided data and sends a POST
/// request to update the schedule rules for a device.
///
/// Args:
///   lulitus (Map<int, dynamic>): A map containing the schedule settings for each hour of the day. The
/// keys are integers representing the hour (0-23), and the values are dynamic types.
///   valitudPaev (String): The parameter "valitudPaev" is a String that represents the selected day. It
/// can have two possible values: "täna" (today) or "homme" (tomorrow).
///   value (String): The value parameter is a string that represents the ID of a device.
gen1GraafikLoomine(
    Map<int, dynamic> lulitus, String valitudPaev, String value) async {
  DateTime now = DateTime.now();

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
    if (selected[i][2] != "on" && selected[i][2] != "off") {
      bool temp = selected[i][2];
      String temp1;
      if (temp == true) {
        temp1 = 'on';
      } else {
        temp1 = 'off';
      }
      selected[i][2] = temp1;
    }
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
    'auth_key': seadmeteMap[value]['Cloud_key'],
  };

  var url = Uri.parse('${seadmeteMap[value]['api_url']}/device/settings');
  var res = await http.post(url, headers: headers, body: data);
  await Future.delayed(const Duration(seconds: 2));
  //Kui post läheb läbi siis:
  List<String> newList = [];

  if (res.body.toString() ==
      """{"isok":false,"errors":{"max_req":"Request limit reached!"}}""") {
    await Future.delayed(Duration(seconds: 2));

    res = await http.post(url, headers: headers, body: data);
    //Kui post läheb läbi siis:
  }

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

  graafikGen1Saatmine(graafik, value);
  for (int i = 0; i < 24; i++) {
    if (selected[i][2] != "on" && selected[i][2] != "off") {
      bool temp = selected[i][2];
      String temp1;
      if (temp == true) {
        temp1 = 'on';
      } else {
        temp1 = 'off';
      }
      selected[i][2] = temp1;
    }
  }
  for (int i = 0; i < 24; i++) {
    String temp = selected[i][0];
    temp = '${temp.substring(0, 2)}.${temp.substring(2)}';
    selected[i][0] = temp;
  }
}

graafikGen1Lugemine(String id) async {
  var headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  var data = {
    'channel': '0',
    'id': id,
    'auth_key': seadmeteMap[id]['Cloud_key'],
  };

  var url = Uri.parse('${seadmeteMap[id]['api_url']}/device/settings');

  var res = await http.post(url, headers: headers, body: data);
  //Kui post läheb läbi siis:
  /*if (res.body.toString() ==
      """{"isok":false,"errors":{"max_req":"Request limit reached!"}}""") {
    print("ootab");

    await Future.delayed(Duration(seconds: 2));

    res = await http.post(url, headers: headers, body: data);
    //Kui post läheb läbi siis:
    print("ootas ära");
  }*/

  while (res.body.toString() ==
      """{"isok":false,"errors":{"max_req":"Request limit reached!"}}""") {
    await Future.delayed(Duration(seconds: 2));

    res = await http.post(url, headers: headers, body: data);
    //Kui post läheb läbi siis:
  }

  final httpPackageJson = json.decode(res.body) as Map<String, dynamic>;
  List<dynamic> scheduleRules1 =
      httpPackageJson['data']['device_settings']['relays'][0]['schedule_rules'];

  return scheduleRules1;
}

graafikGen1Saatmine(List<dynamic> graafik, String id) async {
  if (seadmeteMap[id]['Seadme_olek'] != 'Offline') {
    String graafikString = graafik.join(',');
    var headers1 = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    var data1 = {
      'channel': '0',
      'enabled': "1",
      'schedule_rules': graafikString,
      'id': id,
      'auth_key': seadmeteMap[id]['Cloud_key'],
    };

    var url1 = Uri.parse(
        '${seadmeteMap[id]['api_url']}/device/relay/settings/schedule_rules');
    var res1 = await http.post(url1, headers: headers1, body: data1);
  }
  //abi = true;
  mitmeSeadmeKinnitus.add(true);
  seadmeKinnitus = true;
}

graafikGen1Filtreerimine(List<dynamic> graafik, List<int> paevad) {
  List<String> newList = [];
  List<String> newGraafik = [];
  for (String item in graafik) {
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

  for (int i = 0; i < paevad.length; i++) {
    RegExp regExp = RegExp("-${paevad[i]}-");
    for (var rule in newList) {
      if (regExp.hasMatch(rule)) {
        newGraafik.add(rule);
      }
    }
  }
  return newGraafik;
}

graafikGen1Koostamine(Map<int, dynamic> lulitus, int paev) {
  for (int i = 0; i < 24; i++) {
    String temp = lulitus[i][0];
    temp = temp.replaceAll(".", '');
    lulitus[i][0] = temp;
  }
  for (int i = 0; i < 24; i++) {
    if (lulitus[i][2] != "on" && lulitus[i][2] != "off") {
      bool temp = lulitus[i][2];

      String temp1;
      if (temp == true) {
        temp1 = 'on';
      } else {
        temp1 = 'off';
      }
      lulitus[i][2] = temp1;
    }
  }
  List<String> graafik = [];
  for (int i = 0; i < 24; i++) {
    if (i != 0) {
      if (lulitus[i][2] != lulitus[i - 1][2]) {
        String temp = lulitus[i][0] + '-$paev-' + lulitus[i][2];
        graafik.add(temp);
      }
    } else {
      String temp = lulitus[i][0] + '-$paev-' + lulitus[i][2];
      graafik.add(temp);
    }
  }
  return graafik;
}

graafikGen1ToLulitusMap(Map<int, dynamic> lulitus, List<dynamic> graafik) {
  Map<int, dynamic> lulitusUus = lulitus;
  for (int i = 0; i < 24; i++) {
    String asendus = '$i';
    if (i < 10) {
      asendus = '0${asendus}00';
    } else {
      asendus = '${asendus}00';
    }
    for (int j = 0; j < graafik.length; j++) {
      List<String> parts = graafik[j].split('-');
      String timeString = parts[0];
      if (timeString == asendus) {
        if (parts[2] == 'on') {
          lulitusUus[i][2] = true;
        } else {
          lulitusUus[i][2] = false;
        }
        break;
      } else {
        if (i != 0) {
          lulitusUus[i][2] = lulitusUus[i - 1][2];
        }
      }
    }
  }
  return lulitusUus;
}
