import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  var graafikud = Map<String, dynamic>();
  await graafikuteSaamine(graafikud);
  print(graafikud);
}

graafikuteSaamine(Map<String, dynamic> graafikud) async {
  var headers = {
    'Authorization':
        'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJwd2QiLCJpYXQiOjE2ODI1Mjk3NDcsInVzZXJfaWQiOiIxNTE0MDQ0Iiwic24iOiIxIiwidXNlcl9hcGlfdXJsIjoiaHR0cHM6XC9cL3NoZWxseS02NC1ldS5zaGVsbHkuY2xvdWQiLCJuIjo4NzQ5LCJleHAiOjE2ODI2MTYxNDd9.SV0T6T8CgTfJJ40qBgCtyRJ1owqgxTfkPXUgW-uooDQ',
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
