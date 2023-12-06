import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/funktsioonid/Elering.dart';
import 'package:testuus4/funktsioonid/tarbmineSeadmeKohta.dart';
import 'package:testuus4/lehed/P%C3%B5hi_Lehed/koduleht.dart';
import 'dart:convert';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';import 'package:testuus4/parameters.dart';

seadmeMaksumus(String value, [Function? setPaevamaksumus]) async {
  Map<int, List<double>> paevaMaksumus = {};
  Map<DateTime, double> maksumusSeade = {};
  Map<dynamic, dynamic> dataLog = {};
  DateTime now = DateTime.now();
  DateTime startOfMonth = DateTime(now.year, now.month, 1);
  DateTime endOfMonth = lastDayOfMonth;

  List<DateTime> monthDates = [];
  DateTime date = firstDayOfMonth;
  List<dynamic> dataList = [];
  if (useServer == true) {
    dataList =
        await fetchDataFromServer(value, firstDayOfMonth, lastDayOfMonth);
  }
  if (dataList.isNotEmpty) {
    int u = 0;
    for (List<dynamic> data in dataList) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(data[1]);

      if (dateTime.isAfter(firstDayOfMonth) ||
          dateTime.isAtSameMomentAs(firstDayOfMonth)) {
        if (dateTime.isBefore(lastDayOfMonth) ||
            dateTime.isAtSameMomentAs(lastDayOfMonth)) {
          print("datetime $dateTime");
          print("firstday $firstDayOfMonth");
          print(lastDayOfMonth);
          double value = data[2];
          maksumusSeade[dateTime] = value;
        }
      }
    }

    // Get the last DateTime from the dataList
    DateTime lastDateTime =
        DateTime.fromMillisecondsSinceEpoch(dataList.last[1]);
    List<DateTime> newDates = [];
    while (lastDateTime.isBefore(lastDayOfMonth)) {
      lastDateTime = lastDateTime.add(Duration(days: 1));
      newDates.add(lastDateTime);
    }

    if (newDates.isNotEmpty) {
      Map<DateTime, double> newMaksumuseade =
          await getSeadmeMaksumus(value, newDates.first, newDates.last);

      newMaksumuseade.forEach((dateTime, value) {
        maksumusSeade[dateTime] = value;
      });
    }
    return maksumusSeade;
  }
  while (date.isBefore(endOfMonth) || date.isAtSameMomentAs(endOfMonth)) {
    monthDates.add(date);
    date = date.add(const Duration(days: 1));
  }

  // Formatting the dates
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  List<String> formattedDates =
      monthDates.map((date) => formatter.format(date)).toList();

  double katse = 0;
  double hind = 0;
  var k = 0;
  //print(seadmedJSONmap);

  var i = 0;

  var u = 0;

  for (var j = 1; j <= formattedDates.length; j++) {
    double temp = 0;
    String test = formattedDates[k];
    String customDateString = formattedDates[k]; // Your custom date string

    DateTime customDate = DateTime.parse(customDateString);
    DateTime yesterday = customDate.subtract(const Duration(days: 1));

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
    formattedDate = '${formattedDate}T20';
    String abi = test;
    test = '${test}T20';

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
    List<MapEntry<String, dynamic>> entryList;
    entryList = httpPackageJson.entries.toList();

    //Võtab Listist Eesti hinnagraafiku
    var ajutine = entryList[1].value;
    var ajutine2 = ajutine.entries.toList();
    var hinnagraafik = ajutine2[0].value;
    paevaMaksumus[u] = [];
    double tarbimine = 0.0;
    for (var i = 0; i < 24; i++) {
      //print(resJson['data']['units']['consumption']);
      var ajutineTarb;
      if (resJson['data']['units']['consumption'] == 'Wh') {
        ajutineTarb = historyData[i]['consumption'] / 1000000;
      } else {
        ajutineTarb = historyData[i]['consumption'] / 1000000;
      }
      tarbimine = tarbimine + ajutineTarb;
      katse = katse + ajutineTarb;
      // print(historyData);
      temp = temp + ajutineTarb * hinnagraafik[i]['price'];
      hind = hind + (ajutineTarb * hinnagraafik[i]['price']);

      paevaMaksumus[u]?.add(ajutineTarb * hinnagraafik[i]['price']);
    }

    maksumusSeade[DateTime.parse(abi)] = temp;
    int timestamp = DateTime.parse(abi).millisecondsSinceEpoch;
    if (!dataLog.containsKey(timestamp)) {
      // If not, create a new map for the timestamp
      dataLog["$timestamp"] = {};
    }

    // Set the "consumption" key for the timestamp
    dataLog["$timestamp"]["cost"] = temp;
    dataLog["$timestamp"]["consumption"] = tarbimine;
    print("testing cost $u $temp");
    print("testing consumption $u $tarbimine");
    u++;
  }

  //print(paevaMaksumus);
  if (setPaevamaksumus != null) {
    setPaevamaksumus(paevaMaksumus);
  }

  if (useServer) {
    await sendLogToServer(dataLog, value);
  }
  return maksumusSeade;
}

