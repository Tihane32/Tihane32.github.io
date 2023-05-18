import 'package:flutter/material.dart';
import 'package:testuus4/funktsioonid/lulitamine.dart';
import 'hinnaGraafik.dart';
import 'Login.dart';
import 'koduleht.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'seadmeSeaded.dart';
import 'package:testuus4/funktsioonid/seisukord.dart';
import 'SeadmeSeadedManuaalsed.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/funktsioonid/graafikGen2.dart';
import 'package:testuus4/lehed/energiaGraafik.dart';
import 'dart:convert';
import 'graafikuKoostamine.dart';
import 'package:testuus4/lehed/kaksTabelit.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:testuus4/funktsioonid/Elering.dart';
import 'seadmedKontoltNim.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(brightness: Brightness.light),
    home: NordHinnad(), //Alustab appi kodulehest
  ));
}

class NordHinnad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TulpDiagramm(),
    );
  }
}

class TulpDiagramm extends StatefulWidget {
  const TulpDiagramm({Key? key}) : super(key: key);

  @override
  _TulpDiagrammState createState() => _TulpDiagrammState();
}

int koduindex = 2;

class _TulpDiagrammState extends State<TulpDiagramm> {
  late Map<int, dynamic> lulitus;
  late double hindAVG;
  Map<int, dynamic> keskHind = {
    0: ['0', 0],
    1: ['0', 0],
    2: ['0', 0],
    3: ['0', 0],
    4: ['0', 0],
    5: ['0', 0],
    6: ['0', 0],
    7: ['0', 0],
    8: ['0', 0],
    9: ['0', 0],
    10: ['0', 0],
    11: ['0', 0],
    12: ['0', 0],
    13: ['0', 0],
    14: ['0', 0],
    15: ['0', 0],
    16: ['0', 0],
    17: ['0', 0],
    18: ['0', 0],
    19: ['0', 0],
    20: ['0', 0],
    21: ['0', 0],
    22: ['0', 0],
    23: ['0', 0],
  };

  Future norm() async {
    setState(() {
      lulitus = {
        0: ['00.00', 22, false],
        1: ['01.00', 34, false],
        2: ['02.00', 0.5, true],
        3: ['03.00', 56, false],
        4: ['04.00', 45, true],
        5: ['05.00', 44, true],
        6: ['06.00', 3, false],
        7: ['07.00', 3, true],
        8: ['08.00', 56, false],
        9: ['09.00', 44, true],
        10: ['10.00', 4, false],
        11: ['11.00', 4, true],
        12: ['12.00', 4, true],
        13: ['13.00', 22, true],
        14: ['14.00', 40, true],
        15: ['15.00', 30, true],
        16: ['16.00', 10, true],
        17: ['17.00', 11, true],
        18: ['18.00', 22, false],
        19: ['19.00', 0, true],
        20: ['20.00', 22, false],
        21: ['21.00', 13.5, true],
        22: ['22.00', 24, false],
        23: ['23.00', 44, false],
      };

      hindAVG = keskmineHindArvutaus(lulitus);
      keskHind = keskmineHindMapVaartustamine(hindAVG, keskHind);
    });
  }

  @override
  void initState() {
    norm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Scaffold(
        //backgroundColor: Color.fromARGB(255, 189, 216, 225), //Taustavärv
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 115, 162, 195),
          title: Text('Keskmine hind: $hindAVG €/MWh'),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginApp()),
                );
              },
              child: const Text('Log in'),
            ),
          ],
        ),

        body: Container(
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(),
            series: [
              BarSeries(
                dataSource: lulitus.values.toList(),
                xValueMapper: (inf, _) => inf[0],
                yValueMapper: (inf, _) => inf[1],
                dataLabelMapper: (data, _) => data[1].toString() + '€/MWh',
                pointColorMapper: (data, _) => Colors.green,
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  labelAlignment: ChartDataLabelAlignment.middle,
                  textStyle: TextStyle(fontSize: 10, color: Colors.black),
                ),
              ),
              LineSeries(
                dataSource: keskHind.values.toList(),
                xValueMapper: (inf, _) => inf[0],
                yValueMapper: (inf, _) => inf[1],
                color: Color.fromARGB(255, 197, 44, 33),
              ),
            ],
          ),
        ),

        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Color.fromARGB(255, 115, 162, 195),
            fixedColor: Color.fromARGB(255, 77, 245, 170),
            unselectedItemColor: Colors.black,
            selectedIconTheme: IconThemeData(size: 30),
            unselectedIconTheme: IconThemeData(size: 22),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                label: 'Seadmed',
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
            onTap: (int kodu) {
              setState(() {
                koduindex = kodu;

                if (koduindex == 2) {
                  Navigator.push(
                    //Kui vajutatakse Hinnagraafiku ikooni peale, siis viiakse Hinnagraafiku lehele

                    context,

                    MaterialPageRoute(builder: (context) => TulpDiagramm()),
                  );
                } else if (koduindex == 1) {
                  Navigator.push(
                    //Kui vajutatakse Teie seade ikooni peale, siis viiakse Seadmetelisamine lehele

                    context,

                    MaterialPageRoute(builder: (context) => const KoduLeht()),
                  );
                }
              });
            }),
      ),
    );
  }
}

keskmineHindArvutaus(Map<int, dynamic> lulitus) {
  double summa = 0;
  int hindNr = 0;

  lulitus.values.forEach((data) {
    summa += data[1];
    hindNr++;
  });

  if (hindNr > 0) {
    return summa / hindNr;
  } else {
    return 0;
  }
}

keskmineHindMapVaartustamine(var hindAVG, Map<int, dynamic> keskHind) {
  String kell = '';
  print('+++++++++++++');
  for (int i = 0; i < 24; i++) {
    if (i < 10) {
      kell = '0$i';
    } else {
      kell = '$i';
    }
    keskHind[i] = [kell + '.00', hindAVG];
  }
  keskHind.forEach((key, value) {
    print('$key: $value');
  });
  print('+++++++++++++');
  return keskHind;
}
