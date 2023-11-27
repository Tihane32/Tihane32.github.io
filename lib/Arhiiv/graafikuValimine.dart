
/*
/*
Trevor Uuna, Jaakob Lambot 27.03.2023
TalTech
*/
//Kit test
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'Elering.dart';
import 'package:testuus4/funktsioonid/Elering.dart';

import 'Graafik.dart';
import '../lehed/Põhi_Lehed/Login.dart';
import 'kaksTabelit.dart';
import '../lehed/Põhi_Lehed/koduleht.dart';

//Maini käivitamine, home on koduleht.

//Defineerime hinnagraafiku lehe

//Defineerime tanaste tundide valimise lehe

class TundideValimineTana extends StatelessWidget {
  TundideValimineTana(
      {Key? key, required this.soovitudTunnid, required this.value})
      : super(key: key);

  final int soovitudTunnid;
  final String value;
  final String valitudPaev = 'täna';

  final List<bool> selected = List<bool>.generate(
      24,
      (int index) =>
          false); //Lehe peal olevad kastid ja alguses teeb nad false-ks, ehk tühjaks

  //Määrame tänaste tundide valimise lehe struktuuri

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kinnitus',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sisselüliltus tabel'),
          actions: [
            IconButton(
              icon: Icon(Icons.navigate_next),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Graafik(
                          selected: selected,
                          valitudPaev: valitudPaev,
                          value: value)),
                );
              },
            ),
          ],
        ),
        body: MyStatefulWidget(
          soovitudTunnid: soovitudTunnid,
          selected: selected,
          value: value,
        ),
      ),
    );
  }
}

//Täiendame tänaste tundide valimise lehe sisu

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({
    Key? key,
    required this.soovitudTunnid,
    required this.selected,
    required this.value,
  }) : super(key: key);

  final int soovitudTunnid;
  final String value;
  final List<bool> selected;

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  static const int numItems = 24;

  late Map<dynamic, dynamic> hindMap = {};

  late int timestampMap;

//Käivitamisel toob Eleringi API-st hinna graafiku ja sorteerib selle kasvavas järjekorras

  @override
  void initState() {
    super.initState();

    _getElering();
  }

  Future<void> _getElering() async {
    String paev = 'täna';

    final data = await getElering(
        paev); //Kutsume Eleringi funktsioonist soovitud paeva hinnagraafiku

    final priceMap = new Map();

    for (var i = 0; i <= 23; i++) {
      priceMap[i] = data[i]['price'];
    }

    timestampMap = data[0]['timestamp'];

    var priceList = List.from(priceMap.values);

//Sorteerib kõige odavamad hinnad kasvavas järjekorras
    for (var i = 0; i < 24 - 1; i++) {
      for (var j = 0; j < 24 - i - 1; j++) {
        if (priceList[j] > priceList[j + 1]) {
          var temp = priceList[j];

          priceList[j] = priceList[j + 1];

          priceList[j + 1] = temp;
        }
      }
    }

    for (var i = 0; i < 24; i++) {
      widget.selected[i] = false;
    }

    //valib kõige soodsamad tunnid

    for (var i = 0; i < widget.soovitudTunnid; i++) {
      for (var j = 0; j < 24; j++) {
        if (priceList[i] ==
            priceMap[
                j]) //Hakkab võrdlema sorteerimata hinnagraafikut ja sorteeritud hinnagraafikut.
        //Kui leiab endaga sama väärtuse siis läheb edasi.

        {
          if (widget.selected[j] ==
              false) //Kui antud kast ei ole valitud, siis määrab ta valituks.
          //Kontrolli põhjus on see, et kui hind on kahel tunnil sama, siis ta määraks mõlemad kastid õigeks, aga peaks määrama ainut ühe.
          {
            widget.selected[j] = true;

            break;
          }
        }
      }
    }

    setState(() {
      hindMap = priceMap;
    });
  }

  //Täiendab tänaste tundide valimise lehe struktuuri

  @override
  Widget build(BuildContext context) {
    int koduindex = 0;

    if (hindMap.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
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
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            'Kõik tunnid täna',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          '${DateFormat("yyyy/MM/dd").format(DateTime.fromMillisecondsSinceEpoch(timestampMap * 1000).toLocal())}',
                          style: TextStyle(
                            fontSize: 14,
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
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            'Hind',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          '€/MWh',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                rows: List<DataRow>.generate(
                  numItems,
                  (int index) => DataRow(
                    color: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.08);
                        }

                        return null;
                      },
                    ),
                    cells: <DataCell>[
                      DataCell(Text(
                        '$index:00',
                        style: TextStyle(fontSize: 20),
                      )),
                      DataCell(Text(
                        '${hindMap[index]}',
                        style: TextStyle(fontSize: 20),
                      )),
                    ],
                    selected: widget.selected[index],
                    onSelectChanged: (bool? value) {
                      setState(() {
                        widget.selected[index] = value!;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.blue[300],
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  label: 'Täna',
                  icon: Icon(Icons.schedule),
                ),
                BottomNavigationBarItem(
                  label: 'Homme',
                  icon: Icon(Icons.schedule),
                ),
              ],
              currentIndex: koduindex,
              onTap: (int kodu) {
                if (kodu == 0) {
                } else if (kodu == 1) {
                  Navigator.push(
                    //Kui vajutatakse "Homme" nuppu, siis viiakse homse graafiku koostamise lehele
                    context,
                    MaterialPageRoute(
                        builder: (context) => tundideValimineHomme(
                            soovitudTunnid: widget.soovitudTunnid,
                            value: widget.value)),
                  );
                }
              }));
    }
  }
}

