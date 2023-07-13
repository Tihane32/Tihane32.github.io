import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'Login.dart';

import 'koduleht.dart';

import 'dart:math';

import 'package:testuus4/lehed/kaksTabelit.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'navigationBar.dart';
import 'package:testuus4/main.dart';
import 'drawer.dart';

class TulpDiagramm extends StatefulWidget {
  const TulpDiagramm({Key? key}) : super(key: key);

  @override
  _TulpDiagrammState createState() => _TulpDiagrammState();
}

int koduindex = 2;

class _TulpDiagrammState extends State<TulpDiagramm> {
  late Map<int, dynamic> lulitus;

  late double hindAVG;
  double vahe = 10;
  Color boxColor = sinineKast;

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
        0: ['00.00', 62.2, false],
        1: ['01.00', 34.1, false],
        2: ['02.00', 100.0, true],
        3: ['03.00', 56.3, false],
        4: ['04.00', 45.5, true],
        5: ['05.00', 44.5, true],
        6: ['06.00', 3.6, false],
        7: ['07.00', 3.8, true],
        8: ['08.00', 56.9, false],
        9: ['09.00', 44.6, true],
        10: ['10.00', 4.6, false],
        11: ['11.00', 4.8, true],
        12: ['12.00', 4.1, true],
        13: ['13.00', 22.55, true],
        14: ['14.00', 40.567, true],
        15: ['15.00', 44.4, true],
        16: ['16.00', 80.4, true],
        17: ['17.00', 121.2, true],
        18: ['18.00', 100.2, false],
        19: ['19.00', 0.0, true],
        20: ['20.00', 22.1, false],
        21: ['21.00', 13.5, true],
        22: ['22.00', 24.4, false],
        23: ['23.00', 44.1, false],
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
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: appbar,
          title: Text(
            'Shelly App',
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(fontSize: 25),
            ),
          ),
          actions: [
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                  padding: const EdgeInsets.only(right: 20),
                  icon: const Icon(
                    Icons.menu,
                    size: 30,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              },
            ),
          ],
        ),
        endDrawer: drawer(),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: vahe),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          alignment: Alignment.center,
                          //width: 200,
                          child: Center(
                            child: Column(
                              children: [
                                Align(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    //width: sinineKastLaius,
                                    //height: sinineKastKorgus,
                                    child: RichText(
                                      text: TextSpan(
                                        style: fontVaike,
                                        children: [
                                          TextSpan(
                                              text: 'Päeva keskmine:',
                                              style: fontVaike),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    //width: sinineKastLaius,
                                    //height: sinineKastKorgus,
                                    child: RichText(
                                      text: TextSpan(
                                        style: fontVaike,
                                        children: [
                                          TextSpan(
                                              text: '$hindAVG ', style: font),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          //width: 200,
                          child: Column(
                            children: [
                              Align(
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  //width: sinineKastLaius,
                                  //height: sinineKastKorgus,
                                  child: RichText(
                                    text: TextSpan(
                                      style: fontVaike,
                                      children: [
                                        TextSpan(
                                            text: 'Päeva miinimum:',
                                            style: fontVaike),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  //width: sinineKastLaius,
                                  //height: sinineKastKorgus,
                                  child: RichText(
                                    text: TextSpan(
                                      style: fontVaike,
                                      children: [
                                        TextSpan(
                                            text: '$hindAVG ', style: font),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          //width: 200,
                          child: Column(
                            children: [
                              Align(
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  //width: sinineKastLaius,
                                  //height: sinineKastKorgus,
                                  child: RichText(
                                    text: TextSpan(
                                      style: fontVaike,
                                      children: [
                                        TextSpan(
                                            text: 'Päeva maksimum:',
                                            style: fontVaike),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  //width: sinineKastLaius,
                                  //height: sinineKastKorgus,
                                  child: RichText(
                                    text: TextSpan(
                                      style: fontVaike,
                                      children: [
                                        TextSpan(
                                            text: '$hindAVG ', style: font),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: vahe * 2),
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
                          majorGridLines: const MajorGridLines(width: 0),
                          interval: 1,
                          labelRotation: 270,
                          visibleMinimum: 0,
                          maximum: 23.5,
                        ),
                        primaryYAxis: NumericAxis(
                          axisLine: AxisLine(width: 0),
                          isVisible: true,
                          labelRotation: 270,
                          title: AxisTitle(
                              text: 'EUR/MWh',
                              textStyle: fontVaike,
                              alignment: ChartAlignment.center),
                          labelStyle: TextStyle(fontSize: 0),
                        ),
                        series: <ChartSeries>[
                          ColumnSeries(
                            onPointTap: (pointInteractionDetails) {
                              int? rowIndex =
                                  pointInteractionDetails.pointIndex;
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text(
                                            "Kell $rowIndex töötavad seadmed: main boiler, veranda lamp"),
                                      ));
                            },
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            dataSource: lulitus.values.toList(),
                            xValueMapper: (data, _) => data[0],
                            yValueMapper: (data, _) => data[1],
                            dataLabelMapper: (data, _) => data[1].toString(),
                            pointColorMapper: (data, _) => Colors.green,
                            dataLabelSettings: DataLabelSettings(
                              isVisible: true,
                              labelAlignment: ChartDataLabelAlignment.bottom,
                              textStyle: fontVaike,
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
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 231, 17, 17)),
                              angle: 270,
                              alignment: ChartAlignment.center,
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
          ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.black,
                width: 2.0,
              ),
            ),
          ),
          child: SizedBox(
            height: 72,
            child: AppNavigationBar(i: 3),
          ),
        ));
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
