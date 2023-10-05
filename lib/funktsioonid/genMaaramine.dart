import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/funktsioonid/graafikGen2.dart';
import 'token.dart';
import 'graafikGen1.dart';
import 'package:testuus4/main.dart';

/// The function `genMaaramine` determines which generation of a device is being used and calls the
/// appropriate function.
/// 
/// Args:
///   lulitus (Map<int, dynamic>): A map containing information about the devices.
///   paev (String): The parameter "paev" is a String representing the day for which the graph needs to
/// be generated.
///   seadmeNimi (String): The parameter "seadmeNimi" is a string that represents the ID of a device.
genMaaramine(
  Map<int, dynamic> lulitus,
  String paev,
  //Map<String, dynamic> seadmeteMap,
  String seadmeNimi,
) {
  if (seadmeteMap[seadmeNimi]["Seadme_generatsioon"] == 1) {
    gen1GraafikLoomine(lulitus, paev, seadmeNimi);
  } else {
    gen2GraafikuLoomine(lulitus, paev, seadmeNimi);
  }
}
