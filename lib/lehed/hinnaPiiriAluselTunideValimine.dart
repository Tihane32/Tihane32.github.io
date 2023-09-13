import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../funktsioonid/Elering.dart';
import '../main.dart';
import 'AbiLeht.dart';
import 'GraafikusseSeadmeteValik.dart';
import 'dynamicKoduLeht.dart';
import 'koduleht.dart';
import 'dart:math';
import 'package:testuus4/lehed/kaksTabelit.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'keskimiseHinnaAluselTundideValimine.dart';
import 'kopeeeriGraafikTundideValimine.dart';

class HinnaPiiriAluselTundideValimine extends StatefulWidget {
  final Function updateLulitusMap;
  HinnaPiiriAluselTundideValimine(
      {Key? key, required this.lulitusMap, required this.updateLulitusMap})
      : super(key: key);
  var lulitusMap;
  @override
  _HinnaPiiriAluselTundideValimineState createState() =>
      _HinnaPiiriAluselTundideValimineState(
          lulitusMap: lulitusMap, updateLulitusMap: updateLulitusMap);
}

int koduindex = 1;
Color valge = Colors.white;
Color green = Colors.green;
Color homme = valge;
Color tana = green;
TextStyle hommeFont = font;
TextStyle tanaFont = fontValge;
int? tappedIndex;
bool hommeNahtav = false;

