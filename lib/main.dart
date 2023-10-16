/*
Trevor Uuna, Jaakob Lambot 27.03.2023
TalTech
*/
//Kit test
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:testuus4/funktsioonid/graafikGen2.dart';
import 'package:testuus4/lehed/GraafikusseSeadmeteValik.dart';
import 'funktsioonid/backroundTask.dart';
import 'funktsioonid/graafikGen1.dart';
import 'lehed/dynamicKoduLeht.dart';
import 'lehed/koduleht.dart';
import 'Arhiiv/kaksTabelit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'lehed/seadmeteList.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:workmanager/workmanager.dart';

//Maini käivitamine, home on koduleht.
//bool graafikuNahtavus = true;
Map<String, dynamic> seadmeteMap = {};
double vahe = 20;
double navBarHeight = 55;
Color sinineKast = const Color.fromARGB(255, 143, 209, 238);
Color backround = const Color.fromARGB(255, 255, 255, 255);
Color appbar = const Color.fromARGB(255, 115, 162, 195);
Color roheline = Color.fromARGB(255, 109, 217, 119);
TextStyle fontSuur = GoogleFonts.roboto(
    textStyle: const TextStyle(
        fontWeight: FontWeight.w500, fontSize: 22, color: Colors.black));
TextStyle font = GoogleFonts.roboto(
    textStyle: const TextStyle(
        fontWeight: FontWeight.w500, fontSize: 18, color: Colors.black));
TextStyle fontHall = GoogleFonts.roboto(
    textStyle: const TextStyle(
        fontWeight: FontWeight.w500, fontSize: 18, color: Colors.black));
TextStyle fontValge = GoogleFonts.roboto(
    textStyle: const TextStyle(
        //fontWeight: FontWeight.w500,
        fontSize: 18,
        color: Color.fromARGB(255, 255, 255, 255)));
TextStyle fontValgeVaike = GoogleFonts.roboto(
    textStyle: const TextStyle(
        //fontWeight: FontWeight.w500,
        fontSize: 14,
        color: Color.fromARGB(255, 255, 255, 255)));
TextStyle fontVaike = GoogleFonts.roboto(
    textStyle: const TextStyle(
        fontWeight: FontWeight.w500, fontSize: 14, color: Colors.black));
TextStyle fontVaikePunane = GoogleFonts.roboto(
    textStyle: const TextStyle(
        fontWeight: FontWeight.w500, fontSize: 14, color: Colors.red));
double sinineKastLaius = double.infinity;
double sinineKastKorgus = 45;
BorderRadius borderRadius = BorderRadius.circular(5.0);
Border border = Border.all(
  color: const Color.fromARGB(255, 0, 0, 0),
  width: 2,
);
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("Background task executed at ${DateTime.now()}");

    var headers1 = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    var data1 = {
      'channel': '0',
      'enabled': "1",
      'schedule_rules': "0055-3-on",
      'id': '80646f81ad9a',
      'auth_key':
          "MTcxYTNjdWlk99F3FBAA1664CCBA1DB1A6FE1A156072DB6AF5A8F1B4A1B0ACB7C82002649DADF1114D97483D4E12",
    };

    var url1 = Uri.parse(
        'https://shelly-64-eu.shelly.cloud/device/relay/settings/schedule_rules');
    var res1 = await http.post(url1, headers: headers1, body: data1);
    print(res1.body);

    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
//backround start
  SharedPreferences prefs = await SharedPreferences.getInstance();

  []; //Võtab mälust 'users'-i asukohast väärtused
  var seadmedJSONmap = prefs.getString('seadmed');
  //print(seadmedJSONmap);
  if (seadmedJSONmap != null) {
    seadmeteMap = json.decode(seadmedJSONmap);
  }

//backround end

  runApp(MaterialApp(
    theme: ThemeData(brightness: Brightness.light),
    home: DynaamilenieKoduLeht(i: 1), //Alustab appi kodulehest
  ));
  

  /*Workmanager().initialize(callbackDispatcher);
  Workmanager().registerPeriodicTask(
    "1",
    "simplePeriodicTask",
    frequency: Duration(seconds: 5),
  );*/
  graafikGen2DeleteAll("30c6f7828098");

  //graafikGen1Lugemine("80646f81ad9a");
}

