import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

gen2GraafikuLoomine(var selected, var valitudPaev) async {
  var graafikud = Map<String, dynamic>();
  await graafikuteSaamine(graafikud);
  print(graafikud);
}

graafikuteSaamine(Map<String, dynamic> graafikud) async {
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
  //Todo peab lisama beareri saamise
  var headers = {
    'Authorization': 'Bearer $token',
  };

  var data = {
    'id': '30c6f7828098',
    'method': 'schedule.list',
  };

  var url = Uri.parse(
      'https://shelly-64-eu.shelly.cloud/fast/device/gen2_generic_command');
  var res = await http.post(url, headers: headers, body: data);
  if (res.statusCode != 200)
    throw Exception('http.post error: statusCode= ${res.statusCode}');

  var resJSON = jsonDecode(res.body) as Map<String, dynamic>;
  var jobs = resJSON['data']['jobs'] as List<dynamic>;

  for (var job in jobs) {
    var id = job['id'] as int;
    var timespec = job['timespec'] as String;
    var calls = job['calls'] as List<dynamic>;
    var graafik = Map<String, dynamic>();
    for (var call in calls) {
      var params = call['params']['on'];

      graafik['Timespec'] = timespec;
      graafik['On/Off'] = params;
      graafikud['$id'] = graafik;
    }
  }
}
