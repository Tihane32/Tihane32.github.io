import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<String> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? ajutineKasutajanimi = prefs.getString('Kasutajanimi');
  String? sha1Hash = prefs.getString('Kasutajaparool');

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
  var token = vastusJSON['data']['token'];
  return token;
}
