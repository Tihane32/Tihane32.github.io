import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/funktsioonid/graafikGen2.dart';
import 'package:testuus4/Arhiiv/energiaGraafik.dart';
import 'dart:convert';
import '../main.dart';
import 'token.dart';
import 'package:testuus4/Arhiiv/kaksTabelit.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:testuus4/funktsioonid/Elering.dart';
import 'package:intl/intl.dart';

seadmeMaksumus(String value, [Function? setPaevamaksumus]) async {
  Map<int, List<double>> paevaMaksumus = {};
  Map<DateTime, double> maksumusSeade = {};
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

  
  double katse = 0;
  double hind = 0;
  var k = 0;
  var seadmedJSONmap = prefs.getString('seadmed');
  //print(seadmedJSONmap);

  var i = 0;

  var u = 0;

  for (var j = 1; j <= formattedDates.length; j++) {
    double temp = 0;
    String test = formattedDates[k];
    String customDateString = formattedDates[k]; // Your custom date string

    DateTime customDate = DateTime.parse(customDateString);
    DateTime yesterday = customDate.subtract(Duration(days: 1));

    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(yesterday);
    k++;

    var headers = {
      'Authorization': 'Bearer ${tokenMap[value]}',
    };
    var data = {
      'id': value,
      'channel': '0',
      'date_range': 'custom',
      'date_from': '$test 00:00:00',
      'date_to': '$test 23:59:59',
    };

    var url = Uri.parse(
        '${seadmeteMap[value]["api_url"]}/statistics/relay/consumption');
    var res = await http.post(url, headers: headers, body: data);
    formattedDate = formattedDate + 'T20';
    String abi = test;
    test = test + 'T20';

    if (res.statusCode != 200) {
      return;
      
    }
    final jsonData = json.decode(res.body);
    var resJson = json.decode(res.body) as Map<String, dynamic>;
    //print(res.body);
    final historyData = jsonData['data']['history'] as List<dynamic>;
    var url1 = Uri.parse(
        'https://dashboard.elering.ee/api/nps/price?start=$formattedDate%3A59%3A59.999Z&end=$test%3A59%3A59.999Z');
    var res1 = await http.get(url1);
    if (res1.statusCode != 200) {
      throw Exception('http.get error: statusCode= ${res1.statusCode}');
    }
    //print(res1.body);
    final httpPackageJson = json.decode(res1.body) as Map<String, dynamic>;
    var entryList;
    entryList = httpPackageJson.entries.toList();

    //Võtab Listist Eesti hinnagraafiku
    var ajutine = entryList[1].value;
    var ajutine2 = ajutine.entries.toList();
    var hinnagraafik = ajutine2[0].value;
    paevaMaksumus[u] = [];
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
      temp = temp + ajutineTarb * hinnagraafik[i]['price'];
      hind = hind + (ajutineTarb * hinnagraafik[i]['price']);

      paevaMaksumus[u]?.add(ajutineTarb * hinnagraafik[i]['price']);
    }
    u++;
    maksumusSeade[DateTime.parse(abi)] = temp;
  }

  //print(paevaMaksumus);
  if (setPaevamaksumus != null) {
    setPaevamaksumus(paevaMaksumus);
  }

  print("seadmemaksusmus $value $maksumusSeade");
  return maksumusSeade;
}
