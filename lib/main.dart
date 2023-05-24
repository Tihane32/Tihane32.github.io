/*
Trevor Uuna, Jaakob Lambot 27.03.2023
TalTech
*/
//Kit test
import 'package:flutter/material.dart';
import 'lehed/koduleht.dart';
//Maini käivitamine, home on koduleht.

void main() {
  runApp(MaterialApp(
    theme: ThemeData(brightness: Brightness.light),
    home: KoduLeht(), //Alustab appi kodulehest
  ));
}
