import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testuus4/lehed/Tundide_valimis_Lehed/DynaamilineTundideValimine.dart';
import 'package:testuus4/lehed/GraafikusseSeadmeteValik.dart';
import 'package:testuus4/lehed/P%C3%B5hi_Lehed/dynamicKoduLeht.dart';
import '../../funktsioonid/Elering.dart';
import '../../funktsioonid/KeskmineHindArvutus.dart';
import '../../funktsioonid/salvestaSeadistus.dart';
import '../../main.dart';
import '../../widgets/AbiLeht.dart';
import '../../widgets/hoitatus.dart';
import '../Põhi_Lehed/koduleht.dart';
import 'hinnaPiiriAluselTunideValimine.dart';
import 'dart:math';
import 'package:testuus4/Arhiiv/kaksTabelit.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'kopeeeriGraafikTundideValimine.dart';
import 'package:testuus4/lehed/Tundide_valimis_Lehed/DynaamilineTundideValimine.dart';

class KeskmiseHinnaAluselTundideValimine extends StatefulWidget {
  final Function updateLulitusMap;

  KeskmiseHinnaAluselTundideValimine(
      {Key? key,
      required this.lulitusMap,
      required this.updateLulitusMap,
      required this.valitudSeadmed})
      : super(key: key);
  final valitudSeadmed;
  var lulitusMap;
  @override
  _KeskmiseHinnaAluselTundideValimineState createState() =>
      _KeskmiseHinnaAluselTundideValimineState(
          valitudSeadmed: valitudSeadmed,
          lulitusMap: lulitusMap,
          updateLulitusMap: updateLulitusMap);
}

int koduindex = 1;

Color valge = Colors.white;
Color green = Colors.green;

