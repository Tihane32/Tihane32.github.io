import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

salvestaSeadistus(String parameetriNim, var parameeter,
    Map<String, bool> valitudSeadmed) async {
  String valitudSeade = '';
  for (var entry in valitudSeadmed.entries) {
    if (entry.value) {
      valitudSeade = entry.key;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      seadmeteMap[valitudSeade][parameetriNim] = parameeter;
      String keyMap = json.encode(seadmeteMap);
      prefs.setString('seadmed', keyMap);
    }
  }
}
