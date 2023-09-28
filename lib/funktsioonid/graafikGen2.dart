import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'token.dart';
import 'package:intl/intl.dart';

gen2GraafikuLoomine(var selected, var valitudPaev, String value) async {
  var graafikud = Map<String, dynamic>();
  List temp = List.empty(growable: true);
  await graafikuteSaamine(graafikud, value, temp, valitudPaev);

  await graafikuloomine(graafikud, selected, valitudPaev, value);

  await delete(value, temp);
}

graafikuteSaamine(Map<String, dynamic> graafikud, String value, List temp,
    valitudPaev) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? ajutineKasutajanimi = prefs.getString('Kasutajanimi');
  String? sha1Hash = prefs.getString('Kasutajaparool');

  String token = await getToken();
  var headers = {
    'Authorization': 'Bearer $token',
  };

  var data = {
    'id': value,
    'method': 'schedule.list',
  };

  var url = Uri.parse(
      'https://shelly-64-eu.shelly.cloud/fast/device/gen2_generic_command');
  var res = await http.post(url, headers: headers, body: data);
  if (res.statusCode == 200) {
    var resJSON = jsonDecode(res.body) as Map<String, dynamic>;
    if (resJSON == null) {
      return; // stop the function if resJSON is null
    }
    var jobs = resJSON['data']['jobs'];
    if (jobs == null) {
      // handle the case where jobs is null
      return;
    }
    jobs = resJSON['data']['jobs'] as List<dynamic>;
    int k = 0;
    for (var job in jobs) {
      DateTime now = DateTime.now();
      if (valitudPaev == 'homme') {
        now = now.add(Duration(days: 1));
      }

      // Create a DateFormat instance to format the date
      DateFormat dateFormat =
          DateFormat('EEE'); // 'EEE' gives the abbreviated weekday name

      // Format the current date to get the weekday abbreviation (e.g., "MON," "TUE," etc.)
      String formattedWeekday = dateFormat.format(now);
      formattedWeekday = formattedWeekday.toUpperCase();

      String date = job['timespec'].split(" ")[5];
      if (date == formattedWeekday) {
        var id = job['id'] as int;
        var timespec = job['timespec'] as String;
        temp.add(id);

        var calls = job['calls'] as List<dynamic>;
        var graafik = Map<String, dynamic>();
        for (var call in calls) {
          var params = call['params']['on'];

          graafik['Timespec'] = timespec;
          graafik['On/Off'] = params;
          graafikud['$id'] = graafik;
        }
      }
      k++;
    }
  }
}

graafikuloomine(
    Map<String, dynamic> graafikud, selected, valitudPaev, String value) async {
  var j = 1;

  var i = 0;
  bool lulitus;
  String tund;
  for (i = 0; i < 24; i++) {
    if (selected[i][2] == true) {
      if (i == 0) {
        lulitus = true;
        tund = '$i';
        graafikuSaatmine(lulitus, tund, valitudPaev, value);
      } else {
        if (selected[i][2] != selected[i - 1][2]) {
          lulitus = true;
          tund = '$i';
          graafikuSaatmine(lulitus, tund, valitudPaev, value);
        }
      }
    }
  }
  for (i = 0; i < 24; i++) {
    if (selected[i][2] == false) {
      if (i == 0) {
        lulitus = false;
        tund = '$i';
        graafikuSaatmine(lulitus, tund, valitudPaev, value);
      } else {
        if (selected[i - 1][2] == true) {
          lulitus = false;
          tund = '$i';
          graafikuSaatmine(lulitus, tund, valitudPaev, value);
        }
      }
    }
  }
}

graafikuSaatmine(bool lulitus, String tund, valitudPaev, String value) async {
  DateTime now = DateTime.now();
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
    'id': value,
    'method': 'schedule.create',
    'params':
        '{"enable":true,"timespec":"0 0 $tund * * $nadalapaev","calls":[{"method":"Switch.Set","params":{"id":0,"on":$lulitus}}]}',
  };
  var url = Uri.parse(
      'https://shelly-64-eu.shelly.cloud/fast/device/gen2_generic_command');
  var res = await http.post(url, headers: headers, body: data);
  if (res.statusCode != 200)
    throw Exception('http.post error: statusCode= ${res.statusCode}');
}

