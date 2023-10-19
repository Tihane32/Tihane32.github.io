import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testuus4/funktsioonid/graafikGen1.dart';
import 'package:testuus4/funktsioonid/graafikGen2.dart';
import 'package:testuus4/lehed/GraafikusseSeadmeteValik.dart';
import 'package:testuus4/lehed/dynamicKoduLeht.dart';
import 'package:testuus4/widgets/kinnitus.dart';
import '../main.dart';
import 'AbiLeht.dart';
import 'AutoTuniValik.dart';
import 'TunniSeaded.dart';
import 'keelatudTunnid.dart';
import 'keskimiseHinnaAluselTundideValimine.dart';
import 'hinnaPiiriAluselTunideValimine.dart';
import 'kopeeeriGraafikTundideValimine.dart';

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
  int eelmineLeht = 0;
  var valitudSeadmed;
  Map<String, bool> ValitudGraafik = {};
  String selectedPage = 'Odavaimad tunnid';
  double vahe = 10;
  int valitudTunnid = 10;
  Color boxColor = sinineKast;
  late List<Widget> lehedMenu;
  Color paev = Colors.green; // Declare the list
  Map<String, dynamic> graafikuSeaded = {};
  double maxTunnid = 7;
  bool seadista = false;
  Set<int> lubatud = {};
  Set<int> keelatud = {};

  @override
  void initState() {
    paevAbi = "täna";
    mitmeSeadmeKinnitus = [];
    super.initState();

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
          uptateLubatudTunnid: uptateLubatudTunnid,
          uptateKeelatudTunnid: uptateKeelatudTunnid),
      TunniSeaded(
          valitudSeadmed: valitudSeadmed,
          uptateMaxTunnid: uptateMaxValjas,
          uptateRakendaSeadistus: uptateRakendaSeadistus),
      AbiLeht(),
    ];
  }

  updateLulitusMap(Map<int, dynamic> updatedMap, Color updatedPaev) {
    setState(() {
      lulitusMap = updatedMap;
      paev = updatedPaev;
    });
  }

  updateValitudSeamded(Map<String, bool> ValitudGraafikuus) {
    setState(() {
      ValitudGraafik = ValitudGraafikuus;
    });
  }

  uptateMaxValjas(double Tunnid) {
    setState(() {
      maxTunnid = Tunnid;
    });
  }

  uptateRakendaSeadistus(bool seadistus) {
    setState(() {
      seadista = seadistus;
    });
  }

  uptateLubatudTunnid(Set<int> lubatudTunnid) {
    setState(() {
      lubatud = lubatudTunnid;
    });
  }

  uptateKeelatudTunnid(Set<int> keelatudTunnid) {
    setState(() {
      keelatud = keelatudTunnid;
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
                  if (selectedPage == 'Odavaimad tunnid') {
                    eelmineLeht = leht;
                    leht = 0;
                  } else if (selectedPage == 'Hinnapiir') {
                    eelmineLeht = leht;
                    leht = 1;
                  } else if (selectedPage == 'Kopeeri graafik') {
                    eelmineLeht = leht;
                    leht = 2;
                  } else if (selectedPage == 'Automaatne') {
                    eelmineLeht = leht;
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
                              graafikuSeadedVaartustamine(graafikuSeaded,
                                  maxTunnid, seadista, keelatud, lubatud);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DynamilineTundideValimine(
                                          valitudSeadmed: valitudSeadmed,
                                          i: eelmineLeht,
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
                      onTap: (int kodu) async {
                        koduindex = kodu;
                        if (koduindex == 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SeadmeteListValimine(),
                            ),
                          );
                        } else if (koduindex == 1) {
                          if (selectedPage == "Kopeeri graafik") {
                            await graafikuKopeerimine(
                                ValitudGraafik, valitudSeadmed);
                          } else {
                            await graafikuteSaatmine(
                                valitudSeadmed, lulitusMap, paev);
                          }

                          // Show CircularProgressIndicator
                          showDialog(
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

                          Future.delayed(Duration(seconds: 5), () {
                            Navigator.of(context)
                                .pop(); // Close the AlertDialog
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DynaamilenieKoduLeht(i: 1),
                              ),
                            );
                          });
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
    Map<int, dynamic> lulitusMap, Color paev) async {
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
        await graafikGen2SaatmineGraafikuga(graafikGen2, key);
      }
    }
  });
}

graafikuSeadedVaartustamine(Map<String, dynamic> graafikuSeaded,
    double maxTunnid, bool seadista, Set<int> keelatud, Set<int> lubatud) {
  graafikuSeaded['Seadistus_lubatud'] = seadista;
  graafikuSeaded['Max_jarjest_valjas'] = maxTunnid + 1;
  graafikuSeaded['Kelleatud_tunnid'] = keelatud.toSet();
  graafikuSeaded['Lubatud_tunnid'] = lubatud.toSet();
}
