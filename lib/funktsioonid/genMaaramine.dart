import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/funktsioonid/graafikGen2.dart';
import 'token.dart';
import 'graafikGen1.dart';

//TODO: peab tegema nii, et topelt graafikut ei laseks panna
genMaaramine(
  Map<int, dynamic> lulitus,
  String paev,
  Map<String, List<String>> seadmeteMap,
  String seadmeNimi,
) {
  if (seadmeteMap[seadmeNimi]![4] == 1) {
    gen1GraafikLoomine(lulitus, paev, seadmeteMap[seadmeNimi]![1]);
  } else {
    gen2GraafikuLoomine(lulitus, paev, seadmeteMap[seadmeNimi]![1]);
  }
}
