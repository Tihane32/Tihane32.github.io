import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'Elering.dart';
import 'package:testuus4/funktsioonid/Elering.dart';
import '../funktsioonid/CurrentPrice.dart';
import 'Graafik.dart';
import 'OnOff.dart';
import 'Login.dart';
import 'kaksTabelit.dart';
import 'koduleht.dart';

//Defineerime hinnagraafiku lehe

class HinnaGraafik extends StatefulWidget {
  @override
  _HinnaGraafikState createState() => _HinnaGraafikState();
}

class _HinnaGraafikState extends State<HinnaGraafik> {
  List<dynamic> data = [];

  int koduindex =
      2; //Määrab bottom navigatsion baris sinise märgiga hetke asukoha

  String hetkepaev = '';

  List<dynamic> kiri = [];

  @override
  void initState() {
    super.initState();

    _getData();
  }

  Future<void> _getData() async {
    //Määrame mis päeva näitame

    String paev1 = 'homme';

    DateTime now = new DateTime.now();

    var date = new DateTime(now.year, now.month, now.day, now.hour);

    //Kui kell on vähem, kui 15 siis kuvab tänast päeva

    if (date.hour < 15) {
      date = now.add(new Duration(days: -1));

      paev1 = 'täna';
    }

    setState(() {
      hetkepaev = paev1; //Ütleb, mis tekst lehele tuleb. Kas homme või täna.
    });

    //saame Elergini API kaudu hinnagraafiku

    var temp = await getElering(
        paev1); //Kutsume Eleringi funktsiooni ja ütleme, mis päeva hinda me tahame

    setState(() {
      data = temp; //Annab datale hinnagraafiku
    });

    //Siit algab esimese seadme lülitusgraafiku otsimine

    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> users = prefs.getStringList('users') ??
        []; //Kutsub mälust "users" kohal olevad väärtused

    List<String> kasutajaTunnus = users[0].split(
        ','); //Teeb esimesel kohal oleva väärtuse koma juures pooleks. Sest id ja key on eraldatud komaga.

    //Küsib seadmelt lülitusgraafikut

    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    var data3 = {
      'channel': '0',
      'id': kasutajaTunnus[0].toString(),
      'auth_key': kasutajaTunnus[1].toString(),
    };

    var url3 = Uri.parse('https://shelly-64-eu.shelly.cloud/device/settings');

    var res = await http.post(url3, headers: headers, body: data3);

    //Kui post läheb läbi siis:

    if (res.statusCode == 200) {
      final httpPackageJson3 = json.decode(res.body) as Map<String, dynamic>;

      final scheduleRules1 = httpPackageJson3['data']['device_settings']
          ['relays'][0]['schedule_rules']; //Lülitusgraafiku asukoht Mapis

      var onoff = [];

      onoff.length = 24;

      for (var i = 0; i < 24; i++) {
        onoff[i] = ''; //Algväärtusab on/off kohad hinnagraafikul
      }

      List<String> newList = [];

      for (String item
          in scheduleRules1) //Iga lülituskäsu kohta teeb ühe loopi.

      {
        List<String> parts = item.split(
            '-'); //Eraldab lülituskäsu - juures lahti. Nt 2000-1-on muutub 2000 1 on, kus parts[0] on "2000", parts[1] on "1" ja parts[2] on "on".

        if (parts[1].length >
            1) //Kui parts[1] on suurem, kui ühekohaline arv, siis läheb edasi
        {
          for (int i = 0;
              i < parts[1].length;
              i++) //Iga parts[1] arvu kohta teeb ühe loopi.
          {
            String newItem = '${parts[0]}-${parts[1][i]}-${parts[2]}';

            newList.add(newItem);
          }
        } else {
          newList.add(item);
        }
      }

      var homnepaev = now.add(new Duration(days: 1));

      if (date.hour < 15) {
        homnepaev = now.add(new Duration(days: 0));
      }

      List<String> filteredRules = [];

      int paevasendus = homnepaev.weekday;

      paevasendus = paevasendus - 1;

      RegExp regExp = RegExp("-$paevasendus-");

      for (var rule in newList) {
        if (regExp.hasMatch(
            rule)) //Kui lülituskäsus on nõutud päev lisatakse see uuele stringile. Nt kui on teisipäev, ehk päev 1,
        //ja lülitusgraafikus on "2000-2-on, 2000-3-on", siis järgi ainult 2000-2-on.
        {
          filteredRules.add(rule);
        }
      }

      //Siit hakkab vaatama mis kellaajal on "on" ja millal "off"
      for (String item
          in filteredRules) //iga lülituskäsu kohta, mis on lülitusgraafikus teeb ühe loopi
      {
        List<String> parts = item.split(
            '-'); //eraldab lülituskäsu - juurtes, ehk teeb lülituskäsu kolmeks osaks

        for (var i = 0; i < 24; i++) {
          String j = i.toString();

          if (i < 10) //see on kellaaja koostamine
          {
            j = '0' + j + '00';
          } else {
            j = j + '00';
          }

          if (parts[0] ==
              j) //Kui lülituskäsu esimene osa, ehk parts[0], on võrdne hetke loopi j-ga(kellaajaga), läheb edasi
          {
            //Kui lülitukäsu kolmas osa, ehk parts[2], on "on" või "off", määrab samale kohale sõna on või off
            if (parts[2] == 'on') {
              onoff[i] = 'on';
            }

            if (parts[2] == 'off') {
              onoff[i] = 'off';
            }
          }

          if (onoff[i] == null) {
            onoff[i] = '';
          }
        }
      }

      setState(() {
        kiri = onoff; // on/off väärtused lähevad Hinnagraafiku lehele.
      });
    }
  }

