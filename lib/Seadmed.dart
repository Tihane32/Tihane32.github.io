import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';

void main() async {
  String message = 'kalatraaler';

  String sha1Hash = sha1.convert(message.codeUnits).toString();

  var headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  var data = {
    'email': 'jaakob.lambot@gmail.com',
    'password': sha1Hash,
    'var': '2',
  };
  var url = Uri.parse('https://api.shelly.cloud/auth/login');
  var res = await http.post(url, headers: headers, body: data);
  var resjson = json.decode(res.body) as Map<String, dynamic>;
  var token = resjson['data']['token'];
  print(resjson);
  print(token);

  var headers1 = {
    'Authorization': 'Bearer $token',
  };

  var url1 = Uri.parse(
      'https://shelly-64-eu.shelly.cloud/interface/device/get_all_lists');
  var res1 = await http.post(url1, headers: headers1);
  var res1json = json.decode(res1.body) as Map<String, dynamic>;
  var devices = res1json['data']['devices'];
  print(devices);

  for (var device in devices.values) {
    var id = device['id'];
    var name = device['name'];
    var gen = device['gen'];
    print(id);
    print(name);
    print(gen);
  }
}