class _KeskmiseHinnaAluselTundideValimineState
    extends State<KeskmiseHinnaAluselTundideValimine> {
  _KeskmiseHinnaAluselTundideValimineState({
    Key? key,
    required this.lulitusMap,
    required this.updateLulitusMap,
    required this.valitudSeadmed,
  });
  Function updateLulitusMap;
  var lulitusMap;
  var valitudSeadmed;
  Color homme = valge;
  Color tana = green;
  TextStyle hommeFont = font;
  TextStyle tanaFont = fontValge;
  bool hommeNahtav = false;
  int selectedRowIndex = -1;
  String selectedPage = 'Keskmine hind';
  double vahe = 10;
  int valitudTunnid = 10;
  Color boxColor = sinineKast;
  late Map<int, dynamic> lulitus;
  late Map<int, dynamic> lulitusTana;
  late Map<int, dynamic> lulitusHomme;
  late double hindAVG;
  late double temp = 0;
  Map<int, dynamic> keskHind = {
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

  Map<int, dynamic> lulitusMapVasak = {
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

  Map<int, dynamic> lulitusMapParem = {
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
      lulitus = lulitusTana;
      if (date.hour >= 15) {
        hommeNahtav = true;
        lulitus = lulitusHomme;
        homme = green;
        tana = valge;
        hommeFont = fontValge;
        tanaFont = font;
      }

      hindAVG = keskmineHindArvutaus(lulitus);
      temp = hindAVG / 4;

      hind = KeskHindString(hind, hindAVG);

      keskHind = keskmineHindMapVaartustamine(hindAVG, keskHind, lulitus);

      lulitus = OdavimadTunnidOn(lulitus, valitudTunnid);

      lulitusMapVasak =
          LulitusMapVasakVaartustamine(hindAVG, lulitus, lulitusMapVasak);
      lulitusMapParem =
          LulitusParemVaartustamine(hindAVG, lulitus, lulitusMapParem);
      lulitusMap = lulitusMapParem;
    });
    updateLulitusMap(lulitusMap, 'Odavaimad tunnid');
  }

  @override
  void initState() {
    int trueCount = 0;
    String valitudSeade = '';

    for (var entry in valitudSeadmed.entries) {
      if (entry.value) {
        trueCount++;
        valitudSeade = entry.key;
      }
    }
    if (trueCount == 1) {
      valitudTunnid = seadmeteMap[valitudSeade]['Valitud_Tunnid'];
    }

    for (int i = 0; i < 24; i++) {
      String key = i < 10 ? '0$i.00' : '$i.00';
      keskHind[i] = [key, 0, false];
    }
    norm();
    super.initState();
    _loadGraafikuSeaded;
  }

  _loadGraafikuSeaded() async {
    //graafikuSeaded = await loadGraafikuSeaded();
    setState(() {}); // To rebuild the widget once data is loaded
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          elevation: 0.0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          pinned: true,
          title: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (tana == valge) {
                            paevAbi = "täna";
                            lulitus = lulitusTana;
                            tana = green;
                            tanaFont = fontValge;
                            homme = valge;
                            hommeFont = font;
                            hindAVG = keskmineHindArvutaus(lulitus);
                            hind = KeskHindString(hind, hindAVG);
                            keskHind = keskmineHindMapVaartustamine(
                                hindAVG, keskHind, lulitus);
                            lulitus = OdavimadTunnidOn(lulitus, valitudTunnid);
                            lulitusMapVasak = LulitusMapVasakVaartustamine(
                                hindAVG, lulitus, lulitusMapVasak);
                            lulitusMapParem = LulitusParemVaartustamine(
                                hindAVG, lulitus, lulitusMapParem);
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
                    ),
                    //SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                    Container(
                      child: hommeNahtav
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (homme == valge) {
                                    paevAbi = "homme";
                                    lulitus = lulitusHomme;
                                    homme = green;
                                    hommeFont = fontValge;
                                    tana = valge;
                                    tanaFont = font;
                                    hindAVG = keskmineHindArvutaus(lulitus);
                                    hind = KeskHindString(hind, hindAVG);
                                    keskHind = keskmineHindMapVaartustamine(
                                        hindAVG, keskHind, lulitus);
                                    lulitus = OdavimadTunnidOn(
                                        lulitus, valitudTunnid);
                                    lulitusMapVasak =
                                        LulitusMapVasakVaartustamine(
                                            hindAVG, lulitus, lulitusMapVasak);
                                    lulitusMapParem = LulitusParemVaartustamine(
                                        hindAVG, lulitus, lulitusMapParem);
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
                                Hoiatus(context,
                                    'Homne graafik ei ole hetkel kättesaadav \n Proovige uuesti kell 15.00');
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
                            ),
                    )
                  ],
                ),
              ),
              Container(
                height: 20,
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(text: '  Valitud tunnid:  ', style: font),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.bottom,
                        child: Container(
                          height: 20,
                          width: 45,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Center(
                            child: TextField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onSubmitted: (value) {
                                  setState(() {
                                    int parsedValue = int.tryParse(value) ?? 0;
                                    if (parsedValue > 24) {
                                      parsedValue = 24;
                                    }
                                    valitudTunnid = parsedValue;
                                    salvestaSeadistus('Valitud_Tunnid',
                                        valitudTunnid, valitudSeadmed);
                                    lulitus = OdavimadTunnidOn(
                                        lulitus, valitudTunnid);
                                    lulitusMapVasak =
                                        LulitusMapVasakVaartustamine(
                                            hindAVG, lulitus, lulitusMapVasak);
                                    lulitusMapParem = LulitusParemVaartustamine(
                                        hindAVG, lulitus, lulitusMapParem);
                                  });
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  hintText: valitudTunnid.toString(),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 3.0),
                                ),
                                style: font),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  print(graafikuSeaded);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DynamilineTundideValimine(
                              valitudSeadmed: valitudSeadmed,
                              i: 5,
                              luba: '',
                              eelmineleht: 0,
                            )),
                  );
                },
                icon: Icon(
                  Icons.settings,
                  color: Colors.black,
                  size: 30.0,
                ))
          ],
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                  color: Colors.white,
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
                                    labelAlignment:
                                        ChartDataLabelAlignment.middle,
                                    textStyle: fontVaike,
                                    angle: 270,
                                  ),
                                  pointColorMapper: (data, _) =>
                                      Colors.transparent,
                                ),
                                ColumnSeries(
                                  width: 0.9,
                                  spacing: 0.1,
                                  onPointTap: (pointInteractionDetails) {
                                    int? rowIndex =
                                        pointInteractionDetails.pointIndex;
                                    setState(() {
                                      lulitusMapVasak = TunniVarviMuutus(
                                          rowIndex, lulitusMapVasak);
                                      lulitusMapParem = TunniVarviMuutus(
                                          rowIndex, lulitusMapParem);
                                      lulitusMap = lulitusMapParem;
                                    });
                                    print("tana $tana");
                                    updateLulitusMap(
                                        lulitusMap, 'Odavaimad tunnid');
                                  },
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20)),
                                  dataSource: lulitusMapVasak.values.toList(),
                                  xValueMapper: (data, _) => data[0],
                                  yValueMapper: (data, _) {
                                    final yValue = data[1];
                                    if (yValue != 0) {
                                      return yValue > -temp ? -temp : yValue;
                                    } else {
                                      return 0;
                                    }
                                  },
                                  dataLabelMapper: (data, _) => data[1] < 0
                                      ? (((data[1] + hindAVG) * pow(10.0, 2))
                                                  .round()
                                                  .toDouble() /
                                              pow(10.0, 2))
                                          .toString()
                                      : '',
                                  pointColorMapper: (data, _) => data[2]
                                      ? Colors.green
                                      : const Color.fromARGB(
                                          255, 164, 159, 159),
                                  dataLabelSettings: DataLabelSettings(
                                    isVisible: true,
                                    labelAlignment:
                                        ChartDataLabelAlignment.bottom,
                                    offset: const Offset(0, 45),
                                    textStyle: fontVaike,
                                    angle: 270,
                                  ),
                                ),
                                ColumnSeries(
                                  width: 0.9,
                                  spacing: 0.1,
                                  onPointTap: (pointInteractionDetails) {
                                    int? rowIndex =
                                        pointInteractionDetails.pointIndex;

                                    setState(() {
                                      lulitusMapVasak = TunniVarviMuutus(
                                          rowIndex, lulitusMapVasak);
                                      lulitusMapParem = TunniVarviMuutus(
                                          rowIndex, lulitusMapParem);
                                      lulitusMap = lulitusMapParem;
                                    });
                                    updateLulitusMap(
                                        lulitusMap, 'Odavaimad tunnid');
                                  },
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                  dataSource: lulitusMapParem.values.toList(),
                                  xValueMapper: (data, _) => data[0],
                                  yValueMapper: (data, _) {
                                    final yValue = data[1];
                                    if (yValue != 0) {
                                      return yValue < temp ? temp : yValue;
                                    } else {
                                      return 0;
                                    }
                                  },
                                  dataLabelMapper: (data, _) => data[1] > 0
                                      ? (((data[1] + hindAVG) * pow(10.0, 2))
                                                  .round()
                                                  .toDouble() /
                                              pow(10.0, 2))
                                          .toString()
                                      : '',
                                  pointColorMapper: (data, _) => data[2]
                                      ? Colors.green
                                      : Color.fromARGB(255, 164, 159, 159),
                                  dataLabelSettings: DataLabelSettings(
                                    isVisible: true,
                                    labelAlignment:
                                        ChartDataLabelAlignment.bottom,
                                    offset: Offset(0, -45),
                                    textStyle: fontVaike,
                                    angle: 270,
                                  ),
                                ),
                                SplineSeries(
                                  dataSource: keskHind.values.toList(),
                                  xValueMapper: (inf, _) => inf[0],
                                  yValueMapper: (inf, _) => inf[1],
                                  pointColorMapper: (data, _) => Colors.black,
                                ),
                              ],
                            ),
                          ))));
            },
            childCount: 1,
          ),
        ),
      ],
    );
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

  for (int i = 1; i < 24; i++) {
    if (i < 10) {
      kell = '0$i';
    } else {
      kell = '$i';
    }

    keskHind[i] = [kell + '.00', 0, ''];

    if (tund == i) {
      keskHind[tund] = [kell + '.00', 0, ''];
    }
  }

  kell = '24.00';

  keskHind[24] = [kell + '.00', 0, ''];

  kell = '25.00';

  keskHind[25] = [kell + '.00', 0, ''];

  keskHind.forEach((key, value) {});

  return keskHind;
}

