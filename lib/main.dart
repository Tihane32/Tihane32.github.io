/*
Trevor Uuna, Jaakob Lambot 27.03.2023
TalTech
*/
//Kit test
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testuus4/funktsioonid/token.dart';
import 'package:testuus4/parameters.dart';
import 'lehed/Põhi_Lehed/dynamicKoduLeht.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

//Maini käivitamine, home on koduleht.
//bool graafikuNahtavus = true;


ping() async {
  final int port = 5500; // You can adjust the port number

  try {
    final socket =
        await Socket.connect(serverUrl, port, timeout: Duration(seconds: 2));
    print('Connected to $serverUrl:$port');
    socket.close();
    useServer = true;
  } catch (e) {
    print('Error: $e');
  }
}

Future<void> sendLogToServer(Map<dynamic, dynamic> log, String value) async {
  if (useServer == true) {
    DateTime now = DateTime.now();
    int todayTimestamp =
        DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    if (log.containsKey(todayTimestamp)) {
      // Remove the key corresponding to today's date
      log.remove(todayTimestamp);
      print('Key for today removed successfully.');
    }

    print("sending log: $log");
    try {
      await http.post(
        Uri.parse("http://$serverUrl:5500/log/cost_daily/_$value"),
        body: jsonEncode(log),
        headers: {
          'Content-Type': 'application/json'
        }, // Set the correct content type
      );
    } catch (e) {
      print('Error logdata: $e');
    }
  }
}

Future<List> fetchDataFromServer(
    value, DateTime firstDayOfMonth, DateTime lastDayOfMonth) async {
  print("fecthib");

  String month = DateFormat('MM').format(firstDayOfMonth);
  List<dynamic> ListData = [];
  Map<String, dynamic> data = {};
  if (useServer == true) {
    try {
      final response = await http
          .get(Uri.parse("http://$serverUrl:5500/data/_$value/$month"));

      if (response.statusCode == 200) {
        // Parse the JSON response
        data = json.decode(response.body);

        // Access the data and handle it as needed
        print('Data received from server: ${data['data']}');
        print(data);
        ListData = data['data'];
      } else {
        // Handle errors or non-200 status codes
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors or exceptions
      print('Error fetchdata: $e');
    }
  }
  print("list $ListData");
  return ListData;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
//backround start
  await ping();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  []; //Võtab mälust 'users'-i asukohast väärtused
  var seadmedJSONmap = prefs.getString('seadmed');
  //print(seadmedJSONmap);
  if (seadmedJSONmap != null) {
    seadmeteMap = json.decode(seadmedJSONmap);
  }

  var anduridJSONmap = prefs.getString('andurid');
  if (anduridJSONmap != null) {
    anduriteMap = json.decode(anduridJSONmap);
  }

  var gruppidJSONmap = prefs.getString('gruppid');
  if (gruppidJSONmap != null) {
    gruppiMap = json.decode(gruppidJSONmap);
  } else {
    gruppiMap['Kõik Seadmed']['Grupi_Seadmed'] = seadmeteMap.keys.toList();
  }

  var temp = prefs.getString('tariif');
  if (temp != null) {
    tariif = json.decode(temp);
  }
  await getToken3();
//backround end

  //await fetchDataFromServer();
  runApp(MaterialApp(
    theme: ThemeData(brightness: Brightness.light),
    home: DynaamilenieKoduLeht(i: 1), //Alustab appi kodulehest
  ));
}
