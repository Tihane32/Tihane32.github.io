import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/funktsioonid/graafikGen1.dart';
import 'package:testuus4/funktsioonid/graafikGen2.dart';
import 'package:testuus4/lehed/GraafikusseSeadmeteValik.dart';
import 'package:testuus4/lehed/dynamicKoduLeht.dart';
import '../funktsioonid/genMaaramine.dart';
import '../main.dart';
import 'AbiLeht.dart';
import 'keskimiseHinnaAluselTundideValimine.dart';
import 'hinnaPiiriAluselTunideValimine.dart';
import 'kopeeeriGraafikTundideValimine.dart';

class DynamilineTundideValimine extends StatefulWidget {
  DynamilineTundideValimine({Key? key, required this.valitudSeadmed})
      : super(key: key);

  var valitudSeadmed;

  @override
  _DynamilineTundideValimineState createState() =>
      _DynamilineTundideValimineState(valitudSeadmed: valitudSeadmed);
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
  _DynamilineTundideValimineState({Key? key, required this.valitudSeadmed});
  var valitudSeadmed;
  String selectedPage = 'Keskmine hind';
  double vahe = 10;
  int valitudTunnid = 10;
  Color boxColor = sinineKast;
  int leht = 0;
  late List<Widget> lehedMenu; // Declare the list

  @override
  void initState() {
    super.initState();

    // Initialize lehedMenu in initState
    lehedMenu = [
      KeskmiseHinnaAluselTundideValimine(
          lulitusMap: lulitusMap, updateLulitusMap: updateLulitusMap),
      HinnaPiiriAluselTundideValimine(
          lulitusMap: lulitusMap, updateLulitusMap: updateLulitusMap),
      KopeeriGraafikTundideValik(),
      AbiLeht(),
    ];
  }

  updateLulitusMap(Map<int, dynamic> updatedMap) {
    setState(() {
      lulitusMap = updatedMap;
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
            Text('Tundide valimine'),
          ],
        ),
        actions: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue,
              ),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButton<String>(
                value: selectedPage,
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
                  } else if (selectedPage == 'Minu eelistused') {
                    leht = 3;
                  }
                },
                underline: Container(), // or SizedBox.shrink()
                items: <String>[
                  'Keskmine hind',
                  'Hinnapiir',
                  'Kopeeri graafik',
                  'Minu eelistused',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: Colors.black),
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
              child: BottomNavigationBar(
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
                        graafikuteSaatmine(valitudSeadmed, lulitusMap);
                        print('final');
                        print(lulitusMap);
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Add some spacing between icon and text
                                          Text("Kinnitatud", style: fontSuur),
                                          SizedBox(width: 8),
                                          Icon(
                                            Icons.check_circle_outline_outlined,
                                            size: 35,
                                          ),
                                        ],
                                      ),
                                      // Add other content of the dialog if needed
                                    ],
                                  ),
                                ));
                        HapticFeedback.vibrate();
                        Future.delayed(Duration(seconds: 5), () {
                          Navigator.of(context).pop(); // Close the AlertDialog
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

graafikuteSaatmine(var valitudSeadmed, Map<int, dynamic> lulitusMap) async {
  print(valitudSeadmed);
  print('lulitusmap siiin');
  print(lulitusMap);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var storedJsonMap = prefs.getString('seadmed');
  print(storedJsonMap);
  Map<String, dynamic> seadmed;
  seadmed = json.decode(storedJsonMap!);
  print('lenght');
  print(seadmed.length);
  for (int i = 0; i < seadmed.length; i++) {
    if (valitudSeadmed[i] == true) {
      print('i siin $i');
      print(seadmed['Seade$i']["Seadme_generatsioon"]);
      if (seadmed['Seade$i']["Seadme_generatsioon"] == 1) {
        print('Korras 1');
        print(lulitusMap);
        await gen1GraafikLoomine(
            lulitusMap, 'täna', seadmed['Seade$i']["Seadme_ID"]);
      } else {
        print('Korras 2');
        print(lulitusMap);
        await gen2GraafikuLoomine(
            lulitusMap, 'täna', seadmed['Seade$i']["Seadme_ID"]);
      }
    }
  }
}
