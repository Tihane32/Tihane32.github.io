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
import 'lehed/Põhi_Lehed/dynamicKoduLeht.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

//Maini käivitamine, home on koduleht.
//bool graafikuNahtavus = true;

List<dynamic> tariif = [];
Map<String, String> tokenMap = {};

int seadmeteListIndex = 0;

//KEELATUD TUNNID MALLU
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

Map<String, dynamic> anduriteMap = {
  'Temp_andurid': {
    '6l6l7k7k': {
      'Anduri_pilt': 'assets/saun1.jpg',
      'Anduri_nimi': 'Tandur',
      'Anduri_olek': 'on',
    },
    'x9x9x9x9': {
      'Anduri_pilt': 'assets/saun1.jpg',
      'Anduri_nimi': 'Temperatuuri andur',
      'Anduri_olek': 'off',
    },
  },
  'Niiskus_andurid': {
    's4s4i0i0': {
      'Anduri_pilt': 'assets/saun1.jpg',
      'Anduri_nimi': 'Niiskus andur',
      'Anduri_olek': 'on',
    },
    '6h6h8k8k': {
      'Anduri_pilt': 'assets/saun1.jpg',
      'Anduri_nimi': 'Nandur',
      'Anduri_olek': 'off',
    },
  },
  'Valgus_andurid': [],
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

const String serverUrl = '172.22.22.222';
bool useServer = false;
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
        Uri.parse("http://$serverUrl:5000/log/cost_daily/_$value"),
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
  String start = DateFormat('yyyy-MM-dd').format(firstDayOfMonth);
  String end = DateFormat('yyyy-MM-dd').format(lastDayOfMonth);
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
