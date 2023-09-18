/*
Trevor Uuna, Jaakob Lambot 27.03.2023
TalTech
*/
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void onoff(String onoff) async {
  //Kõikide Shellyde on/off lülitamine

  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> users = prefs.getStringList('users') ??
      []; //Võtab mälust 'users'-i asukohast väärtused
  for (var i = 0;
      i < users.length;
      i++) //nii mitu elementi usersis(ehk mitu seadet on) on nii mitu loopi teeb.
  {
    List<String> id = users[i].split(
        ','); //Teeb koma juures pooleks sest iga seadme id ja key on eraldatud komaga

    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    var data = {
      'channel': '0',
      'turn': onoff,
      'id': id[0].toString(),
      'auth_key': id[1].toString(),
    };

    var url =
        Uri.parse('https://shelly-64-eu.shelly.cloud/device/relay/control');
    var res = await http.post(url, headers: headers, body: data);
  }
}
