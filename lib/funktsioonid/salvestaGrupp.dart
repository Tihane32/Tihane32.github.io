import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

SalvestaUusGrupp(String gruppiNimi, Map<String, bool> valitudSeadmed,
    String? tempAid, String? niiskusAid, String? valgusAid) async {
  gruppiMap['Kõik Seadmed']['Grupi_Seadmed'] = seadmeteMap.keys.toList();
  if (gruppiNimi != 'Kõik Seadmed') {
    List<String> seadmed = [];
    Map<String, dynamic> uusGrupp = {
      'Gruppi_pilt': 'assets/saun1.jpg',
      'Grupi_Seadmed': [],
      'Grupi_temp_andur': '',
      'Grupi_niiskus_andur': '',
      'Grupi_valgus_andur': '',
      'Grupi_temp': 27.3,
      'Gruppi_olek': 'on',
    };
    valitudSeadmed.forEach((key, value) async {
      if (value == true) {
        seadmed.add(key);
      }
    });
    uusGrupp['Grupi_Seadmed'] = seadmed;
    if (tempAid != '') {
      uusGrupp['Grupi_temp_andur'] = tempAid;
    }
    if (niiskusAid != '') {
      uusGrupp['Grupi_niiskus_andur'] = niiskusAid;
    }
    if (valgusAid != '') {
      uusGrupp['Grupi_valgus_andur'] = valgusAid;
    }

    gruppiMap['$gruppiNimi'] = uusGrupp;
    print(valitudSeadmed);
    print(gruppiMap);
  }
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String gMap = json.encode(gruppiMap);
  prefs.setString('gruppid', gMap);
}