class _HinnaPiiriAluselTundideValimineState
    extends State<HinnaPiiriAluselTundideValimine> {
  _HinnaPiiriAluselTundideValimineState(
      {Key? key, required this.lulitusMap, required this.updateLulitusMap});
  Function updateLulitusMap;

  var lulitusMap;
  int selectedRowIndex = -1;
  double hinnaPiir = 50.00;
  String paevNupp = 'Täna';
  String selectedPage = 'Hinnapiir';
  double vahe = 10;
  late double temp = 0;
  Color boxColor = sinineKast;
  int tund = 0;
  late Map<int, dynamic> lulitus;
  late Map<int, dynamic> lulitusTana;
  late Map<int, dynamic> lulitusHomme;
  late double hindAVG;

  Map<int, dynamic> hindPiirMap = {
    0: ['00.00', 0, false],
    1: ['01.00', 0, false],
    2: ['02.00', 0, true],
    3: ['03.00', 0, false],
    4: ['04.00', 0, true],
    5: ['05.00', 0, true],
    6: ['06.00', 0, false],
    7: ['07.00', 0, true],
    8: ['08.00', 0, false],
    9: ['09.00', 0, true],
    10: ['10.00', 0, false],
    11: ['11.00', 0, true],
    12: ['12.00', 0, true],
    13: ['13.00', 0, true],
    14: ['14.00', 0, true],
    15: ['15.00', 0, true],
    16: ['16.00', 0, true],
    17: ['17.00', 0, true],
    18: ['18.00', 0, false],
    19: ['19.00', 0, true],
    20: ['20.00', 0, false],
    21: ['21.00', 0, true],
    22: ['22.00', 0, false],
    23: ['23.00', 0, false],
    24: ['24.00', 0, false],
    25: ['25.00', 0, false],
  };

  Map<int, dynamic> hind = {
    0: ['', 0, ''],
    1: ['00.00', 0, ''],
    2: ['01.00', 0, ''],
    3: ['02.00', 0, ''],
    4: ['03.00', 0, ''],
    5: ['04.00', 0, ''],
    6: ['05.00', 0, ''],
    7: ['06.00', 0, ''],
    8: ['07.00', 0, ''],
    9: ['08.00', 0, ''],
    10: ['09.00', 0, ''],
    11: ['10.00', 0, ''],
    12: ['11.00', 0, ''],
    13: ['12.00', 0, ''],
    14: ['13.00', 0, ''],
    15: ['14.00', 0, ''],
    16: ['15.00', 0, ''],
    17: ['16.00', 0, ''],
    18: ['17.00', 0, ''],
    19: ['18.00', 0, ''],
    20: ['19.00', 0, ''],
    21: ['20.00', 0, ''],
    22: ['21.00', 0, ''],
    23: ['22.00', 0, ''],
    24: ['23.00', 0, ''],
  };

  Map<int, dynamic> lulitusMapVasakHP = {
    0: ['00.00', 0, false, 0],
    1: ['01.00', 0, false, 0],
    2: ['02.00', 0, true, 0],
    3: ['03.00', 0, false, 0],
    4: ['04.00', 0, true, 0],
    5: ['05.00', 0, true, 0],
    6: ['06.00', 0, false, 0],
    7: ['07.00', 0, true, 0],
    8: ['08.00', 0, false, 0],
    9: ['09.00', 0, true, 0],
    10: ['10.00', 0, false, 0],
    11: ['11.00', 0, true, 0],
    12: ['12.00', 0, true, 0],
    13: ['13.00', 0, true, 0],
    14: ['14.00', 0, true, 0],
    15: ['15.00', 0, true, 0],
    16: ['16.00', 0, true, 0],
    17: ['17.00', 0, true, 0],
    18: ['18.00', 0, false, 0],
    19: ['19.00', 0, true, 0],
    20: ['20.00', 0, false, 0],
    21: ['21.00', 0, true, 0],
    22: ['22.00', 0, false, 0],
    23: ['23.00', 0, false, 0],
  };

  Map<int, dynamic> lulitusMapParemHP = {
    0: ['00.00', 0, false, 0],
    1: ['01.00', 0, false, 0],
    2: ['02.00', 0, true, 0],
    3: ['03.00', 0, false, 0],
    4: ['04.00', 0, true, 0],
    5: ['05.00', 0, true, 0],
    6: ['06.00', 0, false, 0],
    7: ['07.00', 0, true, 0],
    8: ['08.00', 0, false, 0],
    9: ['09.00', 0, true, 0],
    10: ['10.00', 0, false, 0],
    11: ['11.00', 0, true, 0],
    12: ['12.00', 0, true, 0],
    13: ['13.00', 0, true, 0],
    14: ['14.00', 0, true, 0],
    15: ['15.00', 0, true, 0],
    16: ['16.00', 0, true, 0],
    17: ['17.00', 0, true, 0],
    18: ['18.00', 0, false, 0],
    19: ['19.00', 0, true, 0],
    20: ['20.00', 0, false, 0],
    21: ['21.00', 0, true, 0],
    22: ['22.00', 0, false, 0],
    23: ['23.00', 0, false, 0],
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
    var data = await getElering('tana');
    for (var i = 0; i < 24; i++) {
      lulitusTana[i][1] = data[i]['price'];
    }

    if (date.hour >=
        15) //Kui kell on vähem, kui 15 või on saadetud String 'täna'
    {
      var data = await getElering('homme');
      for (var i = 0; i < 24; i++) {
        lulitusHomme[i][1] = data[i]['price'];
      }
    }

    setState(() {
      if (date.hour >= 15) {
        hommeNahtav = true;
      }
      lulitus = lulitusTana;
      tund = date.hour;

      hindAVG = keskmineHindArvutaus(lulitus);

      temp = hindAVG / 4;

      hind = KeskHindString(hind, hindAVG);

      lulitusMapVasakHP =
          LulitusMapVasakVaartustamine(hinnaPiir, lulitus, lulitusMapVasakHP);
      lulitusMapParemHP =
          LulitusMapParemVaartustamine(hinnaPiir, lulitus, lulitusMapParemHP);
      lulitusMap = lulitusMapParemHP;
    });
    updateLulitusMap(lulitusMap);
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
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: vahe),
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
                              hindAVG = keskmineHindArvutaus(lulitus);
                              hind = KeskHindString(hind, hindAVG);
                              lulitusMapVasakHP = LulitusMapVasakVaartustamine(
                                  hinnaPiir, lulitus, lulitusMapVasakHP);
                              lulitusMapParemHP = LulitusMapParemVaartustamine(
                                  hinnaPiir, lulitus, lulitusMapParemHP);
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
                                        hindAVG = keskmineHindArvutaus(lulitus);
                                        hind = KeskHindString(hind, hindAVG);
                                        lulitusMapVasakHP =
                                            LulitusMapVasakVaartustamine(
                                                hinnaPiir,
                                                lulitus,
                                                lulitusMapVasakHP);
                                        lulitusMapParemHP =
                                            LulitusMapParemVaartustamine(
                                                hinnaPiir,
                                                lulitus,
                                                lulitusMapParemHP);
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
                                        borderRadius:
                                            BorderRadius.circular(30.0),
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
                                                  'Homne graafik ei ole hetkel kättesaadav \n Proovige uuesti kell 15.00'),
                                            ));
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 209, 205, 205),
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        border: Border.all(
                                          color:
                                              Color.fromARGB(255, 12, 12, 12),
                                          width: 3,
                                        )),
                                    child: Center(
                                        child: RichText(
                                      text:
                                          TextSpan(text: 'Homme', style: font),
                                      textAlign: TextAlign.center,
                                    )),
                                  ),
                                ))
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' Sisesta hinnapiir:  ',
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Container(
                            height: 30,
                            width: 80,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                onSubmitted: (value) {
                                  setState(() {
                                    hinnaPiir = double.tryParse(value) ?? 0;
                                    print(hinnaPiir);
                                    lulitusMapParemHP =
                                        LulitusMapParemVaartustamine(hinnaPiir,
                                            lulitus, lulitusMapParemHP);
                                    lulitusMapVasakHP =
                                        LulitusMapVasakVaartustamine(hinnaPiir,
                                            lulitus, lulitusMapVasakHP);
                                  });
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  hintText: hinnaPiir.toString(),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 3.0),
                                ),
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: Colors.black,
                ),
                SizedBox(height: vahe),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                TextSpan(text: 'EUR / MWh', style: fontVaike),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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
                        enableSideBySideSeriesPlacement: false,
                        primaryXAxis: CategoryAxis(
                          interval: 1,
                          labelRotation: 270,
                          visibleMaximum: 24,
                        ),
                        primaryYAxis: NumericAxis(
                          isVisible: false,
                          labelRotation: 270,
                          title: AxisTitle(text: ' €/kWh'),
                        ),
                        series: <ChartSeries>[
                          SplineSeries(
                            dataSource: hind.values.toList(),
                            xValueMapper: (inf, _) => inf[0],
                            yValueMapper: (inf, _) => inf[1],
                            dataLabelMapper: (data, _) => data[2],
                            dataLabelSettings: DataLabelSettings(
                              isVisible: true,
                              labelAlignment: ChartDataLabelAlignment.middle,
                              textStyle:
                                  TextStyle(fontSize: 15, color: Colors.black),
                              angle: 270,
                            ),
                            pointColorMapper: (data, _) => Colors.transparent,
                          ),
                          ColumnSeries(
                            width: 0.9,
                            onPointTap: (pointInteractionDetails) {
                              int? rowIndex =
                                  pointInteractionDetails.pointIndex;
                              print('Row Index: $rowIndex');
                              setState(() {
                                lulitusMapVasakHP = TunniVarviMuutus(
                                    rowIndex, lulitusMapVasakHP);
                                lulitusMapParemHP = TunniVarviMuutus(
                                    rowIndex, lulitusMapParemHP);
                                lulitusMap = lulitusMapParemHP;
                              });
                              updateLulitusMap(lulitusMap);
                            },
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                            dataSource: lulitusMapVasakHP.values.toList(),
                            xValueMapper: (data, _) => data[0],
                            yValueMapper: (data, _) {
                              final yValue = data[1];
                              if (yValue != 0) {
                                return yValue > -temp ? -temp : yValue;
                              } else {
                                return 0;
                              }
                            },
                            dataLabelMapper: (data, _) =>
                                data[1] < 0 ? data[3].toString() : '',
                            pointColorMapper: (data, _) => data[2]
                                ? Colors.green
                                : Color.fromARGB(255, 164, 159, 159),
                            dataLabelSettings: DataLabelSettings(
                              isVisible: true,
                              labelAlignment: ChartDataLabelAlignment.outer,
                              textStyle:
                                  TextStyle(fontSize: 15, color: Colors.black),
                              angle: 270,
                            ),
                          ),
                          ColumnSeries(
                            width: 0.9,
                            onPointTap: (pointInteractionDetails) {
                              int? rowIndex =
                                  pointInteractionDetails.pointIndex;
                              print('Row Index: $rowIndex');
                              setState(() {
                                lulitusMapParemHP = TunniVarviMuutus(
                                    rowIndex, lulitusMapParemHP);
                                lulitusMapVasakHP = TunniVarviMuutus(
                                    rowIndex, lulitusMapVasakHP);
                                lulitusMap = lulitusMapParemHP;
                              });
                              updateLulitusMap(lulitusMap);
                            },
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20)),
                            dataSource: lulitusMapParemHP.values.toList(),
                            xValueMapper: (data, _) => data[0],
                            yValueMapper: (data, _) {
                              final yValue = data[1];
                              if (yValue != 0) {
                                return yValue < temp ? temp : yValue;
                              } else {
                                return 0;
                              }
                            },
                            dataLabelMapper: (data, _) =>
                                data[1] > 0 ? data[3].toString() : '',
                            pointColorMapper: (data, _) => data[2]
                                ? Colors.green
                                : Color.fromARGB(255, 164, 159, 159),
                            dataLabelSettings: DataLabelSettings(
                              isVisible: true,
                              labelAlignment: ChartDataLabelAlignment.outer,
                              textStyle:
                                  TextStyle(fontSize: 15, color: Colors.black),
                              angle: 270,
                            ),
                          ),
                          SplineSeries(
                            dataSource: hindPiirMap.values.toList(),
                            xValueMapper: (inf, _) => inf[0],
                            yValueMapper: (inf, _) => inf[1],
                            pointColorMapper: (data, _) => Colors.black,
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

LulitusMapVasakVaartustamine(
    double hinnaPiir, Map<int, dynamic> lulitus1, Map<int, dynamic> lulitus2) {
  for (int key in lulitus1.keys) {
    double secondValue = lulitus1[key][1];

    lulitus2[key][3] = lulitus1[key][1];

    if (secondValue < hinnaPiir) {
      lulitus2[key][2] = true;
      lulitus2[key][1] = secondValue - hinnaPiir;
    } else {
      lulitus2[key][2] = false;
      lulitus2[key][1] = 0;
    }
  }

  print('lylitus vasak hinnapiir:');
  print('**************************');

  lulitus2.forEach((key, value) {
    print('$key: $value');
  });

  print('**************************');
  return lulitus2;
}

LulitusMapParemVaartustamine(
    double hinnaPiir, Map<int, dynamic> lulitus1, Map<int, dynamic> lulitus2) {
  for (int key in lulitus1.keys) {
    double secondValue = lulitus1[key][1];

    lulitus2[key][3] = lulitus1[key][1];

    if (secondValue >= hinnaPiir) {
      lulitus2[key][2] = false;
      lulitus2[key][1] = secondValue - hinnaPiir;
    } else {
      lulitus2[key][2] = true;
      lulitus2[key][1] = 0;
    }
  }

  print('lylitus parem hinnapiir:');
  print('**************************');

  lulitus2.forEach((key, value) {
    print('$key: $value');
  });

  print('**************************');
  return lulitus2;
}

TunniVarviMuutus(int? rowIndex, Map<int, dynamic> lulitusMap2) {
  print('vana');
  print(lulitusMap2[rowIndex]);
  if (lulitusMap2[rowIndex][2] == false) {
    lulitusMap2[rowIndex][2] = true;
  } else {
    lulitusMap2[rowIndex][2] = false;
  }
  print('uus');
  print(lulitusMap2[rowIndex]);
  return lulitusMap2;
}

KeskHindString(Map<int, dynamic> keskHind, double hindAVG) {
  hindAVG = ((hindAVG * pow(10.0, 2)).round().toDouble() / pow(10.0, 2));

  String summa = 'Keskmine $hindAVG';
  keskHind[0][2] = summa;
  return keskHind;
}
