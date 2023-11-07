import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

salvestaSeadistus(String parameetriNim, double parameeter,
    Map<String, bool> valitudSeadmed) async {
  int trueCount = 0;
  String valitudSeade = '';
  for (var entry in valitudSeadmed.entries) {
    if (entry.value) {
      trueCount++;
      valitudSeade = entry.key;
    }
  }
  if (trueCount == 1) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    seadmeteMap[valitudSeade][parameetriNim] = parameeter;
    String keyMap = json.encode(seadmeteMap);
    prefs.setString('seadmed', keyMap);
  }
}