//Defineerime homsete tundide valimise lehe

class tundideValimineHomme extends StatelessWidget {
  tundideValimineHomme(
      {Key? key, required this.soovitudTunnid, required this.value})
      : super(key: key);

  final int soovitudTunnid;
  final String value;
  final String valitudPaev = 'homme';

  final List<bool> selected1 = List<bool>.generate(
      24,
      (int index) =>
          false); //Lehe peal olevad kastid ja alguses teeb nad false-ks, ehk tühjaks

//Määrame homsete tundide valimise lehe struktuuri

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kinnitus',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sisselüliltus tabel'),
          actions: [
            IconButton(
              icon: Icon(Icons.navigate_next),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Graafik(
                            selected: selected1,
                            valitudPaev: valitudPaev,
                            value: value,
                          )),
                );
              },
            ),
          ],
        ),
        body: MyStatefulWidgethomme(
          soovitudTunnid: soovitudTunnid,
          selected1: selected1,
        ),
      ),
    );
  }
}

//Täiendame homsete tundide valimise lehe sisu

class MyStatefulWidgethomme extends StatefulWidget {
  const MyStatefulWidgethomme({
    Key? key,
    required this.soovitudTunnid,
    required this.selected1,
  }) : super(key: key);

  final int soovitudTunnid;

  final List<bool> selected1;

  @override
  State<MyStatefulWidgethomme> createState() => _MyStatefulWidgetStatehomme();
}

class _MyStatefulWidgetStatehomme extends State<MyStatefulWidgethomme> {
  static const int numItems = 24;

  late Map<dynamic, dynamic> hindMap = {};

  late int timestampMap;
//Käivitamisel toob Eleringi API-st hinna graafiku ja sorteerib selle kasvavas järjekorras
  @override
  void initState() {
    super.initState();

    _getElering();
  }

  Future<void> _getElering() async {
    String paev = 'homme';

    final data = await getElering(
        paev); //Kutsume Eleringi funktsioonist soovitud paeva hinnagraafiku

    final priceMap = new Map();

    for (var i = 0; i <= 23; i++) {
      priceMap[i] = data[i]['price'];
    }

    timestampMap = data[0]['timestamp'];

    var priceList = List.from(priceMap.values);

    //Sorteerime kõige odavamad hinnad kasvavas järjekorras

    for (var i = 0; i < 24 - 1; i++) {
      for (var j = 0; j < 24 - i - 1; j++) {
        if (priceList[j] > priceList[j + 1]) {
          var temp = priceList[j];

          priceList[j] = priceList[j + 1];

          priceList[j + 1] = temp;
        }
      }
    }

    for (var i = 0; i < 24; i++) {
      widget.selected1[i] = false;
    }

    //valib kõige soodsamad tunnid

    for (var i = 0; i < widget.soovitudTunnid; i++) {
      for (var j = 0; j < 24; j++) {
        if (priceList[i] ==
            priceMap[
                j]) //Hakkab võrdlema sorteerimata hinnagraafikut ja sorteeritud hinnagraafikut.
        //Kui leiab endaga sama väärtuse siis läheb edasi.

        {
          if (widget.selected1[j] ==
              false) //Kui antud kast ei ole valitud, siis määrab ta valituks.
          //Kontrolli põhjus on see, et kui hind on kahel tunnil sama, siis ta määraks mõlemad kastid õigeks, aga peaks määrama ainut ühe.
          {
            widget.selected1[j] = true;

            break;
          }
        }
      }
    }

    setState(() {
      hindMap = priceMap;
    });
  }

//Täiendab homsete tundide valimise lehe struktuuri

  @override
  Widget build(BuildContext context) {
    int koduindex = 1;

    if (hindMap.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
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
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            'Kõik tunnid homme',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          '${DateFormat("yyyy/MM/dd").format(DateTime.fromMillisecondsSinceEpoch(timestampMap * 1000).toLocal())}',
                          style: TextStyle(
                            fontSize: 14,
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
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            'Hind',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          '€/MWh',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                rows: List<DataRow>.generate(
                  numItems,
                  (int index) => DataRow(
                    color: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.08);
                        }

                        return null;
                      },
                    ),
                    cells: <DataCell>[
                      DataCell(Text(
                        '$index:00',
                        style: TextStyle(fontSize: 20),
                      )),
                      DataCell(Text(
                        '${hindMap[index]}',
                        style: TextStyle(fontSize: 20),
                      )),
                    ],
                    selected: widget.selected1[index],
                    onSelectChanged: (bool? value) {
                      setState(() {
                        widget.selected1[index] = value!;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.blue[300],
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  label: 'Täna',
                  icon: Icon(Icons.schedule),
                ),
                BottomNavigationBarItem(
                  label: 'Homme',
                  icon: Icon(Icons.schedule),
                ),
              ],
              currentIndex: koduindex,
              onTap: (int kodu) {
                if (kodu == 1) {
                } else if (kodu == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TundideValimineTana(
                              soovitudTunnid: widget.soovitudTunnid,
                              value: '',
                            )),
                  );
                }
              }));
    }
  }
}
*/