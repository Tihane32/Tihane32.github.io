import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'package:testuus4/parameters.dart';
saaGrupiOlek(String gruppiNimi) {
  String olek = 'off';
  List seadmed = [];
  int onSeadmed = 1;

  seadmed = gruppiMap[gruppiNimi]['Grupi_Seadmed'];

  for (var item in seadmed) {
    if (seadmeteMap[item]['Seadme_olek'] == 'Offline') {
      olek = 'Offline';
    } else if (seadmeteMap[item]['Seadme_olek'] == 'on') {
      onSeadmed++;
    }
  }
  if (onSeadmed == seadmed.length) {
    olek = 'on';
  }

  gruppiMap[gruppiNimi]["Gruppi_olek"] = olek;

  return olek;
}
