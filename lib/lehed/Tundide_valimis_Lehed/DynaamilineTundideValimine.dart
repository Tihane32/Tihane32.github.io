import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/funktsioonid/graafikGen1.dart';
import 'package:testuus4/funktsioonid/graafikGen2.dart';
import 'package:testuus4/lehed/Tundide_valimis_Lehed/Graafik_Seadmete_valik/DynaamilineGraafikusseSeadmeteValik.dart';
import 'package:testuus4/lehed/Tundide_valimis_Lehed/AutoTuniValik.dart';
import 'package:testuus4/lehed/Tundide_valimis_Lehed/hinnaPiiriAluselTunideValimine.dart';
import 'package:testuus4/lehed/Tundide_valimis_Lehed/kopeeeriGraafikTundideValimine.dart';
import 'package:testuus4/widgets/kinnitus.dart';
import '../../main.dart';
import 'Graafik_Seadmete_valik/graafikuseSeadmeteValik_yksikud.dart';
import 'keskimiseHinnaAluselTundideValimine.dart';
import 'TunniSeaded.dart';
import 'keelatudTunnid.dart';

String selectedPageGlobal = "";

class DynamilineTundideValimine extends StatefulWidget {
  DynamilineTundideValimine(
      {Key? key,
      required this.valitudSeadmed,
      required this.i,
      required this.luba,
      required this.eelmineleht})
      : super(key: key);
  int i;
  int eelmineleht;
  String luba;
  var valitudSeadmed;

  @override
  _DynamilineTundideValimineState createState() =>
      _DynamilineTundideValimineState(
          valitudSeadmed: valitudSeadmed,
          leht: i,
          luba: luba,
          eelmineLeht: eelmineleht);
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
      required this.luba,
      required this.eelmineLeht});
  int eelmineLeht;
  String luba;
  int leht;
  var valitudSeadmed;
  Map<String, bool> ValitudGraafik = {};

  double vahe = 10;
  int valitudTunnid = 10;
  Color boxColor = sinineKast;
  late List<Widget> lehedMenu;
  Color paev = Colors.green; // Declare the list

  @override
  void initState() {
    selectedPageGlobal = 'Odavaimad tunnid';
    paevAbi = "täna";
    mitmeSeadmeKinnitus = [];
    super.initState();

    if (leht == 0) {
      selectedPageGlobal = 'Odavaimad tunnid';
    } else if (leht == 1) {
      selectedPageGlobal = 'Hinnapiir';
    } else if (leht == 2) {
      selectedPageGlobal = 'Kopeeri graafik';
    } else if (leht == 3) {
      selectedPageGlobal = 'Automaatne';
    }

    // Initialize lehedMenu in initState
    lehedMenu = [
      KeskmiseHinnaAluselTundideValimine(
          valitudSeadmed: valitudSeadmed,
          lulitusMap: lulitusMap,
          updateLulitusMap: updateLulitusMap),
      HinnaPiiriAluselTundideValimine(
          valitudSeadmed: valitudSeadmed,
          lulitusMap: lulitusMap,
          updateLulitusMap: updateLulitusMap),
      KopeeriGraafikTundideValik(
          valitudSeadmed: valitudSeadmed,
          updateValitudSeadmed: updateValitudSeamded),
      AutoTundideValik(
          valitudSeadmed: valitudSeadmed,
          updateValitudSeadmed: updateValitudSeamded),
      KeelatudTunnid(
        valitudSeadmed: valitudSeadmed,
        luba: luba,
      ),
      TunniSeaded(
        valitudSeadmed: valitudSeadmed,
      ),
      //AbiLeht(),
    ];
  }

  updateLulitusMap(Map<int, dynamic> updatedMap, String leht) {
    print("valitud leht: $selectedPageGlobal");
    if (leht == selectedPageGlobal) {
      setState(() {
        lulitusMap = updatedMap;
      });
      print("valitud uus leht: $leht");
    }

    print("lulitusmap update: $lulitusMap");
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
          Visibility(
            visible: leht <= 3,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: boxColor,
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButton<String>(
                  icon: Icon(Icons.menu),
                  value: selectedPageGlobal,
                  style: font,
                  dropdownColor: sinineKast,
                  borderRadius: borderRadius,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPageGlobal = newValue!;
                    });
                    if (selectedPageGlobal == 'Odavaimad tunnid') {
                      leht = 0;
                    } else if (selectedPageGlobal == 'Hinnapiir') {
                      leht = 1;
                    } else if (selectedPageGlobal == 'Kopeeri graafik') {
                      leht = 2;
                    } else if (selectedPageGlobal == 'Automaatne') {
                      leht = 3;
                    }
                  },
                  underline: Container(), // or SizedBox.shrink()
                  items: <String>[
                    'Odavaimad tunnid',
                    'Hinnapiir',
                    'Kopeeri graafik',
                    'Automaatne',
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
              child: leht == 4 || leht == 5
                  ? BottomNavigationBar(
                      backgroundColor: Color.fromARGB(255, 115, 162, 195),
                      fixedColor: Color.fromARGB(255, 157, 214, 171),
                      unselectedLabelStyle: TextStyle(
                        color: Color.fromARGB(255, 157, 214, 171),
                      ),
                      selectedLabelStyle: TextStyle(
                        color: Color.fromARGB(255, 157, 214, 171),
                      ),
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          label: '',
                          icon: Icon(
                            Icons.check_circle_outlined,
                            size: 0,
                          ),
                        ),
                        BottomNavigationBarItem(
                          label: 'Kinnita',
                          icon: Icon(
                            Icons.check_circle_outlined,
                            size: 30,
                            color: Color.fromARGB(255, 157, 214, 171),
                          ),
                        ),
                        BottomNavigationBarItem(
                          label: '',
                          icon: Icon(
                            Icons.check_circle_outlined,
                            size: 0,
                          ),
                        ),
                      ],
                      onTap: (int kodu) {
                        //graafikuSeadedVaartustamine(graafikuSeaded);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DynamilineTundideValimine(
                              i: eelmineLeht,
                              luba: '',
                              valitudSeadmed: valitudSeadmed,
                              eelmineleht: leht,
                            ),
                          ),
                        );
                      })
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
                      currentIndex: 1,
                      onTap: (int kodu) async {
                        koduindex = kodu;
                        if (koduindex == 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SeadmeteListValimine_dynaamiline(),
                            ),
                          );
                        } else if (koduindex == 1) {
                          if (selectedPageGlobal == "Kopeeri graafik") {
                            await graafikuKopeerimine(
                                ValitudGraafik, valitudSeadmed);
                          } else {
                            await graafikuteSaatmine(valitudSeadmed, lulitusMap,
                                paev, selectedPageGlobal);
                          }

                          // Show CircularProgressIndicator
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          );

                          while (mitmeSeadmeKinnitus.length !=
                              valitudSeadmed.values
                                  .where((value) => value == true)
                                  .length) {
                            await Future.delayed(Duration(seconds: 1));
                          }

                          // Close the CircularProgressIndicator dialog
                          Navigator.pop(context);


                          Kinnitus(context, "Graafik seadmetele saadetud");
                          HapticFeedback.vibrate();

                          
                        }
                      }),
            ),
          ],
        ),
      ),
    );
  }
}

