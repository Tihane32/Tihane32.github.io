/*
Trevor Uuna, Jaakob Lambot 27.03.2023
TalTech
*/
//Kit test
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:testuus4/funktsioonid/graafikGen2.dart';
import 'package:testuus4/funktsioonid/token.dart';
import 'package:testuus4/lehed/Tundide_valimis_Lehed/Graafik_Seadmete_valik/DynaamilineGraafikusseSeadmeteValik.dart';
import 'funktsioonid/backroundTask.dart';
import 'funktsioonid/graafikGen1.dart';
import 'funktsioonid/voimsus.dart';
import 'lehed/Põhi_Lehed/dynamicKoduLeht.dart';
import 'lehed/Põhi_Lehed/koduleht.dart';
import 'Arhiiv/kaksTabelit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'lehed/Põhi_Lehed/seadmeteListDynaamiline.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:workmanager/workmanager.dart';

//Maini käivitamine, home on koduleht.
//bool graafikuNahtavus = true;
List<dynamic> tariif = [];
Map<String, String> tokenMap = {};

Map<String, dynamic> graafikuSeaded = {
  'Valitud_Tunnid': 12,
  'Hinnapiir': 50.50,
  'Seadistus_lubatud': false,
  'Max_jarjest_valjas': 1.0,
  'Kelleatud_tunnid': [],
  'Lubatud_tunnid': [],
};

Map<String, dynamic> gruppiMap = {
  'Kõik Seadmed': {
    'Gruppi_pilt': 'assets/saun1.jpg',
    'Grupi_Seadmed': [],
    'Grupi_temp_andur': [],
    'Grupi_niiskus_andur': [],
    'Grupi_valgus_andur': [],
    'Grupi_temp': 27.3,
    'Gruppi_olek': 'on',
  },
};

String paevAbi = "";
bool seadmeKinnitus = false;
List<bool> mitmeSeadmeKinnitus = [];
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
TextStyle fontVaikeLight = GoogleFonts.roboto(
    textStyle: const TextStyle(
        letterSpacing: 1,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: Color.fromARGB(255, 48, 44, 44)));
TextStyle fontEritiVaike = GoogleFonts.roboto(
    textStyle: const TextStyle(
        fontWeight: FontWeight.w500, fontSize: 12, color: Colors.black));
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

  var gruppidJSONmap = prefs.getString('gruppid');
  if (gruppidJSONmap != null) {
    gruppiMap = json.decode(gruppidJSONmap);
  } else {
    gruppiMap['Kõik Seadmed']['Grupi_Seadmed'] = seadmeteMap.keys.toList();
  }

  var temp = prefs.getString('tariif');
  if (temp != null) {
    tariif = json.decode(temp);
    print("siiiin tariif: $tariif");
  }
  await getToken3();
  print("------------");
  print(tokenMap);
  print(seadmeteMap);
  print("------------");
//backround end

  runApp(MaterialApp(
    theme: ThemeData(brightness: Brightness.light),
    home: DynaamilenieKoduLeht(i: 1), //Alustab appi kodulehest
  ));
  //energia();
  //energia2();
  /*Workmanager().initialize(callbackDispatcher);
  Workmanager().registerPeriodicTask(
    "1",
    "simplePeriodicTask",
    frequency: Duration(seconds: 5),
  );*/
  //graafikGen2DeleteAll("30c6f7828098");

  //graafikGen1Lugemine("80646f81ad9a");
}
