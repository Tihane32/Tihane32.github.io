import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';import 'package:testuus4/parameters.dart';
import 'package:testuus4/main.dart';

Future<String> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? ajutineKasutajanimi = prefs.getString('Kasutajanimi');
  String? sha1Hash = prefs.getString('Kasutajaparool');
  String? token = prefs.getString('token');

  if (ajutineKasutajanimi == null) {
    return 'null';
  }

  var headers1 = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  var kasutajaAndmed = {
    'email': ajutineKasutajanimi,
    'password': sha1Hash,
    'var': '2',
  };
  var sisselogimiseUrl = Uri.parse('https://api.shelly.cloud/auth/login');
  var sisselogimiseVastus = await http.post(sisselogimiseUrl,
      headers: headers1, body: kasutajaAndmed);
  var vastusJSON =
      json.decode(sisselogimiseVastus.body) as Map<String, dynamic>;
  token = vastusJSON['data']['token'];
  prefs.setString('token', token!);

  return token;
}

Future<String> getToken2() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? ajutineKasutajanimi = prefs.getString('Kasutajanimi');
  String? sha1Hash = prefs.getString('Kasutajaparool');
  String? token = prefs.getString('token');

  if (ajutineKasutajanimi == null) {
    return 'null';
  }
  if (token == null) {
    var headers1 = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    var kasutajaAndmed = {
      'email': ajutineKasutajanimi,
      'password': sha1Hash,
      'var': '2',
    };
    var sisselogimiseUrl = Uri.parse('https://api.shelly.cloud/auth/login');
    var sisselogimiseVastus = await http.post(sisselogimiseUrl,
        headers: headers1, body: kasutajaAndmed);
    var vastusJSON =
        json.decode(sisselogimiseVastus.body) as Map<String, dynamic>;
    token = vastusJSON['data']['token'];
    prefs.setString('token', token!);
  }

  return token;
}

getToken3() async {
  Map<String, String> tokenMapUus = {};
  await Future.wait(seadmeteMap.keys.map((key) async {
    String ajutineKasutajanimi = seadmeteMap[key]["Username"];
    String sha1Hash = seadmeteMap[key]["Password"];
    var headers1 = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    var kasutajaAndmed = {
      'email': ajutineKasutajanimi,
      'password': sha1Hash,
      'var': '2',
    };
    var sisselogimiseUrl = Uri.parse('https://api.shelly.cloud/auth/login');
    var sisselogimiseVastus = await http.post(sisselogimiseUrl,
        headers: headers1, body: kasutajaAndmed);
    var vastusJSON =
        json.decode(sisselogimiseVastus.body) as Map<String, dynamic>;
    print(vastusJSON);
    String token = vastusJSON['data']['token'];
    tokenMapUus[key] = token;
  }));

  tokenMap = tokenMapUus;
}
