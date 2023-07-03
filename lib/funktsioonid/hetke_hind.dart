
import 'dart:convert';
import 'package:http/http.dart' as http;

//Kutsub esile hetke hinna Eestis
Future<Map<String, dynamic>> getCurrentPrice() async {
  final response = await http
      .get(Uri.parse('https://dashboard.elering.ee/api/nps/price/EE/current'));
  final hetkeHind = json.decode(response.body) as Map<String, dynamic>;
  return hetkeHind;
}
