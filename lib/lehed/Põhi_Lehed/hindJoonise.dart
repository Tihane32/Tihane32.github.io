import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:testuus4/funktsioonid/Elering.dart';
import 'package:flutter/services.dart';

import '../Tundide_valimis_Lehed/Graafik_Seadmete_valik/DynaamilineGraafikusseSeadmeteValik.dart';

import 'package:vibration/vibration.dart';
import 'package:testuus4/parameters.dart';
import 'dart:math';

import 'package:testuus4/Arhiiv/kaksTabelit.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import '../../Arhiiv/navigationBar.dart';
import 'package:testuus4/main.dart';
import '../../Arhiiv/drawer.dart';

class TulpDiagramm extends StatefulWidget {
  const TulpDiagramm({Key? key}) : super(key: key);

  @override
  _TulpDiagrammState createState() => _TulpDiagrammState();
}

int koduindex = 2;
Color valge = Colors.white;
Color green = Colors.green;
Color homme = valge;
Color tana = green;
TextStyle hommeFont = font;
TextStyle tanaFont = fontValge;
int? tappedIndex;

bool hommeNahtav = false;

class _TulpDiagrammState extends State<TulpDiagramm> {
  late Map<int, dynamic> lulitus;
  late Map<int, dynamic> lulitusTana;
  late Map<int, dynamic> lulitusHomme;
  late double temp = 0;
  late double hindAVG = 0;
  late double hindMin = 0;
  late double hindMax = 0;
  double vahe = 10;
  Color boxColor = sinineKast;
  int tund = 0;

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
    DateTime now = new DateTime.now();