  //Hinnagraafiku lehe ülesehitus

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[600],
          title: const Text('Shelly pistik'),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: DataTable(
              columns: [
                DataColumn(
                  label: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 9),
                        child: Text(
                          '$hetkepaev kuupäev',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      Text(
                        'Aasta/kuu/päev tund',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                DataColumn(
                  label: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 9),
                        child: Text(
                          'On/Off',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                ),
                DataColumn(
                  label: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 9),
                        child: Text(
                          'Hind',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      Text(
                        '€/MWh',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              rows: data.map((row) {
                var timestamp = DateTime.fromMillisecondsSinceEpoch(
                    row['timestamp'] * 1000);

                String timestamp1 =
                    DateFormat('yyyy/MM/dd HH').format(timestamp);

                final value = row['price'];

                final index = data.indexOf(row);

                final asendus = kiri.length > index ? kiri[index] : '';

                return DataRow(cells: [
                  DataCell(Text(
                    "$timestamp1:00",
                    style: TextStyle(fontSize: 17),
                  )),
                  DataCell(Text(
                    '$asendus',
                    style: TextStyle(fontSize: 17),
                  )),
                  DataCell(Text(
                    '$value',
                    style: TextStyle(fontSize: 17),
                  )),
                ]);
              }).toList(),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.red[600],
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: 'Teie seade',
              icon: Icon(Icons.electrical_services_rounded),
            ),
            BottomNavigationBarItem(
              label: 'Kodu',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: 'Hinnagraafik',
              icon: Icon(Icons.table_rows_outlined),
            ),
          ],
          currentIndex: koduindex,
          onTap: (int index) {
            if (index == 1) {
              Navigator.push(
                //Kui vajutatakse kodu ikooni peale, siis viiakse KoduLeht lehele
                context,
                MaterialPageRoute(builder: (context) => const KoduLeht()),
              );
            } else if (index == 0) {
              Navigator.push(
                //Kui vajutatakse Teie seadmed ikooni peale, siis viiakse Seadmetelisamine lehele
                context,
                MaterialPageRoute(builder: (context) => MinuSeadmed()),
              );
            }
          },
        ));
  }
}