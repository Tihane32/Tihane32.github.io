import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'Login.dart';

import 'koduleht.dart';

import 'dart:math';

import 'package:testuus4/lehed/kaksTabelit.dart';

import 'package:syncfusion_flutter_charts/charts.dart';







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

    0: ['0', 0, ''],

    1: ['0.0', 0, ''],

    2: ['1', 0, ''],

    3: ['2', 0, ''],

    4: ['3', 0, ''],

    5: ['4', 0, ''],

    6: ['5', 0, ''],

    7: ['6', 0, ''],

    8: ['7', 0, ''],

    9: ['8', 0, ''],

    10: ['9', 0, ''],

    11: ['10', 0, ''],

    12: ['12', 0, ''],

    13: ['0', 0, ''],

    14: ['0', 0, ''],

    15: ['0', 0, ''],

    16: ['0', 0, ''],

    17: ['0', 0, ''],

    18: ['0', 0, ''],

    19: ['0', 0, ''],

    20: ['0', 0, ''],

    21: ['0', 0, ''],

    22: ['0', 0, ''],

    23: ['0', 0, ''],

    24: ['0', 0, ''],

    25: ['0', 0, ''],

  };



  Future norm() async {

    setState(() {

      lulitus = {

        0: ['00.00', 62, false],

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

        13: ['13.00', 22.55, true],

        14: ['14.00', 40.567, true],

        15: ['15.00', 44.4, true],

        16: ['16.00', 80, true],

        17: ['17.00', 121, true],

        18: ['18.00', 100.2, false],

        19: ['19.00', 0, true],

        20: ['20.00', 22, false],

        21: ['21.00', 13.5, true],

        22: ['22.00', 24, false],

        23: ['23.00', 44, false],

      };



      hindAVG = keskmineHindArvutaus(lulitus);

      keskHind = keskmineHindMapVaartustamine(hindAVG, keskHind, lulitus);

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

        backgroundColor: Color.fromARGB(255, 189, 216, 225), //TaustavÃ¤rv

        appBar: AppBar(

          backgroundColor: Color.fromARGB(255, 115, 162, 195),

          title: Text('Hinnagraafik'),

          actions: [

            IconButton(

              onPressed: () {

                Navigator.push(

                  context,

                  MaterialPageRoute(builder: (context) => LoginApp()),

                );

              },

              icon: const Icon(Icons.person),

              iconSize: 40,

            )

          ],

        ),



        body: Column(

          children: [

            Align(

              alignment: Alignment.centerLeft,

              child: Container(

                alignment: Alignment.centerLeft,

                decoration: BoxDecoration(

                  color: Color.fromARGB(255, 237, 202, 146),

                  borderRadius: BorderRadius.circular(14.0),

                  border: Border.all(

                    color: Color.fromARGB(30, 0, 0, 0),

                    width: 1,

                  ),

                  boxShadow: [

                    BoxShadow(

                      color: Colors.black.withOpacity(0.2),

                      spreadRadius: 2,

                      blurRadius: 5,

                      offset: Offset(3, 3),

                    ),

                  ],

                ),

                width: 300,

                height: 35,

                child: RichText(

                  text: TextSpan(

                    style: TextStyle(

                      fontSize: 18,

                      color: Colors.black,

                    ),

                    children: [

                      TextSpan(

                        text: '  keskmine Hind: ',

                        style: GoogleFonts.openSans(

                          textStyle: TextStyle(

                            fontWeight: FontWeight.w500,

                          ),

                        ),

                      ),

                      TextSpan(

                        text: '$hindAVG â‚¬/MWh',

                        style: GoogleFonts.openSans(

                          textStyle: TextStyle(

                            fontWeight: FontWeight.w500,

                            fontSize: 20,

                            color: Colors.black,

                          ),

                        ),

                      ),

                    ],

                  ),

                ),

              ),

            ),

            Container(

              height: MediaQuery.of(context).size.height * 0.791,

              child: Center(

                  child: RotatedBox(

                quarterTurns: 1,

                child: Container(

                  width: double.infinity,

                  height: double.infinity,

                  child: SfCartesianChart(

                    primaryXAxis: CategoryAxis(

                      interval: 1,

                      labelRotation: 270,

                      visibleMinimum: 0,

                      maximum: 23.5,

                    ),

                    primaryYAxis: NumericAxis(

                      isVisible: false,

                      labelRotation: 270,

                      minimum: 0,

                      title: AxisTitle(text: 'â‚¬/kWh'),

                    ),

                    series: <ChartSeries>[

                      ColumnSeries(

                        dataSource: lulitus.values.toList(),

                        xValueMapper: (data, _) => data[0],

                        yValueMapper: (data, _) => data[1],

                        dataLabelMapper: (data, _) =>

                            data[1].toString() + 'â‚¬/kWh',

                        pointColorMapper: (data, _) => Colors.green,

                        dataLabelSettings: DataLabelSettings(

                          isVisible: true,

                          labelAlignment: ChartDataLabelAlignment.middle,

                          textStyle:

                              TextStyle(fontSize: 15, color: Colors.black),

                          angle: 270,

                        ),

                      ),

                      SplineSeries(

                        dataSource: keskHind.values.toList(),

                        xValueMapper: (inf, _) => inf[0],

                        yValueMapper: (inf, _) => inf[1],

                        dataLabelMapper: (inf, _) => inf[2],

                        dataLabelSettings: DataLabelSettings(

                          offset: Offset(-5, 0),

                          isVisible: true,

                          labelAlignment: ChartDataLabelAlignment.middle,

                          textStyle: TextStyle(

                              fontSize: 10,

                              color: Color.fromARGB(255, 231, 17, 17)),

                          angle: 270,

                        ),

                        trendlines: <Trendline>[

                          Trendline(

                            color: Color.fromARGB(255, 231, 17, 17),

                            width: 0.5,

                          ),

                        ],

                      ),

                    ],

                  ),

                ),

              )),

            ),

          ],

        ),



        bottomNavigationBar: BottomNavigationBar(

            backgroundColor: Color.fromARGB(255, 115, 162, 195),

            fixedColor: Color.fromARGB(255, 157, 214, 171),

            unselectedItemColor: Colors.white,

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



                if (koduindex == 0) {

                  Navigator.push(

                    //Kui vajutatakse Hinnagraafiku ikooni peale, siis viiakse Hinnagraafiku lehele



                    context,



                    MaterialPageRoute(builder: (context) => MinuSeadmed()),

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

  double AVG;

  int hindNr = 0;

  num mod = pow(10.0, 2);



  lulitus.values.forEach((data) {

    summa += data[1];

    hindNr++;

  });



  AVG = summa / hindNr;



  print('Keskmine hind: $AVG');



  if (hindNr > 0) {

    return ((AVG * mod).round().toDouble() / mod);

  } else {

    return 0;

  }

}



keskmineHindMapVaartustamine(

    var hindAVG, Map<int, dynamic> keskHind, Map<int, dynamic> lulitus) {

  String kell = '00';

  int madalaimTund = 0;

  int tund = 0;

  for (var entry in lulitus.entries) {

    double price = entry.value[1];

    if (price < madalaimTund) {

      madalaimTund = tund;

    }

  }

  print('+++++++++++++');

  keskHind[0] = [kell + '.00', hindAVG, 'Keskmine hind'];

  for (int i = 1; i < 24; i++) {

    if (i < 10) {

      kell = '0$i';

    } else {

      kell = '$i';

    }

    keskHind[i] = [kell + '.00', hindAVG, ''];



    if (tund == i) {

      keskHind[tund] = [kell + '.00', hindAVG, ''];

    }

  }



  kell = '24.00';

  keskHind[24] = [kell + '.00', hindAVG, ''];

  kell = '25.00';

  keskHind[25] = [kell + '.00', hindAVG, ''];



  keskHind.forEach((key, value) {

    print('$key: $value');

  });

  print('+++++++++++++');

  return keskHind;

}
