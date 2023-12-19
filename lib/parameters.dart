import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    'Gruppi_voimsus': 0,
  },
};

Map<String, dynamic> anduriteMap = {};
/*'Temp_andurid': {
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
  'Valgus_andurid': {},*/

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
