import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:testuus4/funktsioonid/token.dart';
import 'package:testuus4/main.dart';
import 'package:http/http.dart' as http;

getTarbimine(String seadmeID, String algusPaev, String vahemik) async {
  var headers = {
    'Authorization': 'Bearer ${tokenMap[seadmeID]}',
  };
  DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss");
  DateTime dateTime = format.parse(algusPaev);
  DateTime newDateTime =
      DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59);
  var data = {
    'id': seadmeID,
    'channel': '0',
    'date_range': 'custom',
    'date_from': '$dateTime',
    'date_to': '$newDateTime',
  };

  var url = Uri.parse(
      '${seadmeteMap[seadmeID]["api_url"]}/statistics/relay/consumption');
  var res = await http.post(url, headers: headers, body: data);
  final jsonData = json.decode(res.body);
  final historyData = jsonData['data']['history'] as List<dynamic>;
  List<double> abi = [];
  for (var i = 0; i < historyData.length;) {
    if (historyData[i]['consumption'] == 0) {
      abi.add(0.0);
    } else {
      var abi2 = historyData[i]['consumption'];
      abi.add(abi2.toDouble());
    }

    i++;
  }

  return abi;
}

getTarbimineList(String value, DateTime startDate, DateTime endDate) async {
  var headers = {
    'Authorization': 'Bearer ${tokenMap[value]}',
  };
  List<double> abi = [];
  while (startDate.isBefore(endDate)) {
    String date = DateFormat('yyyy-MM-dd HH:mm:ss').format(startDate);
    String lastDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(
        DateTime(startDate.year, startDate.month, startDate.day, 23, 59, 59));
    var data = {
      'id': value,
      'channel': '0',
      'date_range': 'custom',
      'date_from': '$date',
      'date_to': '$lastDate',
    };

    var url = Uri.parse(
        '${seadmeteMap[value]["api_url"]}/statistics/relay/consumption');
    var res = await http.post(url, headers: headers, body: data);
    final jsonData = json.decode(res.body);
    final historyData = jsonData['data']['history'] as List<dynamic>;

    for (var i = 0; i < historyData.length;) {
      if (historyData[i]['consumption'] == 0) {
        abi.add(0.0);
      } else {
        var abi2 = historyData[i]['consumption'];
        abi.add(abi2.toDouble());
      }

      i++;
    }

    startDate = startDate.add(Duration(days: 1));
  }

  return abi;
}
