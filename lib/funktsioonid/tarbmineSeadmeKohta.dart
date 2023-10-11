import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:testuus4/funktsioonid/token.dart';
import 'package:testuus4/main.dart';
import 'package:http/http.dart' as http;

getTarbimine(String seadmeID, String algusPaev, String vahemik) async {
  String token = await getToken2();

  var headers = {
    'Authorization': 'Bearer $token',
  };
  print(algusPaev);
  DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss");
  DateTime dateTime = format.parse(algusPaev);
  DateTime newDateTime =
      DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59);
  print(dateTime);
  print(newDateTime);
  var data = {
    'id': seadmeID,
    'channel': '0',
    'date_range': 'custom',
    'date_from': '$dateTime',
    'date_to': '$newDateTime',
  };

  var url = Uri.parse(
      'https://shelly-64-eu.shelly.cloud/statistics/relay/consumption');
  var res = await http.post(url, headers: headers, body: data);
  print(res.body);
  final jsonData = json.decode(res.body);
  final historyData = jsonData['data']['history'] as List<dynamic>;
  print(historyData);
  List<double> abi = [];
  for (var i = 0; i < historyData.length;) {
    print(historyData[i]['consumption']);

    if (historyData[i]['consumption'] == 0) {
      abi.add(0.0);
    } else {
      print(historyData[i]['consumption']);
      var abi2 = historyData[i]['consumption'];
      print(abi2);
      abi.add(abi2.toDouble());
    }

    i++;
  }

  return abi;
}
