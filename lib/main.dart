/*
Trevor Uuna, Jaakob Lambot 27.03.2023
TalTech
*/
//Kit test
import 'package:flutter/material.dart';
import 'lehed/koduleht.dart';
import 'lehed/kaksTabelit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'lehed/seadmeteList.dart';
//Maini käivitamine, home on koduleht.

   Color sinineKast= const Color.fromARGB(255, 143, 209, 238);
   Color backround= const Color.fromARGB(255, 255, 255, 255);
   Color appbar =const Color.fromARGB(255, 115, 162, 195);
   Color roheline =Color.fromARGB(255, 109, 217, 119);
   TextStyle font = GoogleFonts.roboto(
      textStyle: const TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 20,
    color: Colors.black
  ));
  double sinineKastLaius = double.infinity;
  double sinineKastKorgus = 45;
void main() {
 
  runApp(MaterialApp(
    theme: ThemeData(brightness: Brightness.light),
    home: SeadmeteList(), //Alustab appi kodulehest
  ));
}
