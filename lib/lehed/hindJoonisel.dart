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

  late Map<String, dynamic> lulitus;



  Future test() async {

    setState(() {

      lulitus = {

        '0000': ['00.00', 22, false],

        '0100': ['01.00', 34, false],

        '0200': ['02.00', 0.5, true],

        '0300': ['03.00', 56, false],

        '0400': ['04.00', 45, true],

        '0500': ['05.00', 44, true],

        '0600': ['06.00', 3, false],

        '0700': ['07.00', 3, true],

        '0800': ['08.00', 56, false],

        '0900': ['09.00', 44, true],

        '1000': ['10.00', 4, false],

        '1100': ['11.00', 4, true],

        '1200': ['12.00', 4, true],

        '1300': ['13.00', 22, true],

        '1400': ['14.00', 40, true],

        '1500': ['15.00', 30, true],

        '1600': ['16.00', 10, true],

        '1700': ['17.00', 11, true],

        '1800': ['18.00', 22, false],

        '1900': ['19.00', 0, true],

        '2000': ['20.00', 22, false],

        '2100': ['21.00', 13.5, true],

        '2200': ['22.00', 24, false],

        '2300': ['23.00', 44, false],

      };

    });

  }



  @override

  void initState() {

    test();

    super.initState();

  }



  @override

  Widget build(BuildContext context) {

    var hindAVG = keskmineHind(lulitus);

    return Padding(

      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),

      child: Scaffold(

        //backgroundColor: Color.fromARGB(255, 189, 216, 225), //TaustavÃ¤rv

        appBar: AppBar(

          backgroundColor: Color.fromARGB(255, 115, 162, 195),

          title: Text('Keskmine hind: $hindAVG â‚¬/MWh'),

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

                xValueMapper: (data, _) => data[0],

                yValueMapper: (data, _) => data[1],

                dataLabelMapper: (data, _) => data[1].toString() + 'â‚¬/MWh',

                pointColorMapper: (data, _) => Colors.green,

                dataLabelSettings: DataLabelSettings(

                  isVisible: true,

                  labelAlignment: ChartDataLabelAlignment.middle,

                  textStyle: TextStyle(fontSize: 10, color: Colors.black),

                ),

              ),

              LineSeries(

                dataSource: lulitus.values.toList(),

                xValueMapper: (data, _) => data[0],

                yValueMapper: (_, index) => hindAVG.toInt(),

                color: Colors.red,

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



keskmineHind(Map<String, dynamic> lulitus) {

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
