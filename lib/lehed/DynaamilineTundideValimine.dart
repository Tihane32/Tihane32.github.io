import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/funktsioonid/graafikGen1.dart';
import 'package:testuus4/funktsioonid/graafikGen2.dart';
import 'package:testuus4/lehed/GraafikusseSeadmeteValik.dart';
import 'package:testuus4/lehed/dynamicKoduLeht.dart';
import '../funktsioonid/genMaaramine.dart';
import '../main.dart';
import '../widgets/kinnitus.dart';
import 'AbiLeht.dart';
import 'AutoTuniValik.dart';
import 'keelatudTunnid.dart';
import 'keskimiseHinnaAluselTundideValimine.dart';
import 'hinnaPiiriAluselTunideValimine.dart';
import 'kopeeeriGraafikTundideValimine.dart';
import 'package:http/http.dart' as http;

class DynamilineTundideValimine extends StatefulWidget {
  DynamilineTundideValimine(
      {Key? key,
      required this.valitudSeadmed,
      required this.i,
      required this.luba})
      : super(key: key);
  int i;
  String luba;
  var valitudSeadmed;

  @override
  _DynamilineTundideValimineState createState() =>
      _DynamilineTundideValimineState(
          valitudSeadmed: valitudSeadmed, leht: i, luba: luba);
}

int koduindex = 1;
Map<int, dynamic> lulitusMap = {
  0: ['00.00', 0, false],
  1: ['01.00', 0, false],
  2: ['02.00', 0, false],
  3: ['03.00', 0, false],
  4: ['04.00', 0, false],
  5: ['05.00', 0, false],
  6: ['06.00', 0, false],
  7: ['07.00', 0, false],
  8: ['08.00', 0, false],
  9: ['09.00', 0, false],
  10: ['10.00', 0, false],
  11: ['11.00', 0, false],
  12: ['12.00', 0, false],
  13: ['13.00', 0, false],
  14: ['14.00', 0, false],
  15: ['15.00', 0, false],
  16: ['16.00', 0, false],
  17: ['17.00', 0, false],
  18: ['18.00', 0, false],
  19: ['19.00', 0, false],
  20: ['20.00', 0, false],
  21: ['21.00', 0, false],
  22: ['22.00', 0, false],
  23: ['23.00', 0, false],
};

class _DynamilineTundideValimineState extends State<DynamilineTundideValimine> {
  _DynamilineTundideValimineState(
      {Key? key,
      required this.valitudSeadmed,
      required this.leht,
      required this.luba});
  String luba;
  int leht;
  var valitudSeadmed;
  Map<String, bool> ValitudGraafik = {};
  String selectedPage = 'Keskmine hind';
  double vahe = 10;
  int valitudTunnid = 10;
  Color boxColor = sinineKast;
  late List<Widget> lehedMenu;
  Color paev = Colors.green; // Declare the list

  @override
  void initState() {
    super.initState();

    // Initialize lehedMenu in initState
    lehedMenu = [
      KeskmiseHinnaAluselTundideValimine(
          lulitusMap: lulitusMap, updateLulitusMap: updateLulitusMap),
      HinnaPiiriAluselTundideValimine(
          lulitusMap: lulitusMap, updateLulitusMap: updateLulitusMap),
      KopeeriGraafikTundideValik(
          valitudSeadmed: valitudSeadmed,
          updateValitudSeadmed: updateValitudSeamded),
      AutoTundideValik(
          valitudSeadmed: valitudSeadmed,
          updateValitudSeadmed: updateValitudSeamded),
      KeelatudTunnid(valitudSeadmed: valitudSeadmed, luba: luba),
      AbiLeht(),
    ];
  }

  updateLulitusMap(Map<int, dynamic> updatedMap, Color updatedPaev) {
    setState(() {
      lulitusMap = updatedMap;
      print("uus paev");
      print(updatedPaev);
      paev = updatedPaev;
    });
  }