graafikuKustutamine(Map<String, dynamic> graafikud, String value) async {
  DateTime now = DateTime.now();
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
  var j = 1;
  for (var i in graafikud.keys) {
    var k = 0;
    if (graafikud['$j'].toString().contains('$nadalapaev') ||
        graafikud['$j'].toString().contains('$nadalapaevhomme')) {
      k = 1;
    } else {
      String token = await getToken();
      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      var data = {
        'id': value,
        'method': 'schedule.delete',
        'params': '{"id":$i}',
      };

      var url = Uri.parse(
          'https://shelly-64-eu.shelly.cloud/fast/device/gen2_generic_command');
      var res = await http.post(url, headers: headers, body: data);
      if (res.statusCode != 200)
        throw Exception('http.post error: statusCode= ${res.statusCode}');
    }

    j++;
  }
}

Future<Map<int, dynamic>> gen2GraafikSaamine(
    String value, Map<int, dynamic> onOff, String paev) async {
  String token = await getToken();
  var graafikud = Map<int, dynamic>();
  var headers = {
    'Authorization': 'Bearer $token',
  };

  var data = {
    'id': value,
    'method': 'schedule.list',
  };

  var url = Uri.parse(
      'https://shelly-64-eu.shelly.cloud/fast/device/gen2_generic_command');
  var res = await http.post(url, headers: headers, body: data);
  if (res.statusCode == 200) {
    var resJSON = jsonDecode(res.body) as Map<String, dynamic>;

    var jobs = resJSON['data']['jobs'];
    if (resJSON['data']['jobs'] == null) {
      jobs = {};
    }else{jobs = resJSON['data']['jobs'] as List<dynamic>;}

    
    int k = 0;
    for (var job in jobs) {
      var id = job['id'] as int;
      var timespec = job['timespec'] as String;
      var calls = job['calls'] as List<dynamic>;
      var graafik = Map<String, dynamic>();

      for (var call in calls) {
        var params = call['params']['on'];

        graafik['Timespec'] = timespec;
        graafik['On/Off'] = params;
      }
      graafikud[k] = graafik;
      k++;
    }
    List abi = List.empty(growable: true);
    DateTime now = DateTime.now();
    if (paev == 'homme') {
      now = now.add(Duration(days: 1));
    }

    // Create a DateFormat instance to format the date
    DateFormat dateFormat =
        DateFormat('EEE'); // 'EEE' gives the abbreviated weekday name

    // Format the current date to get the weekday abbreviation (e.g., "MON," "TUE," etc.)
    String formattedWeekday = dateFormat.format(now);
    formattedWeekday = formattedWeekday.toUpperCase();
    for (var i = 0; i < graafikud.length; i++) {
      var temp = graafikud[i]['Timespec'];
      // print(temp);
      int hour = int.parse(temp.split(" ")[2]);
      String date = temp.split(" ")[5];
      // Update boolean value in hourDataMap if the hour exists
      if (onOff.containsKey(hour)) {
        if (formattedWeekday == date) {
          abi.add(hour);
          onOff[hour][2] = graafikud[i]["On/Off"];
        }
      }
    }
    abi.sort();
    for (var i = 0; i < abi.length - 1; i++) {
      //print(onOff);
      int j = abi[i];

      int o = abi[i + 1];
      for (j; j < o; j++) {
        onOff[j][2] = onOff[abi[i]][2];

        //print('$onOff $i');
      }
      //print(onOff);
    }

    return onOff;
  } else {
    return onOff;
  }
}

delete(value, List temp) async {
  for (var i = 0; i < temp.length; i++) {
    String token = await getToken2();

    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    var data = {
      'id': value,
      'method': 'schedule.delete',
      'params': '{"id":${temp[i]}}',
    };

    var url = Uri.parse(
        'https://shelly-64-eu.shelly.cloud/fast/device/gen2_generic_command');
    var res1 = await http.post(url, headers: headers, body: data);
  }
}
