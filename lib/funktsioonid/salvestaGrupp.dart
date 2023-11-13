import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

SalvestaUusGrupp(String gruppiNimi, Map<String, bool> valitudSeadmed) async {
  gruppiMap['Kõik Seadmed']['Grupi_Seadmed'] = seadmeteMap.keys.toList();
  if (gruppiNimi != 'Kõik Seadmed') {
    Map<String, dynamic> uusGrupp = {
      'Gruppi_pilt': 'assets/saun1.jpg',
      'Grupi_Seadmed': [],
      'Grupi_andurid': [],
      'Grupi_temp': 27.3,
      'Gruppi_olek': 'on',
    };
    valitudSeadmed.forEach((key, value) async {
      if (value == true) {
        uusGrupp['Grupi_Seadmed'].add(key);
      }
    });
    gruppiMap['$gruppiNimi'] = uusGrupp;
  }
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String gMap = json.encode(gruppiMap);
  prefs.setString('gruppid', gMap);
}
