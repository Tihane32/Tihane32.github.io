/*
Trevor Uuna, Jaakob Lambot 27.03.2023
TalTech
*/
//Kit test
import 'package:flutter/material.dart';
import 'lehed/koduleht.dart';
import 'lehed/kaksTabelit.dart';
//Maini käivitamine, home on koduleht.

   Color sinineKast= const Color.fromARGB(255, 143, 209, 238);
   Color backround= const Color.fromARGB(255, 255, 255, 255);
   Color appbar =const Color.fromARGB(255, 115, 162, 195);
   Color roheline =const Color.fromARGB(255, 143, 238, 152);
void main() {
 
  runApp(MaterialApp(
    theme: ThemeData(brightness: Brightness.light),
    home: MinuSeadmed(), //Alustab appi kodulehest
  ));
}