KeskHindString(Map<int, dynamic> keskHind, double hindAVG) {
  hindAVG = ((hindAVG * pow(10.0, 2)).round().toDouble() / pow(10.0, 2));

  String summa = 'Keskmine $hindAVG';
  keskHind[0][2] = summa;
  return keskHind;
}

OdavimadTunnidOn(Map<int, dynamic> lulitus, int tunnid) {
// Convert the map to a list of entries and sort it by the price
  var sortedEntries = lulitus.entries.toList()
    ..sort((a, b) => a.value[1].compareTo(b.value[1]));

  // Update the first 12 to true
  for (int i = 0; i < tunnid; i++) {
    var key = sortedEntries[i].key;
    lulitus[key][2] = true;
  }

  // Update the rest to false
  for (int i = tunnid; i < sortedEntries.length; i++) {
    var key = sortedEntries[i].key;
    lulitus[key][2] = false;
  }

  return lulitus;
}

LulitusMapVasakVaartustamine(
    var hindAVG, Map<int, dynamic> lulitus1, Map<int, dynamic> lulitus2) {
  for (int key in lulitus1.keys) {
    double hind = lulitus1[key][1];

    if (hind <= hindAVG) {
      lulitus2[key][1] = hind - hindAVG;
    } else {
      lulitus2[key][1] = 0;
    }
    lulitus2[key][2] = lulitus1[key][2];
  }

  return lulitus2;
}

LulitusParemVaartustamine(
    var hindAVG, Map<int, dynamic> lulitus1, Map<int, dynamic> lulitus3) {
  for (int key in lulitus1.keys) {
    double hind = lulitus1[key][1];

    if (hind > hindAVG) {
      lulitus3[key][1] = hind - hindAVG;
    } else {
      lulitus3[key][1] = 0;
    }
    lulitus3[key][2] = lulitus1[key][2];
  }

  return lulitus3;
}

TunniVarviMuutus(int? rowIndex, Map<int, dynamic> lulitusMap2) {
  if (lulitusMap2[rowIndex][2] == false) {
    lulitusMap2[rowIndex][2] = true;
  } else {
    lulitusMap2[rowIndex][2] = false;
  }
  return lulitusMap2;
}