    var date = new DateTime(
        now.year, now.month, now.day, now.hour); // tänase päeva leidmine

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
      12: ['12.00', 5.1, true],
      13: ['13.00', 22.55, true],
      14: ['14.00', 40.567, true],
      15: ['15.00', 44.4, true],
      16: ['16.00', 80.4, true],
      17: ['17.00', 121.2, true],
      18: ['18.00', 40.2, false],
      19: ['19.00', 0.0, true],
      20: ['20.00', 22.1, false],
      21: ['21.00', 13.5, true],
      22: ['22.00', 24.4, false],
      23: ['23.00', 44.1, false],
    };
    lulitusTana = lulitus;
    lulitusHomme = {
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
      12: ['12.00', 5.1, true],
      13: ['13.00', 22.55, true],
      14: ['14.00', 40.567, true],
      15: ['15.00', 44.4, true],
      16: ['16.00', 80.4, true],
      17: ['17.00', 121.2, true],
      18: ['18.00', 40.2, false],
      19: ['19.00', 0.0, true],
      20: ['20.00', 22.1, false],
      21: ['21.00', 13.5, true],
      22: ['22.00', 24.4, false],
      23: ['23.00', 44.1, false],
    };
    var data =
        await getElering(DateTime.now(), DateTime.now().add(Duration(days: 1)));
    print(data);
    for (var i = 0; i < 24; i++) {
      lulitusTana[i][1] = data[i];
    }

    if (date.hour >=
        15) //Kui kell on vähem, kui 15 või on saadetud String 'täna'
    {
      var data = await getElering(DateTime.now().add(Duration(days: 1)),
          DateTime.now().add(Duration(days: 2)));
      for (var i = 0; i < 24; i++) {
        lulitusHomme[i][1] = data[i];
      }
    }

    setState(() {
      if (date.hour >= 15) {
        hommeNahtav = true;
      }
      lulitus = lulitusTana;
      tund = date.hour;
      hindMax = maxLeidmine(lulitusTana);
      hindMin = minLeidmine(lulitusTana);
      hindAVG = keskmineHindArvutaus(lulitus);
      temp = hindAVG / 4;
      keskHind = keskmineHindMapVaartustamine(hindAVG, keskHind, lulitus);
    });
  }

  @override
  void initState() {
    norm();

    super.initState();
  }

  int i = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85),
        child: Column(
          children: [
            SizedBox(height: vahe / 2),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                      child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (tana == valge) {
                          lulitus = lulitusTana;
                          tana = green;
                          tanaFont = fontValge;
                          homme = valge;
                          hommeFont = font;
                          hindMax = maxLeidmine(lulitus);
                          hindMin = minLeidmine(lulitus);
                          hindAVG = keskmineHindArvutaus(lulitus);
                          keskHind = keskmineHindMapVaartustamine(
                              hindAVG, keskHind, lulitus);
                          temp = hindAVG / 4;
                          if (temp < 40 && hindAVG > 40) {
                            temp = 40;
                          } else if (hindAVG < 40) {
                            temp = hindAVG / 2;
                          }
                          HapticFeedback.vibrate();
                        } /*else {
                              lulitus = lulitusHomme;
                              tana = valge;
                              tanaFont = font;
                              homme = green;
                              hommeFont = fontValge;
                            }*/
                      });
                    },
                    child: Container(
                      width: 100,
                      height: 30,
                      decoration: BoxDecoration(
                          color: tana,
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: Colors.green,
                            width: 3,
                          )),
                      child: Center(
                          child: RichText(
                        text: TextSpan(
                          text: 'Täna',
                          style: tanaFont,
                        ),
                        textAlign: TextAlign.center,
                      )),
                    ),
                  )),
                  Center(
                      child: hommeNahtav
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (homme == valge) {
                                    lulitus = lulitusHomme;
                                    homme = green;
                                    hommeFont = fontValge;
                                    tana = valge;
                                    tanaFont = font;
                                    hindMax = maxLeidmine(lulitus);
                                    hindMin = minLeidmine(lulitus);
                                    hindAVG = keskmineHindArvutaus(lulitus);
                                    keskHind = keskmineHindMapVaartustamine(
                                        hindAVG, keskHind, lulitus);
                                    temp = hindAVG / 4;
                                    if (temp < 40 && hindAVG > 40) {
                                      temp = 40;
                                    } else if (hindAVG < 40) {
                                      temp = hindAVG / 2;
                                    }
                                    HapticFeedback.vibrate();
                                  } /*else {
                                lulitus = lulitusTana;
                                homme = valge;
                                hommeFont = font;
                                tana = green;
                                tanaFont = fontValge;
                              }*/
                                });
                              },
                              child: Container(
                                width: 100,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: homme,
                                    borderRadius: BorderRadius.circular(30.0),
                                    border: Border.all(
                                      color: Colors.green,
                                      width: 3,
                                    )),
                                child: Center(
                                    child: RichText(
                                  text: TextSpan(
                                    text: 'Homme',
                                    style: hommeFont,
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text(
                                              'Homne graafik ei ole hetkel kättesaadav\nProovige uuesti kell 15.00'),
                                        ));
                              },
                              child: Container(
                                width: 100,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 209, 205, 205),
                                    borderRadius: BorderRadius.circular(30.0),
                                    border: Border.all(
                                      color: Color.fromARGB(255, 12, 12, 12),
                                      width: 3,
                                    )),
                                child: Center(
                                    child: RichText(
                                  text: TextSpan(text: 'Homme', style: font),
                                  textAlign: TextAlign.center,
                                )),
                              ),
                            ))
                ],
              ),
            ),
            SizedBox(height: vahe / 2),
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
                                          text: 'Min: $hindMin',
                                          style: fontVaike),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            /* Align(
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
                                        TextSpan(text: '$hindAVG', style: font),
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
                                            text: 'EUR/MWh', style: fontVaike),
                                      ],
                                    ),
                                  ),
                                ),
                              )*/
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
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: fontVaike,
                                  children: [
                                    TextSpan(
                                        text: 'Kesk: $hindAVG',
                                        style: fontVaike),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          /* Align(
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                //width: sinineKastLaius,
                                //height: sinineKastKorgus,
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: fontVaike,
                                    children: [
                                      TextSpan(
                                          text: '$hindMin', style: font),
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
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: fontVaike,
                                    children: [
                                      TextSpan(
                                          text: 'EUR/MWh', style: fontVaike),
                                    ],
                                  ),
                                ),
                              ),
                            ),*/
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
                                        text: 'Max: $hindMax',
                                        style: fontVaike),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          /*Align(
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
                                      TextSpan(text: '$hindMax', style: font),
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
                                          text: 'EUR/MWh', style: fontVaike),
                                    ],
                                  ),
                                ),
                              ),
                            )*/
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: vahe / 2),
            IntrinsicHeight(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          '€/MWh',
                          style: fontVaike,
                        ),
                      )),
                  Positioned(
                    right: 0,
                    top: -5,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Hinna kujunemine"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CheckboxListTile(
                                  title: Text("Marginaal"),
                                  value: true,
                                  onChanged: (newValue) {
                                    setState(() {});
                                  },
                                ),
                                CheckboxListTile(
                                  title: Text("Kahetariifne"),
                                  value: false,
                                  onChanged: (newValue) {
                                    setState(() {});
                                  },
                                ),
                                // Add more CheckboxListTile widgets as needed
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close the dialog
                                },
                                child: Text("Close"),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Icon(Icons.settings),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Center(
                  child: RotatedBox(
                quarterTurns: 1,
                child: Container(
                  //width: double.infinity,
                  //height: double.infinity,
                  child: SfCartesianChart(
                    margin: EdgeInsets.all(0),
                    primaryXAxis: CategoryAxis(
                      majorGridLines: const MajorGridLines(width: 0),
                      interval: 1,
                      labelRotation: 270,
                      visibleMinimum: -0.35,
                      maximum: 23.5,
                    ),
                    primaryYAxis: NumericAxis(
                      anchorRangeToVisiblePoints: true,
                      axisLine: AxisLine(width: 0),
                      isVisible: true,
                      labelRotation: 270,
                      /* title: AxisTitle(
                            //text: 'EUR/MWh',
                            textStyle: fontVaike,
                            alignment: ChartAlignment.center),*/
                      labelStyle: TextStyle(fontSize: 0),
                    ),
                    series: <ChartSeries>[
                      ColumnSeries(
                        width: 0.9,
                        spacing: 0.1,
                        onPointTap: (pointInteractionDetails) {
                          int rowIndex = pointInteractionDetails.pointIndex!;
                          setState(() {
                            tappedIndex = rowIndex;
                          });
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                "Kell $rowIndex töötavad seadmed: main boiler, veranda lamp",
                              ),
                            ),
                          ).then((value) {
                            // Dialog dismissed
                            setState(() {
                              tappedIndex = null; // Reset tappedIndex to null
                            });
                          });
                        },
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        dataSource: lulitus.values.toList(),
                        xValueMapper: (data, _) => data[0],
                        yValueMapper: (data, _) {
                          final yValue = data[1];
                          return yValue < temp ? temp : yValue;
                        },
                        dataLabelMapper: (data, _) => data[1].toString(),
                        pointColorMapper: (data, index) {
                          if (tappedIndex == index) {
                            return Colors
                                .blue; // Set the color to blue if tapped
                          } else if (tund == index && tana == green) {
                            return Colors
                                .yellow; // Set the color to yellow if it corresponds to "tund" value
                          } else {
                            return Colors.green;
                          }
                        },
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          labelAlignment: ChartDataLabelAlignment.bottom,
                          textStyle: fontVaike,
                          angle: 270,
                        ),
                      ),
                      LineSeries(
                        dataSource: keskHind.values.toList(),
                        xValueMapper: (inf, _) => inf[0],
                        yValueMapper: (inf, _) => inf[1],
                        dataLabelMapper: (inf, _) => inf[2],
                        color: Colors.red,
                        dashArray: [20, 22],
                        dataLabelSettings: DataLabelSettings(
                          offset: Offset(-20, 0),
                          isVisible: true,
                          labelAlignment: ChartDataLabelAlignment.middle,
                          textStyle: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 231, 17, 17)),
                          angle: 270,
                          alignment: ChartAlignment.center,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ),
          ],
        ),
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

  keskHind[0] = [kell + '.00', hindAVG, 'Keskmine hind $hindAVG'];

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

  keskHind.forEach((key, value) {});

  return keskHind;
}

maxLeidmine(Map<int, dynamic> map) {
  double highest = 0;

  map.forEach((key, value) {
    double doubleValue = value[1] as double;

    if (doubleValue > highest) {
      highest = doubleValue;
    }
  });

  return highest;
}

minLeidmine(Map<int, dynamic> map) {
  double highest = 1000000;

  map.forEach((key, value) {
    double doubleValue = value[1] as double;

    if (doubleValue < highest) {
      highest = doubleValue;
    }
  });

  return highest;
}
