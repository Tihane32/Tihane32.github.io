import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/funktsioonid/graafikGen2.dart';
import 'package:testuus4/lehed/energiaGraafik.dart';
import 'dart:convert';
import 'token.dart';
import 'package:testuus4/lehed/kaksTabelit.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:testuus4/funktsioonid/Elering.dart';
import 'package:intl/intl.dart';

Future maksumus(String vahemik) async {
  if (vahemik == 'Kuu') {
    DateTime now = DateTime.now();
    DateTime startOfMonth = DateTime(now.year, now.month, 1);
    DateTime endOfMonth = now;

    List<DateTime> monthDates = [];
    DateTime date = startOfMonth;

    while (date.isBefore(endOfMonth) || date.isAtSameMomentAs(endOfMonth)) {
      monthDates.add(date);
      date = date.add(Duration(days: 1));
    }

    // Formatting the dates
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    List<String> formattedDates =
        monthDates.map((date) => formatter.format(date)).toList();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = await getToken();
    double katse = 0;
    double hind = 0;
    var k = 0;
    var seadmedJSONmap = prefs.getString('seadmed');
    //print(seadmedJSONmap);
    if (seadmedJSONmap == null) {
      return 0;
    }
    Map<String, dynamic> storedMap = json.decode(seadmedJSONmap);

    var i = 0;

    var u = 0;

    for (var i in storedMap.values) {
      String asendus = storedMap['Seade$u']['Seadme_ID'] as String;
      k = 0;
      for (var j = 1; j <= formattedDates.length; j++) {
        String test = formattedDates[k];
        String customDateString = formattedDates[k]; // Your custom date string

        DateTime customDate = DateTime.parse(customDateString);
        DateTime yesterday = customDate.subtract(Duration(days: 1));

        DateFormat formatter = DateFormat('yyyy-MM-dd');
        String formattedDate = formatter.format(yesterday);
        k++;

        var headers = {
          'Authorization': 'Bearer $token',
        };
        var data = {
          'id': asendus,
          'channel': '0',
          'date_range': 'custom',
          'date_from': '$test 00:00:00',
          'date_to': '$test 23:59:59',
        };

        var url = Uri.parse(
            'https://shelly-64-eu.shelly.cloud/statistics/relay/consumption');
        var res = await http.post(url, headers: headers, body: data);
        formattedDate = formattedDate + 'T20';
        test = test + 'T20';
        if (res.statusCode != 200)
          throw Exception('http.post error: statusCode= ${res.statusCode}');
        final jsonData = json.decode(res.body);
        var resJson = json.decode(res.body) as Map<String, dynamic>;
        //print(res.body);
        final historyData = jsonData['data']['history'] as List<dynamic>;
        var url1 = Uri.parse(
            'https://dashboard.elering.ee/api/nps/price?start=$formattedDate%3A59%3A59.999Z&end=$test%3A59%3A59.999Z');
        print(url1);
        var res1 = await http.get(url1);
        if (res1.statusCode != 200)
          throw Exception('http.get error: statusCode= ${res1.statusCode}');
        //print(res1.body);
        final httpPackageJson = json.decode(res1.body) as Map<String, dynamic>;
        var entryList;
        entryList = httpPackageJson.entries.toList();

        //Võtab Listist Eesti hinnagraafiku
        var ajutine = entryList[1].value;
        var ajutine2 = ajutine.entries.toList();
        var hinnagraafik = ajutine2[0].value;

        for (var i = 0; i < 24; i++) {
          //print(resJson['data']['units']['consumption']);
          var ajutineTarb;
          if (resJson['data']['units']['consumption'] == 'Wh') {
            ajutineTarb = historyData[i]['consumption'] / 1000000;
          } else {
            ajutineTarb = historyData[i]['consumption'] / 1000000;
          }
          katse = katse + ajutineTarb;
          // print(historyData);

          hind = hind + (ajutineTarb * hinnagraafik[i]['price']);
        }
      }
      u++;
    }
    num n = num.parse(hind.toStringAsFixed(5));
    hind = n as double;
    return hind;
  }
  if (vahemik == 'Nädala') {
    DateTime now = DateTime.now();
    DateTime startOfWeek =
        DateTime(now.year, now.month, now.day - now.weekday + 1);
    DateTime endOfWeek = now;

    List<DateTime> weekDates = [];
    DateTime date = startOfWeek;

    while (date.isBefore(endOfWeek) || date.isAtSameMomentAs(endOfWeek)) {
      weekDates.add(date);
      date = date.add(Duration(days: 1));
    }

// Formatting the dates
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    List<String> formattedDates =
        weekDates.map((date) => formatter.format(date)).toList();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = await getToken();
    double katse = 0;
    double hind = 0;
    var k = 0;
    var seadmedJSONmap = prefs.getString('seadmed');
//print(seadmedJSONmap);
    if (seadmedJSONmap == null) {
      return 0;
    }
    Map<String, dynamic> storedMap = json.decode(seadmedJSONmap);

    var i = 0;

    var u = 0;

    for (var i in storedMap.values) {
      String asendus = storedMap['Seade$u']['Seadme_ID'] as String;
      k = 0;
      for (var j = 1; j <= formattedDates.length; j++) {
        String test = formattedDates[k];
        String customDateString = formattedDates[k]; // Your custom date string

        DateTime customDate = DateTime.parse(customDateString);
        DateTime yesterday = customDate.subtract(Duration(days: 1));

        DateFormat formatter = DateFormat('yyyy-MM-dd');
        String formattedDate = formatter.format(yesterday);
        k++;

        var headers = {
          'Authorization': 'Bearer $token',
        };
        var data = {
          'id': asendus,
          'channel': '0',
          'date_range': 'custom',
          'date_from': '$test 00:00:00',
          'date_to': '$test 23:59:59',
        };

        var url = Uri.parse(
            'https://shelly-64-eu.shelly.cloud/statistics/relay/consumption');
        var res = await http.post(url, headers: headers, body: data);
        formattedDate = formattedDate + 'T20';
        test = test + 'T20';
        if (res.statusCode != 200)
          throw Exception('http.post error: statusCode= ${res.statusCode}');
        final jsonData = json.decode(res.body);
        var resJson = json.decode(res.body) as Map<String, dynamic>;
        //print(res.body);
        final historyData = jsonData['data']['history'] as List<dynamic>;
        var url1 = Uri.parse(
            'https://dashboard.elering.ee/api/nps/price?start=$formattedDate%3A59%3A59.999Z&end=$test%3A59%3A59.999Z');
        var res1 = await http.get(url1);
        if (res1.statusCode != 200)
          throw Exception('http.get error: statusCode= ${res1.statusCode}');
        //print(res1.body);
        final httpPackageJson = json.decode(res1.body) as Map<String, dynamic>;
        var entryList;
        entryList = httpPackageJson.entries.toList();

        //Võtab Listist Eesti hinnagraafiku
        var ajutine = entryList[1].value;
        var ajutine2 = ajutine.entries.toList();
        var hinnagraafik = ajutine2[0].value;

        for (var i = 0; i < 24; i++) {
          //print(resJson['data']['units']['consumption']);
          var ajutineTarb;
          if (resJson['data']['units']['consumption'] == 'Wh') {
            ajutineTarb = historyData[i]['consumption'] / 1000000;
          } else {
            ajutineTarb = historyData[i]['consumption'] / 1000000;
          }
          katse = katse + ajutineTarb;
          // print(historyData);

          hind = hind + (ajutineTarb * hinnagraafik[i]['price']);
        }
      }
      u++;
    }
    num n = num.parse(hind.toStringAsFixed(5));
    hind = n as double;
    return hind;
  }
  if (vahemik == 'Aasta') {
    DateTime now = DateTime.now();
    now = now.subtract(Duration(days: 1));
    DateTime startOfYear = DateTime(now.year, 1, 1);
    DateTime algus = startOfYear.subtract(Duration(days: 1));
    DateTime endOfDay = now;
    print('algus');
    String algus1 = DateFormat('yyyy-MM-dd').format(algus);
    algus1 = algus1 + 'T20';
    List<DateTime> yearDates = [];
    DateTime date = startOfYear;

    while (date.isBefore(endOfDay) || date.isAtSameMomentAs(endOfDay)) {
      yearDates.add(date);
      date = date.add(Duration(days: 1));
    }

// Formatting the dates
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    List<String> formattedDates =
        yearDates.map((date) => formatter.format(date)).toList();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('kuupäev');
    print(formattedDates[formattedDates.length - 1]);
    String temp = formattedDates[0] as String;
    temp = temp + 'T20';
    String temp1 = formattedDates[formattedDates.length - 1] as String;
    temp1 = temp1 + 'T20';
    var url1 = Uri.parse(
        'https://dashboard.elering.ee/api/nps/price?start=$algus1%3A59%3A59.999Z&end=$temp1%3A59%3A59.999Z');
    var res1 = await http.get(url1);
    if (res1.statusCode != 200)
      throw Exception('http.get error: statusCode= ${res1.statusCode}');
    //print(res1.body);
    final httpPackageJson = json.decode(res1.body) as Map<String, dynamic>;
    var entryList;
    entryList = httpPackageJson.entries.toList();

    //Võtab Listist Eesti hinnagraafiku
    var ajutine = entryList[1].value;
    var ajutine2 = ajutine.entries.toList();
    var hinnagraafik = ajutine2[0].value;

    var token = await getToken();
    double katse = 0;
    double hind = 0;
    var k = 0;
    var seadmedJSONmap = prefs.getString('seadmed');
//print(seadmedJSONmap);
    if (seadmedJSONmap == null) {
      return 0;
    }
    Map<String, dynamic> storedMap = json.decode(seadmedJSONmap);

    var i = 0;

    var u = 0;
    int asi = 0;
    for (var i in storedMap.values) {
      print('object');
      print(asi);
      asi++;
      String asendus = storedMap['Seade$u']['Seadme_ID'] as String;
      k = 0;
      int o = 0;
      for (var j = 1; j <= formattedDates.length - 1; j++) {
        String test = formattedDates[k];
        String customDateString = formattedDates[k]; // Your custom date string

        DateTime customDate = DateTime.parse(customDateString);
        DateTime yesterday = customDate.subtract(Duration(days: 1));

        DateFormat formatter = DateFormat('yyyy-MM-dd');
        String formattedDate = formatter.format(yesterday);
        k++;

        var headers = {
          'Authorization': 'Bearer $token',
        };
        var data = {
          'id': asendus,
          'channel': '0',
          'date_range': 'custom',
          'date_from': '$test 00:00:00',
          'date_to': '$test 23:59:59',
        };

        var url = Uri.parse(
            'https://shelly-64-eu.shelly.cloud/statistics/relay/consumption');
        var res = await http.post(url, headers: headers, body: data);
        formattedDate = formattedDate + 'T20';
        test = test + 'T20';
        if (res.statusCode != 200)
          throw Exception('http.post error: statusCode= ${res.statusCode}');
        final jsonData = json.decode(res.body);
        var resJson = json.decode(res.body) as Map<String, dynamic>;
        //print(res.body);
        final historyData = jsonData['data']['history'] as List<dynamic>;

        for (var i = 0; i < 24; i++) {
          //print(resJson['data']['units']['consumption']);
          var ajutineTarb;
          if (resJson['data']['units']['consumption'] == 'Wh') {
            ajutineTarb = historyData[i]['consumption'] / 1000000;
          } else {
            ajutineTarb = historyData[i]['consumption'] / 1000000;
          }
          katse = katse + ajutineTarb;
          // print(historyData);

          hind = hind + (ajutineTarb * hinnagraafik[o]['price']);

          print(o);
          print(ajutineTarb);
          print(historyData[i]['consumption']);
          print(hinnagraafik[o]['price']);
          print(hind);
          o++;
        }
      }
      u++;
    }
    num n = num.parse(hind.toStringAsFixed(5));
    hind = n as double;
    return hind;
  }
}
