import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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

class LylitusValimisLeht2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HinnaPiiriAluselTundideValimine(),
    );
  }
}

class HinnaPiiriAluselTundideValimine extends StatefulWidget {
  const HinnaPiiriAluselTundideValimine({Key? key}) : super(key: key);

  @override
  _HinnaPiiriAluselTundideValimineState createState() =>
      _HinnaPiiriAluselTundideValimineState();
}

int koduindex = 1;
Color valge = Colors.white;
Color green = Colors.green;
Color homme = valge;
Color tana = green;
TextStyle hommeFont = font;
TextStyle tanaFont = fontValge;
int? tappedIndex;

class _HinnaPiiriAluselTundideValimineState
    extends State<HinnaPiiriAluselTundideValimine> {
  late Map<int, dynamic> lulitusMap;
  int selectedRowIndex = -1;
  late double hindAVG;
  double hinnaPiir = 36.87;
  String paevNupp = 'Täna';
  String selectedPage = 'Hinnapiir';
  double vahe = 10;
  int valitudTunnid = 10;
  Color boxColor = sinineKast;
  late Map<int, dynamic> lulitus;
  late Map<int, dynamic> lulitusTana;
  late Map<int, dynamic> lulitusHomme;

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
    24: ['23.00', 0, false],
    25: ['23.00', 0, false],
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

  Map<int, dynamic> lulitusMapParem = {
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
    setState(() {
      lulitusMap = {
        0: ['00.00', 62.44, false],
        1: ['01.00', 34.676767, false],
        2: ['02.00', 0.5, true],
        3: ['03.00', 56.0, false],
        4: ['04.00', 45.4, true],
        5: ['05.00', 44.5, true],
        6: ['06.00', 3.78, false],
        7: ['07.00', 0.0, true],
        8: ['08.00', 56.33, false],
        9: ['09.00', 44.3, true],
        10: ['10.00', 4.2, false],
        11: ['11.00', 4.5, true],
        12: ['12.00', 4.7, true],
        13: ['13.00', 22.55, true],
        14: ['14.00', 40.567, true],
        15: ['15.00', 44.4, true],
        16: ['16.00', 0.0, true],
        17: ['17.00', 0.0, true],
        18: ['18.00', 0.0, false],
        19: ['19.00', 0.0, true],
        20: ['20.00', 22.78, false],
        21: ['21.00', 13.5, true],
        22: ['22.00', 24.56, false],
        23: ['23.00', 44.76, false],
      };

      hindAVG = keskmineHindArvutaus(lulitusMap);

      hind = KeskHindString(hind, hindAVG);

      lulitusMapVasak =
          LulitusMapVasakVaartustamine(hinnaPiir, lulitusMap, lulitusMapVasak);
      lulitusMapParem =
          LulitusMapParemVaartustamine(hinnaPiir, lulitusMap, lulitusMapParem);
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 115, 162, 195),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tundide valimine'),
            ],
          ),
          actions: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButton<String>(
                  value: selectedPage,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPage = newValue!;
                    });
                    if (selectedPage == 'Keskmine hind') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LylitusValimisLeht1()),
                      );
                    } else if (selectedPage == 'Minu eelistused') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AbiLeht()),
                      );
                    } else if (selectedPage == 'Kopeeri graafik') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => KopeeriGraafikTundideValik()),
                      );
                    }
                  },
                  underline: Container(), // or SizedBox.shrink()
                  items: <String>[
                    'Keskmine hind',
                    'Hinnapiir',
                    'Minu eelistused',
                    'Kopeeri graafik',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: vahe),
              Row(
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
                      child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (homme == valge) {
                          lulitus = lulitusHomme;
                          homme = green;
                          hommeFont = fontValge;
                          tana = valge;
                          tanaFont = font;
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
                  ))
                ],
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
                                  lulitusMapVasak =
                                      LulitusMapVasakVaartustamine(hinnaPiir,
                                          lulitusMap, lulitusMapVasak);
                                  print(hinnaPiir);
                                });
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                hintText: '36.87',
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
                            int? rowIndex = pointInteractionDetails.pointIndex;
                            print('Row Index: $rowIndex');
                            setState(() {
                              lulitusMapVasak =
                                  TunniVarviMuutus(rowIndex, lulitusMapVasak);
                              lulitusMapParem =
                                  TunniVarviMuutus(rowIndex, lulitusMapParem);
                            });
                          },
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                          dataSource: lulitusMapVasak.values.toList(),
                          xValueMapper: (data, _) => data[0],
                          yValueMapper: (data, _) => data[1],
                          dataLabelMapper: (data, _) => data[1] < 0
                              ? (((data[1] + hinnaPiir + 10) * pow(10.0, 2))
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
                            labelAlignment: ChartDataLabelAlignment.outer,
                            textStyle:
                                TextStyle(fontSize: 15, color: Colors.black),
                            angle: 270,
                          ),
                        ),
                        ColumnSeries(
                          width: 0.9,
                          onPointTap: (pointInteractionDetails) {
                            int? rowIndex = pointInteractionDetails.pointIndex;
                            print('Row Index: $rowIndex');
                            setState(() {
                              lulitusMapParem =
                                  TunniVarviMuutus(rowIndex, lulitusMapParem);
                              lulitusMapVasak =
                                  TunniVarviMuutus(rowIndex, lulitusMapVasak);
                            });
                          },
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20)),
                          dataSource: lulitusMapParem.values.toList(),
                          xValueMapper: (data, _) => data[0],
                          yValueMapper: (data, _) => data[1],
                          dataLabelMapper: (data, _) => data[1] > 0
                              ? (((data[1] + hinnaPiir - 10) * pow(10.0, 2))
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
        bottomNavigationBar: BottomNavigationBar(
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
                  size: 40,
                ),
              ),
              BottomNavigationBarItem(
                label: 'Kinnita',
                icon: Icon(
                  Icons.check_circle_outlined,
                  size: 40,
                ),
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
                    MaterialPageRoute(
                        builder: (context) => const SeadmeteListValimine()),
                  );
                } else if (koduindex == 1) {
                  Navigator.push(
                    //Kui vajutatakse Teie seade ikooni peale, siis viiakse Seadmetelisamine lehele
                    context,
                    MaterialPageRoute(
                        builder: (context) => DynaamilenieKoduLeht(
                              i: 1,
                            )),
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

LulitusMapVasakVaartustamine(
    double hinnaPiir, Map<int, dynamic> lulitus1, Map<int, dynamic> lulitus2) {
  for (int key in lulitus1.keys) {
    double secondValue = lulitus1[key][1];

    lulitus2[key][3] = lulitus1[key][1];

    if (secondValue < hinnaPiir) {
      lulitus2[key][2] = true;
      lulitus2[key][1] = secondValue - hinnaPiir - 10;
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
      lulitus2[key][1] = secondValue - hinnaPiir + 10;
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
