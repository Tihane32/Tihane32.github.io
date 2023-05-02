/*
Trevor Uuna, Jaakob Lambot 27.03.2023
TalTech
*/

import 'package:flutter/material.dart';
import '../funktsioonid/graafikGen2.dart';
import 'Kontroll.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Graafik extends StatelessWidget {
  final List<bool> selected;
  final String valitudPaev;

  Graafik({Key? key, required this.selected, required this.valitudPaev})
      : super(key: key);

  void sendDataToURL() async {
    int k = 0;
    DateTime now = DateTime.now();
    int tundtana = now.hour;
    var homnenadalapaev = now.add(Duration(days: 1));
    int nadalapaevtana = homnenadalapaev.weekday - 2;

    //kui kell on vahem kui 15:00 või on valitud päev täna
    if (now.hour < 15 || valitudPaev == 'täna') {
      homnenadalapaev = now.add(Duration(days: 0));
      nadalapaevtana = homnenadalapaev.weekday - 1;
      k = 1;
    }
    int nadalapaev = homnenadalapaev.weekday - 1;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> users = prefs.getStringList('users') ??
        []; //Võtab mälust 'users'-i asukohast väärtused
    List<String> vastus = [];
    final success = await prefs
        .remove('vastus'); //Kustutab mälus 'vastus' eelnevad väärtused ära

    for (var i = 0; i < users.length; i++) //Teeb iga seadme kohta ühe loopi
    {
      //
      //TODO: Siia if gen2 et läheks graafikGen2 faili. Peab selected ja valitudPaev edasi passima
      //
      gen2GraafikuLoomine(selected, valitudPaev);
      List<String> kasutajaTunnused = users[i].split(
          ','); //Teeb koma juures pooleks sest iga seadme id ja key on eraldatud komaga
      var test = Map();

      String graafik = '';

      //järgnevat tehakse kui moodustatakse homset graafikut
      //all olev osa on selleks, et homse graafiku moodustamisel ei kaoks ära tänase päeva graafik
      if (k == 0) {
        var headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
        };

        var data = {
          'channel': '0',
          'id': kasutajaTunnused[0].toString(),
          'auth_key': kasutajaTunnused[1].toString(),
        };

        var url =
            Uri.parse('https://shelly-64-eu.shelly.cloud/device/settings');
        var res = await http.post(url, headers: headers, body: data);
        await Future.delayed(const Duration(seconds: 3));
        //Kui post läheb läbi siis:
        if (res.statusCode == 200) {
          final httpPackageJson = json.decode(res.body) as Map<String, dynamic>;

          final scheduleRules1 = httpPackageJson['data']['device_settings']
              ['relays'][0]['schedule_rules'];
          await Future.delayed(const Duration(
              seconds:
                  3)); //delay on selleks, sest Shelly võib muidu liiga palju kutseid saada lühikese aja jooksul
          List<String> newList = [];

          for (String item in scheduleRules1) {
            List<String> parts = item.split('-');
            if (parts[1].length > 1) {
              for (int i = 0; i < parts[1].length; i++) {
                //lülituskäsk tehakse iga "-" juures pooleks ja lisatakse eraldi listi
                String newItem = '${parts[0]}-${parts[1][i]}-${parts[2]}';
                newList.add(newItem);
              }
            } else {
              newList.add(item);
            }
          }

          List<String> filteredRules = [];

          RegExp regExp = RegExp("-$nadalapaevtana-");

          for (var rule in newList) {
            if (regExp.hasMatch(rule)) {
              filteredRules.add(rule);
            }
          }

          String filteredRulesStr =
              filteredRules.join(", ").replaceAll(' ', '');
          graafik = filteredRulesStr.toString();

          if (graafik != '') {
            List<String> myList = graafik.split(',');

            //Kui muudetakse tänase päeva graafikut eemaldatakse need tunnid, mis on juba möödas.
            //Seda tehakse sellepärast, et shellyl on piiratud arv graafikuid, mis ta saab salvestada.
            List<String> filteredList = myList
                .where(
                    (string) => int.parse(string.substring(0, 2)) >= tundtana)
                .toList();

            graafik = filteredList.join(',');
            graafik = '$graafik,';
          }
        }
      }
      for (var i = 0; i < 24; i++) {
        if (selected[i] == true) {
          test[i] = 'on';
        }
        if (selected[i] == false) {
          test[i] = 'off';
        }
      }
      //Graafiku Stringi üles ehitamine
      for (var i = 0; i < 24; i++) {
        String nullnull = '00';

        if (i < 10) {
          nullnull = '0$i$nullnull';
        }
        if (i >= 10) {
          nullnull = '$i$nullnull';
        }
        if (test[i] != test[i - 1]) {
          graafik = graafik +
              nullnull +
              '-' +
              nadalapaev.toString() +
              '-' +
              test[i] +
              ',';
        }
      }
      if (graafik.endsWith(',')) {
        graafik = graafik.substring(0, graafik.length - 1);
      }
      if (graafik.startsWith(',')) {
        graafik = graafik.substring(1);
      }

      //Kui muudetakse tänase päeva graafikut, tehakse see võimalikult lühikeseks
      //Seda tehakse sellepärast, et shellyl on piiratud arv graafikuid, mis ta saab salvestada.
      if (k == 1) {
        List<String> myList = graafik.split(',');

        List<String> filteredList = myList
            .where((string) => int.parse(string.substring(0, 2)) >= tundtana)
            .toList();

        graafik = filteredList.join(',');
      }
      await Future.delayed(const Duration(seconds: 1));
      var headers1 = {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      var data1 = {
        'channel': '0',
        'enabled': "1",
        'schedule_rules': graafik,
        'id': kasutajaTunnused[0].toString(),
        'auth_key': kasutajaTunnused[1].toString(),
      };

      var url1 = Uri.parse(
          'https://shelly-64-eu.shelly.cloud/device/relay/settings/schedule_rules');
      var res1 = await http.post(url1, headers: headers1, body: data1);
      print(graafik);
      print(res1.body);
      vastus.add(res1.body);
      await Future.delayed(const Duration(seconds: 1));
    }

    await prefs.setStringList('vastus', vastus);
    String asendus = now.toString();
    await prefs.setString('Aeg', now.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Graafik'),
        actions: [
          IconButton(
            icon: Icon(Icons.navigate_next),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Kontroll()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                sendDataToURL();
              },
              child: Text(
                'Kinnitus',
                style: TextStyle(fontSize: 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
