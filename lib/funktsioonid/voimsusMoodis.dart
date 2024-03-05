import 'dart:convert';
import 'dart:math';
import 'package:testuus4/parameters.dart';
import 'package:http/http.dart' as http;

voimsusMoodis() async {
  seadmeteMap.forEach((key, value) async {
    String ID = '';
    String KEY = '';

    ID = key;
    KEY = seadmeteMap[key]['Cloud_key'];

    var headers = {
      'Authorization': 'Bearer ${tokenMap[key]}',
    };

    var data = {
      'id': ID,
      'auth_key': KEY,
    };

    var url = Uri.parse("${seadmeteMap[ID]['api_url']}/device/status");

    var res = await http.post(url, headers: headers, body: data);

    if (res.statusCode != 200)
      throw Exception('http.post error: statusCode= ${res.statusCode}');

    Map<String, dynamic> jsonResponseMap = json.decode(res.body);

    if (jsonResponseMap.isNotEmpty) {
      if (value['Seadme_generatsioon'] as int == 1) {
        seadmeteMap[key]['Hetke_voimsus'] =
            jsonResponseMap['data']['device_status']['meters'][0]['power'];
      } else {
        seadmeteMap[key]['Hetke_voimsus'] =
            jsonResponseMap['data']['device_status']['switch:0']['apower'];
      }
    } else {
      seadmeteMap[key]['Hetke_voimsus'] = 0;
    }
    print('T: ${jsonResponseMap['data']['device_status']}');
  });
}
