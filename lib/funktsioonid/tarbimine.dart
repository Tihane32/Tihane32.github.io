import 'package:http/http.dart' as http;
import 'dart:convert';
import 'token.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future tarbimine() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  []; //Võtab mälust 'users'-i asukohast väärtused
  var seadmedJSONmap = prefs.getString('seadmed');
  //print(seadmedJSONmap);
 if(seadmedJSONmap == null) {
    return 0;
  }
  Map<String, dynamic> storedMap = json.decode(seadmedJSONmap);


  var j = 0;
  var tarbimine = 0.0;
  String token = await getToken();
  for (var i in storedMap.values) {
    //await Future.delayed(const Duration(seconds: 3));
    //print(storedMap['Seade$j']['Seadme_ID']);
    String asendus = storedMap['Seade$j']['Seadme_ID'] as String;
    //print(token);
    var headers = {
      'Authorization': 'Bearer $token',
    };
    var data = {
      'id': asendus,
      'channel': '0',
      'date_range': 'custom',
      'date_from': '2023-05-01 00:00:00',
      'date_to': '2023-05-31 23:59:59',
    };

    var url = Uri.parse(
        'https://shelly-64-eu.shelly.cloud/statistics/relay/consumption');
    var res = await http.post(url, headers: headers, body: data);
    //print(res.body);
    var resJson = json.decode(res.body) as Map<String, dynamic>;
    print(res.body);
    print(resJson['data']['total']);
    print(resJson['data']['units']['consumption']);

    if (resJson['data']['units']['consumption'] == 'Wh') {
      double ajutine = resJson['data']['total'] / 1000.0;
      tarbimine = tarbimine + ajutine;
    }else{double ajutine = resJson['data']['total']*1.0;
      tarbimine = tarbimine + ajutine;}

    //print(resJson);

    //print(resJson['data']['device_status']['switch:0']['voltage']);
    //print(resJson['data']['device_status']['switch:0']['current']);
    //print(resJson['data']['device_status']['switch:0']['pf']);
    //print(resJson['data']['device_status']['switch:0']['aenergy']);
    //await energia();
    j++;
  }
  print('lopp');
  return tarbimine;
}