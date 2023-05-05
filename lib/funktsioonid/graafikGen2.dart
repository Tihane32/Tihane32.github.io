import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'token.dart';

//TODO: peab tegema nii, et topelt graafikut ei laseks panna
gen2GraafikuLoomine(var selected, var valitudPaev) async {
  print(selected);
  print(valitudPaev);
  var graafikud = Map<String, dynamic>();
  await graafikuteSaamine(graafikud);
  print('vana: $graafikud');
  await graafikuKustutamine(graafikud);
  print('uus: $graafikud');
  await graafikuloomine(graafikud, selected, valitudPaev);
}

graafikuteSaamine(Map<String, dynamic> graafikud) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? ajutineKasutajanimi = prefs.getString('Kasutajanimi');
  String? sha1Hash = prefs.getString('Kasutajaparool');

  String token = await getToken();
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

graafikuloomine(Map<String, dynamic> graafikud, selected, valitudPaev) async {
  var j = 1;
  for (var i in graafikud.keys) {
    print(i);
    print(graafikud['$j']);
    j++;
  }
  var i = 0;
  bool lulitus;
  String tund;
  for (i = 0; i < 24; i++) {
    if (selected[i] == true) {
      if (i == 0) {
        lulitus = true;
        tund = '$i';
        print(lulitus);
        print(i);
        graafikuSaatmine(lulitus, tund, valitudPaev);
      } else {
        if (selected[i] != selected[i - 1]) {
          lulitus = true;
          tund = '$i';
          print(lulitus);
          print(i);
          graafikuSaatmine(lulitus, tund, valitudPaev);
        }
      }
    }
  }
  for (i = 0; i < 24; i++) {
    if (selected[i] == false) {
      if (i == 0) {
        lulitus = false;
        tund = '$i';
        print(lulitus);
        print(i);
        graafikuSaatmine(lulitus, tund, valitudPaev);
      } else {
        if (selected[i] != selected[i - 1]) {
          lulitus = false;
          tund = '$i';
          print(lulitus);
          print(i);
          graafikuSaatmine(lulitus, tund, valitudPaev);
        }
      }
    }
  }
}

graafikuSaatmine(bool lulitus, String tund, valitudPaev) async {
  print(valitudPaev);
  DateTime now = DateTime.now();
  print(now.weekday);
  var nadalapaev;
  if (valitudPaev == 'täna') {
    nadalapaev = now.weekday;
  }
  if (valitudPaev == 'homme') {
    var homme = now.add(Duration(days: 1));
    nadalapaev = homme.weekday;
  }

  if (nadalapaev == 1) {
    nadalapaev = 'MON';
  }
  if (nadalapaev == 2) {
    nadalapaev = 'TUE';
  }
  if (nadalapaev == 3) {
    nadalapaev = 'WED';
  }
  if (nadalapaev == 4) {
    nadalapaev = 'THU';
  }
  if (nadalapaev == 5) {
    nadalapaev = 'FRI';
  }
  if (nadalapaev == 6) {
    nadalapaev = 'SAT';
  }
  if (nadalapaev == 7) {
    nadalapaev = 'SUN';
  }

  String token = await getToken();
  var headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  var data = {
    'id': '30c6f7828098',
    'method': 'schedule.create',
    'params':
        '{"enable":true,"timespec":"0 0 $tund * * $nadalapaev","calls":[{"method":"Switch.Set","params":{"id":0,"on":$lulitus}}]}',
  };

  var url = Uri.parse(
      'https://shelly-64-eu.shelly.cloud/fast/device/gen2_generic_command');
  var res = await http.post(url, headers: headers, body: data);
  if (res.statusCode != 200)
    throw Exception('http.post error: statusCode= ${res.statusCode}');
  print('lopp');
  print(res.body);
}

graafikuKustutamine(Map<String, dynamic> graafikud) async {
  DateTime now = DateTime.now();
  print(now.weekday);
  var nadalapaev;
  var nadalapaevhomme;

  nadalapaev = now.weekday;

  var homme = now.add(Duration(days: 1));
  nadalapaevhomme = homme.weekday;

  if (nadalapaev == 1) {
    nadalapaev = 'MON';
  }
  if (nadalapaev == 2) {
    nadalapaev = 'TUE';
  }
  if (nadalapaev == 3) {
    nadalapaev = 'WED';
  }
  if (nadalapaev == 4) {
    nadalapaev = 'THU';
  }
  if (nadalapaev == 5) {
    nadalapaev = 'FRI';
  }
  if (nadalapaev == 6) {
    nadalapaev = 'SAT';
  }
  if (nadalapaev == 7) {
    nadalapaev = 'SUN';
  }
  if (nadalapaevhomme == 1) {
    nadalapaevhomme = 'MON';
  }
  if (nadalapaevhomme == 2) {
    nadalapaevhomme = 'TUE';
  }
  if (nadalapaevhomme == 3) {
    nadalapaevhomme = 'WED';
  }
  if (nadalapaevhomme == 4) {
    nadalapaevhomme = 'THU';
  }
  if (nadalapaevhomme == 5) {
    nadalapaevhomme = 'FRI';
  }
  if (nadalapaevhomme == 6) {
    nadalapaevhomme = 'SAT';
  }
  if (nadalapaevhomme == 7) {
    nadalapaevhomme = 'SUN';
  }
  print(nadalapaevhomme);
  print(nadalapaev);
  var j = 1;
  for (var i in graafikud.keys) {
    var k = 0;
    print(i);
    print(graafikud['$j'].toString());
    if (graafikud['$j'].toString().contains('$nadalapaev') ||
        graafikud['$j'].toString().contains('$nadalapaevhomme')) {
      k = 1;
    } else {
      print("delete $j");
      String token = await getToken();
      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      var data = {
        'id': '30c6f7828098',
        'method': 'schedule.delete',
        'params': '{"id":$i}',
      };

      var url = Uri.parse(
          'https://shelly-64-eu.shelly.cloud/fast/device/gen2_generic_command');
      var res = await http.post(url, headers: headers, body: data);
      if (res.statusCode != 200)
        throw Exception('http.post error: statusCode= ${res.statusCode}');
      print(res.body);
    }

    j++;
  }
}
