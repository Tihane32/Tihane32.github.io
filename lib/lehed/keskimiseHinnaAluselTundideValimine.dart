import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import 'AbiLeht.dart';
import 'koduleht.dart';
import 'hinnaPiiriAluselTunideValimine.dart';
import 'dart:math';
import 'package:testuus4/lehed/kaksTabelit.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(LylitusValimisLeht1());
}

class LylitusValimisLeht1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: KeskmiseHinnaAluselTundideValimine(),
    );
  }
}

class KeskmiseHinnaAluselTundideValimine extends StatefulWidget {
  const KeskmiseHinnaAluselTundideValimine({Key? key}) : super(key: key);

  @override
  _KeskmiseHinnaAluselTundideValimineState createState() =>
      _KeskmiseHinnaAluselTundideValimineState();
}

int koduindex = 1;

class _KeskmiseHinnaAluselTundideValimineState
    extends State<KeskmiseHinnaAluselTundideValimine> {
  late Map<int, dynamic> lulitusMap;
  int selectedRowIndex = -1;
  late double hindAVG;
  String paevNupp = 'Täna';
  String selectedPage = 'Keskmine hind';
  double vahe = 10;
  int valitudTunnid = 10;
  Color boxColor = sinineKast;

  Map<int, dynamic> keskHind = {
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

  Map<int, dynamic> lulitusMap2 = {
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

      lulitusMap2 = LulitusMap2Vaartustamine(hindAVG, lulitusMap, lulitusMap2);
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tunndide valik'),
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
                    if (selectedPage == 'Hinnapiir') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LylitusValimisLeht2()),
                      );
                    } else if (selectedPage == 'Minu eelistused') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AbiLeht()),
                      );
                    } else if (selectedPage == 'Kopeeri graafik') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AbiLeht()),
                      );
                    }
                  },
                  underline: Container(), // or SizedBox.shrink()
                  items: <String>[
                    'Keskmine hind',
                    'Hinnapiir',
                    'Minu eelistused',
                    'Kopeeri graafik'
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
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: boxColor,
                    borderRadius: borderRadius,
                    border: border,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(3, 3),
                      ),
                    ],
                  ),
                  width: sinineKastLaius,
                  height: sinineKastKorgus,
                  child: Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(text: '  Kuvatav päev: ', style: font),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: paevNupp == 'Täna'
                              ? Colors.blue
                              : Color.fromARGB(0, 171, 161, 161),
                          border: paevNupp == 'Homme'
                              ? Border.all(color: Colors.blue, width: 2)
                              : null,
                        ),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              paevNupp = paevaMuutmine(paevNupp);
                            });
                          },
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            textStyle: MaterialStateProperty.all<TextStyle>(
                              TextStyle(fontSize: 20),
                            ),
                          ),
                          child: Text('Täna'),
                        ),
                      ),
                      SizedBox(width: 40),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: paevNupp == 'Homme'
                              ? Colors.blue
                              : Color.fromARGB(0, 171, 161, 161),
                          border: paevNupp == 'Täna'
                              ? Border.all(color: Colors.blue, width: 2)
                              : null,
                        ),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              paevNupp = paevaMuutmine(paevNupp);
                            });
                          },
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            textStyle: MaterialStateProperty.all<TextStyle>(
                              TextStyle(fontSize: 20),
                            ),
                          ),
                          child: Text('Homme'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: vahe),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: boxColor,
                    borderRadius: borderRadius,
                    border: border,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(3, 3),
                      ),
                    ],
                  ),
                  width: sinineKastLaius,
                  height: sinineKastKorgus,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: '  Valitud tunnid:  ',
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        WidgetSpan(
                          child: Container(
                            height: 25,
                            width: 45,
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
                                    print(valitudTunnid);
                                  });
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  hintText: '12',
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
              ),
              SizedBox(height: vahe),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: boxColor,
                    borderRadius: borderRadius,
                    border: border,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(3, 3),
                      ),
                    ],
                  ),
                  width: sinineKastLaius,
                  height: sinineKastKorgus,
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(text: '  Päeva keskmine: ', style: font),
                        TextSpan(
                          text: ((hindAVG * pow(10.0, 2)).round().toDouble() /
                                      pow(10.0, 2))
                                  .toString() +
                              '€/MWh',
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
              SizedBox(height: vahe),
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
                      ),
                      primaryYAxis: NumericAxis(
                        isVisible: false,
                        labelRotation: 270,
                        title: AxisTitle(text: ' €/kWh'),
                      ),
                      series: <ChartSeries>[
                        ColumnSeries(
                          width: 0.9,
                          onPointTap: (pointInteractionDetails) {
                            int? rowIndex = pointInteractionDetails.pointIndex;
                            print('Row Index: $rowIndex');
                            setState(() {
                              lulitusMap2 =
                                  TunniVarviMuutus(rowIndex, lulitusMap2);
                            });
                          },
                          dataSource: lulitusMap2.values.toList(),
                          xValueMapper: (data, _) => data[0],
                          yValueMapper: (data, _) => data[1],
                          dataLabelMapper: (data, _) =>
                              (((data[1] + hindAVG) * pow(10.0, 2))
                                          .round()
                                          .toDouble() /
                                      pow(10.0, 2))
                                  .toString() +
                              '€/MWh',
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
                          dataSource: keskHind.values.toList(),
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
                label: 'Tagasi',
                icon: Icon(Icons.arrow_back),
              ),
              BottomNavigationBarItem(
                label: 'Kinnita',
                icon: Icon(Icons.check_circle_outlined),
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

LulitusMap2Vaartustamine(
    var hindAVG, Map<int, dynamic> lulitus1, Map<int, dynamic> lulitus2) {
  for (int key in lulitus1.keys) {
    double hind = lulitus1[key][1];

    if (hind <= hindAVG) {
      lulitus2[key][1] = (hindAVG - hind) * (-1);
    } else {
      lulitus2[key][1] = hind - hindAVG;
    }
  }

  print('lylitus 2 kekminehind:');
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

paevaMuutmine(String paevNupp) {
  if (paevNupp == 'Täna') {
    paevNupp = 'Homme';
  } else if (paevNupp == 'Homme') {
    paevNupp = 'Täna';
  }
  return paevNupp;
}