Future graafikuteSaatmine(Map<String, bool> valitudSeadmed,
    Map<int, dynamic> lulitusMap, Color paev, String selectedPage) async {
  print("lulitusmap valik: $selectedPage");
  print("lulitusmap alguses: $lulitusMap");
  String valitudPaev = "homme";
  if (paev == Colors.green) {
    valitudPaev = "täna";
  }
  print(paevAbi);
  valitudSeadmed.forEach((key, value) async {
    if (value == true) {
      if (seadmeteMap[key]['Seadme_generatsioon'] == 1) {
        await gen1GraafikLoomine(lulitusMap, paevAbi, key);
      } else {
        await gen2GraafikuLoomine(lulitusMap, paevAbi, key);
      }
    }
  });
}

graafikuKopeerimine(
    Map<String, bool> valitudGraafik, Map<String, bool> valitudSeadmed) async {
  //Graafiku saamise osa
  List<dynamic> graafik = [];
  List<dynamic> graafikGen1 = [];
  List<dynamic> graafikGen2 = [];
  await Future.forEach(valitudGraafik.keys, (key) async {
    bool? value = valitudGraafik[key];
    if (value == true) {
      if (seadmeteMap[key]['Seadme_generatsioon'] == 1) {
        graafik = await graafikGen1Lugemine(key);
      } else {
        graafik = await graafikGen2Lugemine(key);
        graafik = graafikGen2ToGraafikGen1(graafik);
      }
    }
  });

  int tana = getCurrentDayOfWeek();
  int homme = getTommorowDayOfWeek();
  List<int> paevad = [tana, homme];
  graafik = graafikGen1Filtreerimine(graafik, paevad);
  graafikGen1 = graafik;
  graafikGen2 = graafik;
  int k = 0;
  valitudSeadmed.forEach((key, value) async {
    if (value == true) {
      if (seadmeteMap[key]['Seadme_generatsioon'] == 1) {
        await graafikGen1Saatmine(graafikGen1, key);
      } else {
        if (k == 0) {
          graafikGen2 = graafikGen1ToGraafikGen2(graafikGen2);
          k = 1;
        }
        await graafikGen2DeleteAll(key);
        await graafikGen2SaatmineGraafikuga(graafikGen2, key);
      }
    }
  });
}
