import 'package:flutter/material.dart';
import 'package:testuus4/lehed/AbiLeht.dart';
import 'package:testuus4/lehed/SeadmeGraafikLeht.dart';
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
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/funktsioonid/graafikGen2.dart';
import 'dart:convert';
import 'graafikuKoostamine.dart';
import 'package:testuus4/lehed/kaksTabelit.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:testuus4/funktsioonid/Elering.dart';
import 'seadmedKontoltNim.dart';

class SeadmeTarbimineLeht extends StatefulWidget {
  const SeadmeTarbimineLeht({Key? key, required this.seadmeNimi})
      : super(key: key);

  final String seadmeNimi;

  @override
  _SeadmeTarbimineLehtState createState() =>
      _SeadmeTarbimineLehtState(seadmeNimi: seadmeNimi);
}

class _SeadmeTarbimineLehtState extends State<SeadmeTarbimineLeht> {
  _SeadmeTarbimineLehtState({Key? key, required this.seadmeNimi});
  final String seadmeNimi;
  late Map<int, dynamic> lulitusMap;
  int selectedRowIndex = -1;
  late double hindAVG;
  String paevNupp = 'Täna';
  String selectedPage = 'Lülitus graafik';
  double vahe = 10;

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

  Future norm() async {
    setState(() {});
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
              Expanded(
                  child: Center(
                child: Container(
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
              ))
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
                    if (selectedPage == 'Lülitus graafik') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SeadmeGraafikuLeht(seadmeNimi: seadmeNimi)),
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
        body: Column(
          children: [
            SizedBox(height: vahe),
            Row(
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
                    width: 150,
                    height: 35,
                    child: Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: '  Seadme olek:  ',
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                      icon: loeSeadmeOlek(SeadmeteMap, seadmeNimi) == 'offline'
                          ? Icon(Icons.wifi_off_outlined)
                          : loeSeadmeOlek(SeadmeteMap, seadmeNimi) == 'on'
                              ? Icon(
                                  Icons.power_settings_new_rounded,
                                  color: Color.fromARGB(255, 77, 152, 81),
                                )
                              : Icon(
                                  Icons.power_settings_new_rounded,
                                  color: Colors.red,
                                )),
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(style: BorderStyle.solid, width: 1.0),
                ),
                child: Center(
                    child: Text(
                  'Tarbimise graafik:',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )),
              ),
            ),
            Expanded(
              child: EGraafik(value: '80646f81ad9a'),
            ),
          ],
        ),
      ),
    );
  }
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

class EGraafik extends StatefulWidget {
  final String value;

  EGraafik({required this.value});
  @override
  _EGraafikState createState() => _EGraafikState();
}

class _EGraafikState extends State<EGraafik> {
  List<_ChartData> chartData = [];

  Future<void> fetchData(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ajutineKasutajanimi = prefs.getString('Kasutajanimi');
    String? sha1Hash = prefs.getString('Kasutajaparool');

    var headers1 = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    var kasutajaAndmed = {
      'email': ajutineKasutajanimi,
      'password': sha1Hash,
      'var': '2',
    };
    var sisselogimiseUrl = Uri.parse('https://api.shelly.cloud/auth/login');
    var sisselogimiseVastus = await http.post(sisselogimiseUrl,
        headers: headers1, body: kasutajaAndmed);
    var vastusJSON =
        json.decode(sisselogimiseVastus.body) as Map<String, dynamic>;
    var token = vastusJSON['data']['token'];
    //Todo peab lisama beareri saamise
    var headers = {
      'Authorization': 'Bearer $token',
    };
    var data = {
      'id': value,
      'channel': '0',
      'date_range': 'custom',
      'date_from': '2023-04-01 00:00:00',
      'date_to': '2023-04-30 23:59:59',
    };

    var url = Uri.parse(
        'https://shelly-64-eu.shelly.cloud/statistics/relay/consumption');
    var res = await http.post(url, headers: headers, body: data);
    if (res.statusCode != 200)
      throw Exception('http.post error: statusCode= ${res.statusCode}');
    final jsonData = json.decode(res.body);
    final historyData = jsonData['data']['history'] as List<dynamic>;
    print(historyData);
    chartData = historyData
        .map((history) => _ChartData(DateTime.parse(history['datetime']),
            history['consumption'].toDouble()))
        .toList();
  }

  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, header: 'Tarbitud:');
    super.initState();
    fetchData(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
      child: FutureBuilder<void>(
        future: fetchData(widget.value),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: SfCartesianChart(
                primaryXAxis: DateTimeAxis(title: AxisTitle(text: 'Kuupäev')),
                primaryYAxis: NumericAxis(
                  labelFormat: '{value} Wh',
                  labelRotation: 45,
                ),
                tooltipBehavior: _tooltipBehavior,
                series: <ChartSeries<_ChartData, DateTime>>[
                  SplineSeries<_ChartData, DateTime>(
                    splineType: SplineType.monotonic,
                    dataSource: chartData,
                    xValueMapper: (_ChartData data, _) => data.date,
                    yValueMapper: (_ChartData data, _) => data.consumption,
                    enableTooltip: true,
                  ),
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.date, this.consumption);

  final DateTime date;
  final double consumption;
}
