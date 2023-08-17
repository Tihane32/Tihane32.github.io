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
  print(selected);
  print(valitudPaev);
  print(value);
  for (int i = 0; i < 24; i++) {
    ajutine[i][0] = selected[i][0];
  }

  for (int i = 0; i < 24; i++) {
    print(selected[i][0]);
    String temp = selected[i][0];
    temp = temp.replaceAll(".", '');
    selected[i][0] = temp;
    print(selected[i][0]);
  }
  int paev = 0;
  if (valitudPaev == "täna") {
    paev = now.weekday - 1;
    print(paev);
  }

  for (int i = 0; i < 24; i++) {
    print(selected[i][2]);
    bool temp = selected[i][2];
    String temp1;
    if (temp == true) {
      temp1 = 'on';
    } else {
      temp1 = 'off';
    }
    selected[i][2] = temp1;
    print(selected[i][2]);
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
    print(graafik);
  }
  String graafikString = graafik.join(',');
  print(graafikString);
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
  print(graafik);

  print(res1.body);

  for (int i = 0; i < 24; i++) {
    print(selected[i][2]);
    String temp = selected[i][2];
    bool temp1;
    if (temp == 'on') {
      temp1 = true;
    } else {
      temp1 = false;
    }
    selected[i][2] = temp1;
    print(selected[i][2]);
  }
  for (int i = 0; i < 24; i++) {
    print(selected[i][2]);
    String temp = selected[i][0];
    temp = temp.substring(0, 2) + '.' + temp.substring(2);
    selected[i][0] = temp;
  }
  print(lulitus);
  print(selected);
}
