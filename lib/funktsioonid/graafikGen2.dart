import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'token.dart';
import 'package:intl/intl.dart';
import 'package:testuus4/main.dart';

/// The function `gen2GraafikuLoomine` creates and deletes schedules for a device based on selected
/// values and user preferences.
///
/// Args:
///   selected: A list of lists representing the selected hours for creating a schedule. Each inner list
/// contains three elements: the hour (0-23), a boolean value indicating whether the hour is selected or
/// not, and a boolean value indicating whether the hour is toggled on or off.
///   valitudPaev: The parameter "valitudPaev" is a string that represents the selected day. It can have
/// two possible values: "täna" (today) or "homme" (tomorrow).
///   value (String): The value parameter is a string that represents a specific value or identifier. It
/// is used in various parts of the code to retrieve or manipulate data related to that value.
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

  String token = await getToken2();
  var headers = {
    'Authorization': 'Bearer $token',
  };

  var data = {
    'id': value,
    'method': 'schedule.list',
  };

  var url = Uri.parse(
      '${seadmeteMap[value]['api_url']}/fast/device/gen2_generic_command');
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
      '${seadmeteMap[value]['api_url']}/fast/device/gen2_generic_command');
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
          '${seadmeteMap[value]['api_url']}/fast/device/gen2_generic_command');
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
      '${seadmeteMap[value]['api_url']}/fast/device/gen2_generic_command');
  var res = await http.post(url, headers: headers, body: data);
  if (res.statusCode == 200) {
    var resJSON = jsonDecode(res.body) as Map<String, dynamic>;

    var jobs = resJSON['data']['jobs'];
    if (resJSON['data']['jobs'] == null) {
      jobs = {};
    } else {
      jobs = resJSON['data']['jobs'] as List<dynamic>;
    }

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
        '${seadmeteMap[value]['api_url']}/fast/device/gen2_generic_command');
    var res1 = await http.post(url, headers: headers, body: data);
    print(res1.body);
    await Future.delayed(const Duration(seconds: 2));
  }
}

graafikGen2Lugemine(String id) async {
  List<dynamic> tuhiGraafik = List.empty(growable: true);
  String token = await getToken2();
  var headers = {
    'Authorization': 'Bearer $token',
  };

  var data = {
    'id': id,
    'method': 'schedule.list',
  };

  var url = Uri.parse(
      '${seadmeteMap[id]['api_url']}/fast/device/gen2_generic_command');
  var res = await http.post(url, headers: headers, body: data);
  if (res.statusCode == 200) {
    var resJSON = jsonDecode(res.body) as Map<String, dynamic>;
    if (resJSON == null) {
      return; // stop the function if resJSON is null
    }
    tuhiGraafik = resJSON['data']['jobs'];
    if (tuhiGraafik == null) {
      // handle the case where jobs is null
      return;
    }
    tuhiGraafik = resJSON['data']['jobs'] as List<dynamic>;
    print(tuhiGraafik);
  }

  return tuhiGraafik;
}

graafikGen2ToGraafikGen1(List<dynamic> graafik) {
  List<String> result = [];

  // Define a map to convert day names to their corresponding numbers
  final dayMap = {
    'MON': 0,
    'TUE': 1,
    'WED': 2,
    'THU': 3,
    'FRI': 4,
    'SAT': 5,
    'SUN': 6,
  };

  // Iterate through the job entries
  for (var job in graafik) {
    if (job is Map && job.containsKey('timespec') && job.containsKey('calls')) {
      String timespec = job['timespec'];
      List<String> timespecParts = timespec.split(' ');

      // Extract the relevant components
      if (timespecParts.length == 6) {
        String time = timespecParts[2];
        String day = timespecParts[5];
        String switchState = job['calls'][0]['params']['on'] ? 'on' : 'off';

        // Convert the day name to a number using the dayMap
        int? dayNumber = dayMap[day];
        print(int.parse(time));
        if (int.parse(time) < 10) {
          time = "0${time}00";
        } else {
          time = "${time}00";
        }
        // Create the formatted string and add it to the result list
        String formattedJob = '$time-$dayNumber-$switchState';
        result.add(formattedJob);
      }
    }
  }
  print("reuslt");
  print(result);
  // Join the result list into a single string using commas
  return result;
}

graafikGen1ToGraafikGen2(List<dynamic> graafik) {
  String graafikString = graafik.join(", ");

  final dayMap = {
    0: 'MON',
    1: 'TUE',
    2: 'WED',
    3: 'THU',
    4: 'FRI',
    5: 'SAT',
    6: 'SUN',
  };

  // Split the input string by commas to get individual job entries
  List<String> entries = graafikString.split(', ');
  List<String> jobs = List.empty(growable: true);
  for (var entry in entries) {
    // Split each entry by the dash '-' to get its components
    List<String> parts = entry.split('-');

    if (parts.length == 3) {
      String time = parts[0];
      int dayNumber = int.parse(parts[1]);
      bool switchState = parts[2] == 'on' ? true : false;

      // Convert the day number to the corresponding day name using the dayMap
      String? day = dayMap[dayNumber];

      // Create a map for the job and add it to the result list

      if (time[0] == "0") {
        time = time.substring(1, 2);
      } else {
        time = time.substring(0, 2);
      }
      jobs.add({
        '"enable":true,"timespec":"0 0 $time * * $day","calls":[{"method":"Switch.Set","params":{"id":0,"on":$switchState}}]'
      }.toString());
    }
  }

  return jobs;
}

graafikGen2DeleteAll(String id) async {
  List<dynamic> graafik = [];
  List temp = [];
  graafik = await graafikGen2Lugemine(id);
  print("graafik delete");

  print(graafik.length);
  for (int i = 0; i < graafik.length; i++) {
    temp.add(graafik[i]["id"]);
  }
  await delete(id, temp);
}

graafikGen2SaatmineGraafikuga(List<dynamic> graafik, String key) async {
  await graafikGen2DeleteAll(key);
  String token = await getToken2();
  print("graafikgen2 $graafik");
  for (int i = 0; i < graafik.length; i++) {
    print(graafik[i]);
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    var data = {
      'id': key,
      'method': 'schedule.create',
      'params': '${graafik[i]}',
    };
    var url = Uri.parse(
        '${seadmeteMap[key]['api_url']}/fast/device/gen2_generic_command');
    var res = await http.post(url, headers: headers, body: data);
    print(res.body);
  }
}