  updateValitudSeamded(Map<String, bool> ValitudGraafikuus) {
    setState(() {
      ValitudGraafik = ValitudGraafikuus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 115, 162, 195),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Juhtimine'),
          ],
        ),
        actions: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: boxColor,
              ),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButton<String>(
                icon: Icon(Icons.menu),
                value: selectedPage,
                style: font,
                dropdownColor: sinineKast,
                borderRadius: borderRadius,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedPage = newValue!;
                  });
                  if (selectedPage == 'Keskmine hind') {
                    leht = 0;
                  } else if (selectedPage == 'Hinnapiir') {
                    leht = 1;
                  } else if (selectedPage == 'Kopeeri graafik') {
                    leht = 2;
                  } else if (selectedPage == 'Automaatne') {
                    leht = 3;
                  } else if (selectedPage == 'Minu eelistused') {
                    leht = 5;
                  }
                },
                underline: Container(), // or SizedBox.shrink()
                items: <String>[
                  'Keskmine hind',
                  'Hinnapiir',
                  'Kopeeri graafik',
                  'Automaatne',
                  'Minu eelistused',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: font,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: leht,
        children: lehedMenu,
      ),
      bottomNavigationBar: SizedBox(
        height: navBarHeight,
        child: Stack(
          children: [
            Positioned(
              top: -5,
              left: 0,
              right: 0,
              child: leht == 4
                  ? Container(
                      height: 60,
                      color: Color.fromARGB(255, 115, 162, 195),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.check_circle_outline_outlined,
                              size: 30,
                              color: Color.fromARGB(255, 157, 214, 171),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DynamilineTundideValimine(
                                          valitudSeadmed: valitudSeadmed,
                                          i: 3,
                                          luba: ''),
                                ),
                              );
                            },
                          ),
                          Text(
                            ' Kinnita',
                            style: TextStyle(
                                color: Color.fromARGB(255, 157, 214, 171)),
                          )
                        ],
                      ),
                    )
                  : BottomNavigationBar(
                      backgroundColor: Color.fromARGB(255, 115, 162, 195),
                      fixedColor: Color.fromARGB(255, 157, 214, 171),
                      unselectedItemColor: Colors.white,
                      selectedIconTheme: IconThemeData(size: 40),
                      unselectedIconTheme: IconThemeData(size: 30),
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          label: 'Seadmed',
                          icon: Icon(
                            Icons.list_outlined,
                            size: 30,
                          ),
                        ),
                        BottomNavigationBarItem(
                          label: 'Kinnita',
                          icon: Icon(
                            Icons.check_circle_outlined,
                            size: 30,
                          ),
                        ),
                      ],
                      currentIndex: koduindex,
                      onTap: (int kodu) {
                        setState(() {
                          koduindex = kodu;
                          if (koduindex == 0) {
                            Navigator.push(
                              //Kui vajutatakse Hinnagraafiku ikooni peale, siis viiakse Hinnagraafiku lehele
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SeadmeteListValimine()),
                            );
                          } else if (koduindex == 1) {
                            if (selectedPage == "Kopeeri graafik") {
                              print("siin2");
                              graafikuKopeerimine(
                                  ValitudGraafik, valitudSeadmed);
                            } else {
                              graafikuteSaatmine(
                                  valitudSeadmed, lulitusMap, paev);
                            }
                            Kinnitus(
                              context,
                              'Graafik seadmetele saadetud',
                            );
                            HapticFeedback.vibrate();
                            Future.delayed(Duration(seconds: 5), () {
                              Navigator.of(context)
                                  .pop(); // Close the AlertDialog
                              Navigator.push(
                                //Kui vajutatakse Teie seade ikooni peale, siis viiakse Seadmetelisamine lehele
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DynaamilenieKoduLeht(
                                          i: 1,
                                        )),
                              );
                            });
                          }
                        });
                      }),
            ),
          ],
        ),
      ),
    );
  }
}

graafikuteSaatmine(Map<String, bool> valitudSeadmed,
    Map<int, dynamic> lulitusMap, Color paev) async {
  String valitudPaev = "homme";
  if (paev == Colors.green) {
    valitudPaev = "täna";
  }
  valitudSeadmed.forEach((key, value) async {
    if (value == true) {
      if (seadmeteMap[key]['Seadme_generatsioon'] == 1) {
        await gen1GraafikLoomine(lulitusMap, valitudPaev, key);
      } else {
        await gen2GraafikuLoomine(lulitusMap, valitudPaev, key);
      }
    }
  });
}

graafikuKopeerimine(
    Map<String, bool> valitudGraafik, Map<String, bool> valitudSeadmed) async {
  //Graafiku saamise osa
  var scheduleRules1;
  valitudGraafik.forEach((key, value) async {
    if (value == true) {
      if (seadmeteMap[key]['Seadme_generatsioon'] == 1) {
        var headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
        };

        var data = {
          'channel': '0',
          'id': key,
          'auth_key': seadmeteMap[key]['Cloud_key'],
        };

        var url = Uri.parse('${seadmeteMap[key]['api_url']}/device/settings');
        var res = await http.post(url, headers: headers, body: data);
        await Future.delayed(const Duration(seconds: 2));
        //Kui post läheb läbi siis:

        final httpPackageJson = json.decode(res.body) as Map<String, dynamic>;

        scheduleRules1 = httpPackageJson['data']['device_settings']['relays'][0]
            ['schedule_rules'];
        print(scheduleRules1);
      }
    }
  });
  //Graafiku saatmise osa
  valitudSeadmed.forEach((key, value) async {
    if (value == true) {
      if (seadmeteMap[key]['Seadme_generatsioon'] == 1) {
        var headers1 = {
          'Content-Type': 'application/x-www-form-urlencoded',
        };

        var data1 = {
          'channel': '0',
          'enabled': "1",
          'schedule_rules': scheduleRules1.toString(),
          'id': key,
          'auth_key': seadmeteMap[key]['Cloud_key'],
        };

        var url1 = Uri.parse(
            '${seadmeteMap[key]['api_url']}/device/relay/settings/schedule_rules');
        var res1 = await http.post(url1, headers: headers1, body: data1);
      }
    }
  });
}
