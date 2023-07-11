import 'package:flutter/material.dart';
import 'package:testuus4/lehed/AbiLeht.dart';
import 'package:testuus4/lehed/SeadmeTarbimisLeht.dart';
import 'seadmeteList.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testuus4/lehed/seadmedKontoltNim.dart';
import 'koduleht.dart';
import 'hinnaPiiriAluselTunideValimine.dart';
import 'dart:math';
import 'package:testuus4/lehed/kaksTabelit.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:testuus4/main.dart';

class SeadmeGraafikuLeht extends StatefulWidget {
  const SeadmeGraafikuLeht({Key? key, required this.seadmeNimi})
      : super(key: key);

  final String seadmeNimi;

  @override
  _SeadmeGraafikuLehtState createState() =>
      _SeadmeGraafikuLehtState(seadmeNimi: seadmeNimi);
}

class _SeadmeGraafikuLehtState extends State<SeadmeGraafikuLeht> {
  _SeadmeGraafikuLehtState({Key? key, required this.seadmeNimi});
  final String seadmeNimi;
  late Map<int, dynamic> lulitusMap;
  int selectedRowIndex = -1;
  late double hindAVG;
  String paevNupp = 'Täna';
  String selectedPage = 'Lülitus graafik';
  double vahe = 10;
  Color boxColor = sinineKast;
  BorderRadius borderRadius = BorderRadius.circular(5.0);
  Border border = Border.all(
    color: const Color.fromARGB(255, 0, 0, 0),
    width: 2,
  );

  Map<String, List<String>> SeadmeteMap = {
    'Keldri boiler': [
      'assets/boiler1.jpg',
      '123456',
      'off',
    ],
    'Veranda lamp': [
      'assets/verandaLamp1.png',
      '123456',
      'offline',
    ],
    'veranda lamp': [
      'assets/verandaLamp1.png',
      '123456',
      'on',
    ],
    'Keldri pump': [
      'assets/pump1.jpg',
      '123456',
      'on',
    ],
    'Garaazi pump': [
      'assets/pump1.jpg',
      '123456',
      'offline',
    ],
    'Main boiler': [
      'assets/boiler1.jpg',
      '123456',
      'on',
    ],
    'Sauna boiler': [
      'assets/boiler1.jpg',
      '123456',
      'off',
    ],
  };

  Map<int, dynamic> keskHind = {
    0: ['0', 0, 'Keskmine Hind'],
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

      keskHind = keskmineHindMapVaartustamine(hindAVG, keskHind, lulitusMap);
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
              Text(seadmeNimi),
              Spacer(),
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
                    if (selectedPage == 'Tarbimis graafik') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SeadmeTarbimineLeht(seadmeNimi: seadmeNimi)),
                      );
                    } else if (selectedPage == 'Üldinfo') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AbiLeht()),
                      );
                    }
                  },
                  underline: Container(), // or SizedBox.shrink()
                  items: <String>[
                    'Lülitus graafik',
                    'Tarbimis graafik',
                    'Üldinfo'
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
                      SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue,
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
                          child: Text(paevNupp),
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
                  height: sinineKastKorgus + 20,
                  child: Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                                text: '  Seadme staatus:    ', style: font),
                            TextSpan(
                              text: SeadmeteMap[seadmeNimi]![2],
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          iconSize: 40,
                          onPressed: () {
                            setState(() {
                              SeadmeteMap =
                                  muudaSeadmeOlek(SeadmeteMap, seadmeNimi);
                            });
                          },
                          icon: loeSeadmeOlek(SeadmeteMap, seadmeNimi) ==
                                  'offline'
                              ? Icon(Icons.wifi_off_outlined)
                              : loeSeadmeOlek(SeadmeteMap, seadmeNimi) == 'on'
                                  ? Icon(
                                      Icons.power_settings_new_rounded,
                                      color: Color.fromARGB(255, 77, 152, 81),
                                    )
                                  : Icon(
                                      Icons.power_settings_new_rounded,
                                      color: Colors.red,
                                    ),
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
              SizedBox(height: vahe), // A
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
                        TextSpan(text: '  Lülitus Graafik ', style: font),
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
                        title: AxisTitle(text: '€/MWh'),
                      ),
                      series: <ChartSeries>[
                        ColumnSeries(
                          width: 0.9,
                          onPointTap: (pointInteractionDetails) {
                            int? rowIndex = pointInteractionDetails.pointIndex;
                            print('Row Index: $rowIndex');
                            setState(() {
                              lulitusMap =
                                  TunniVarviMuutus(rowIndex, lulitusMap);
                            });
                          },
                          dataSource: lulitusMap.values.toList(),
                          xValueMapper: (data, _) => data[0],
                          yValueMapper: (data, _) => data[1],
                          dataLabelMapper: (data, _) =>
                              ((data[1] * pow(10.0, 2)).round().toDouble() /
                                      pow(10.0, 2))
                                  .toString() +
                              '€/MWh',
                          pointColorMapper: (data, _) => data[2]
                              ? Colors.green
                              : Color.fromARGB(255, 164, 159, 159),
                          dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            labelAlignment: ChartDataLabelAlignment.bottom,
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
                            labelAlignment: ChartDataLabelAlignment.outer,
                            textStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 231, 17, 17)),
                            angle: 270,
                            alignment: ChartAlignment.far,
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
    );
  }
}

eskmineHindArvutaus(Map<int, dynamic> lulitus) {
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

loeSeadmeOlek(Map<String, List<String>> SeadmeteMap, SeadmeNimi) {
  List<String>? deviceInfo = SeadmeteMap[SeadmeNimi];
  if (deviceInfo != null) {
    String status = deviceInfo[2];
    return status;
  }
  return null; // Device key not found in the map
}

muudaSeadmeOlek(Map<String, List<String>> SeadmeteMap, SeadmeNimi) {
  List<String>? deviceInfo = SeadmeteMap[SeadmeNimi];
  if (deviceInfo != null) {
    String status = deviceInfo[2];

    if (status == 'on') {
      deviceInfo[2] = 'off';
      SeadmeteMap[SeadmeNimi] = deviceInfo;
    } else if (status == 'off') {
      deviceInfo[2] = 'on';
      SeadmeteMap[SeadmeNimi] = deviceInfo;
    }
    return SeadmeteMap;
  }
  return SeadmeteMap; // Device key not found in the map
}