Future<Map<DateTime, double>> getSeadmeMaksumus(
    String value, DateTime startDate, DateTime endDate) async {
  Map<dynamic, dynamic> dataLog = {};
  List<double> eleringHinnad = await getElering(startDate, endDate);
  List<double> tarbimine = await getTarbimineList(value, startDate, endDate);
  Map<DateTime, double> maksumusSeade = {};
  int i = 0;
  int j = 0;
  int k = 0;
  while (startDate.isBefore(endDate)) {
    double maksumus = 0.0;
    double seadmeTarbimine = 0.0;
    for (j = 0; j < 24; j++) {
      maksumus = maksumus + (eleringHinnad[k] * tarbimine[k] / 1000000);
      seadmeTarbimine = seadmeTarbimine + tarbimine[k];
      k++;
    }

    i++;
    maksumusSeade[startDate] = maksumus;

    int timestamp = startDate.millisecondsSinceEpoch;
    if (!dataLog.containsKey(timestamp)) {
      // If not, create a new map for the timestamp
      dataLog["$timestamp"] = {};
    }

    // Set the "consumption" key for the timestamp
    dataLog["$timestamp"]["cost"] = maksumus;
    dataLog["$timestamp"]["consumption"] = seadmeTarbimine;

    startDate = startDate.add(Duration(days: 1));
  }

  //print(paevaMaksumus);

  await sendLogToServer(dataLog, value);

  return maksumusSeade;
}

seadmeMaksumus2(String value, [Function? setPaevamaksumus]) async {
  print("teeb siin");
  Map<int, List<double>> paevaMaksumus = {};
  Map<DateTime, double> maksumusSeade = {};
  Map<dynamic, dynamic> dataLog = {};
  List<DateTime> monthDates = [];

  DateTime endOfMonth = lastDayOfMonth;
  DateTime date = tarbimisFirstDay;
  if (endOfMonth.month == DateTime.now().month) {
    endOfMonth = DateTime.now();
  } else {
    int k = DateTime(date.year, date.month + 1, 0).day;
    endOfMonth = DateTime(date.year, date.month, k);
  }

  while (date.isBefore(endOfMonth) || date.isAtSameMomentAs(endOfMonth)) {
    monthDates.add(date);
    date = date.add(const Duration(days: 1));
  }
  print("päevad: $monthDates");
  // Formatting the dates
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  List<String> formattedDates =
      monthDates.map((date) => formatter.format(date)).toList();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  double katse = 0;
  double hind = 0;
  var k = 0;
  //print(seadmedJSONmap);

  var i = 0;

  var u = 0;

  for (var j = 1; j <= formattedDates.length; j++) {
    double temp = 0;
    String test = formattedDates[k];
    String customDateString = formattedDates[k]; // Your custom date string

    DateTime customDate = DateTime.parse(customDateString);
    DateTime yesterday = customDate.subtract(const Duration(days: 1));

    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(yesterday);
    k++;

    var headers = {
      'Authorization': 'Bearer ${tokenMap[value]}',
    };
    print(test);
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
    formattedDate = '${formattedDate}T20';
    String abi = test;
    test = '${test}T20';

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
    List<MapEntry<String, dynamic>> entryList;
    entryList = httpPackageJson.entries.toList();

    //Võtab Listist Eesti hinnagraafiku
    var ajutine = entryList[1].value;
    var ajutine2 = ajutine.entries.toList();
    var hinnagraafik = ajutine2[0].value;
    paevaMaksumus[u] = [];
    double tarbimine = 0.0;
    for (var i = 0; i < 24; i++) {
      //print(resJson['data']['units']['consumption']);
      var ajutineTarb;
      if (resJson['data']['units']['consumption'] == 'Wh') {
        ajutineTarb = historyData[i]['consumption'] / 1000000;
      } else {
        ajutineTarb = historyData[i]['consumption'] / 1000000;
      }
      tarbimine = tarbimine + ajutineTarb;
      katse = katse + ajutineTarb;
      // print(historyData);
      temp = temp + ajutineTarb * hinnagraafik[i]['price'];
      hind = hind + (ajutineTarb * hinnagraafik[i]['price']);

      paevaMaksumus[u]?.add(ajutineTarb * hinnagraafik[i]['price']);
    }
    u++;
    maksumusSeade[DateTime.parse(abi)] = temp;
    int timestamp = DateTime.parse(abi).millisecondsSinceEpoch;
    if (!dataLog.containsKey(timestamp)) {
      // If not, create a new map for the timestamp
      dataLog["$timestamp"] = {};
    }

    // Set the "consumption" key for the timestamp
    dataLog["$timestamp"]["cost"] = temp;
    dataLog["$timestamp"]["consumption"] = tarbimine;
  }

  //print(paevaMaksumus);
  if (setPaevamaksumus != null) {
    setPaevamaksumus(paevaMaksumus);
  }

  if (useServer) {
    await sendLogToServer(dataLog, value);
  }

  return maksumusSeade;
}
