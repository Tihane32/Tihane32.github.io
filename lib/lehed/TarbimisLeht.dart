import 'package:flutter/material.dart';
import 'package:testuus4/funktsioonid/maksumusSeadmeKohta.dart';
import 'package:testuus4/lehed/SeadmeGraafikLeht.dart';
import 'package:testuus4/lehed/SeadmeTarbimisLeht.dart';
import 'SeadmeYldInfo.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:testuus4/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TarbimisLeht extends StatefulWidget {
  const TarbimisLeht(
      {Key? key, required this.seadmeNimi, required this.SeadmeteMap})
      : super(key: key);

  final String seadmeNimi;
  final Map<String, List<String>> SeadmeteMap;
  @override
  _TarbimisLehtState createState() =>
      _TarbimisLehtState(seadmeNimi: seadmeNimi, SeadmeteMap: SeadmeteMap);
}

int koduindex = 2;

class _TarbimisLehtState extends State<TarbimisLeht> {
  _TarbimisLehtState(
      {Key? key, required this.seadmeNimi, required this.SeadmeteMap});
  Map<String, List<String>> SeadmeteMap;
  final String seadmeNimi;
  late Map<int, dynamic> lulitusMap;
  int selectedRowIndex = -1;
  late double hindAVG = 0;
  bool graafikuNahtavus = true;
  String selectedPage = 'Tarbimisgraafik';
  double vahe = 10;
  Color boxColor = sinineKast;
  BorderRadius borderRadius = BorderRadius.circular(5.0);
  Border border = Border.all(
    color: const Color.fromARGB(255, 0, 0, 0),
    width: 2,
  );

  @override
  void initState() {
    seadmeMaksumus(SeadmeteMap[seadmeNimi]![1]);
    super.initState();
  }

  int i = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Color.fromARGB(255, 189, 216, 225), //TaustavÃ¤rv

        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 115, 162, 195),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                seadmeNimi,
                style: GoogleFonts.roboto(
                  textStyle: const TextStyle(fontSize: 25),
                ),
              )
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
                    if (selectedPage == 'Lülitusgraafik') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SeadmeGraafikuLeht(
                                  seadmeNimi: seadmeNimi,
                                  SeadmeteMap: SeadmeteMap,
                                )),
                      );
                    } else if (selectedPage == 'Üldinfo') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SeadmeYldinfoLeht(seadmeNimi: seadmeNimi)),
                      );
                    }
                  },
                  underline: Container(), // or SizedBox.shrink()
                  items: <String>[
                    'Lülitusgraafik',
                    'Tarbimisgraafik',
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
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: vahe),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(text: 'Seadme olek:    ', style: font),
                                TextSpan(
                                    text: SeadmeteMap[seadmeNimi]![2],
                                    style: font),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Container(
                      height: 1,
                      width: double.infinity,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: vahe / 4),

                  /* Center(
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
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: fontVaike,
                                    children: [
                                      TextSpan(
                                          text: '   Päeva miinimum:',
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
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: fontVaike,
                                    children: [
                                      TextSpan(
                                          text: '   $hindMin', style: font),
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
                                          text: '   EUR/MWh', style: fontVaike),
                                    ],
                                  ),
                                ),
                              ),
                            ),
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
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: vahe * 2),*/
                  Visibility(
                    visible: graafikuNahtavus,
                    child: Center(
                      child: MGraafik(value: SeadmeteMap[seadmeNimi]![1]),
                    ),
                  ),
                  Visibility(
                    visible: !graafikuNahtavus,
                    child: Center(
                      child: EGraafik(value: SeadmeteMap[seadmeNimi]![1]),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

class MGraafik extends StatefulWidget {
  final String value;

  MGraafik({required this.value});
  @override
  _MGraafikState createState() => _MGraafikState();
}

class _MGraafikState extends State<MGraafik> {
  List<_ChartData> chartData = [];
  Map<DateTime, double> temp = {};
  Map<dynamic, dynamic> consumption = {};
  bool graafik = false;
  int asi = 40;
  String total = '';
  fetchData(value) async {
    DateTime currentDateTime = DateTime.now();

    // Calculate the first day of the current month
    DateTime firstDayOfMonth =
        DateTime(currentDateTime.year, currentDateTime.month);

    // Calculate the last day of the current month
    DateTime lastDayOfMonth =
        DateTime(currentDateTime.year, currentDateTime.month + 1, 1);
    print('lastday');
    print(lastDayOfMonth);
    // Create the map with dates and initial values of 0
    //Map<DateTime, double> temp = {};
    setState(() {
      for (DateTime date = firstDayOfMonth;
          date.isBefore(lastDayOfMonth);
          date = date.add(Duration(days: 1))) {
        temp[date] = 0.0;
      }
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonData = prefs.getString('consumption') ?? '[]';
    List<dynamic> decodedList = jsonDecode(jsonData);
    print('jeeseeseses');
    print(decodedList.length);
    for (var j = 0; j < decodedList.length; j++) {
      dynamic i = 0;
      String k = '';
      i = decodedList[j]['consumption'];
      k = i.toStringAsFixed(2);
      consumption[j] = k;
    }
    print(consumption);
    double abi = 0;
    temp = await seadmeMaksumus(value);
    for (DateTime date = firstDayOfMonth;
        date.isBefore(lastDayOfMonth);
        date = date.add(Duration(days: 1))) {
      if (!temp.containsKey(date)) {
        temp[date] = 0.0;
      }
    }

    setState(() {
      temp = temp.map((key, value) =>
          MapEntry(key, double.parse(value.toStringAsFixed(3))));
      temp.values.forEach((value) {
        abi = abi + value;
        print("abi");
        print(abi);
      });
      total = abi.toStringAsFixed(3);
    });
  }

  /*getTotal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    total = prefs.getString('hind')!;
    print('$total osososadasdasdsad');
    return total;
  }*/
  Future<void> fetchData2(value) async {
    DateTime currentDateTime = DateTime.now();

    // Calculate the first day of the current month
    DateTime firstDayOfMonth =
        DateTime(currentDateTime.year, currentDateTime.month);

    // Calculate the last day of the current month
    DateTime lastDayOfMonth =
        DateTime(currentDateTime.year, currentDateTime.month + 1, 0);

    // Create the list of _ChartData objects with dates and initial consumption values of 0
    setState(() {
      total = '';
      for (DateTime date = firstDayOfMonth;
          date.isBefore(lastDayOfMonth);
          date = date.add(Duration(days: 1))) {
        chartData.add(_ChartData(date, 0.0));
      }
    });

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
      'date_from': '2023-08-01 00:00:00',
      'date_to': '2023-08-31 23:59:59',
    };

    var url = Uri.parse(
        'https://shelly-64-eu.shelly.cloud/statistics/relay/consumption');
    var res = await http.post(url, headers: headers, body: data);
    if (res.statusCode != 200)
      throw Exception('http.post error: statusCode= ${res.statusCode}');
    final jsonData = json.decode(res.body);
    final historyData = jsonData['data']['history'] as List<dynamic>;
    print(historyData);
    setState(() {
      chartData = historyData
          .map((history) => _ChartData(DateTime.parse(history['datetime']),
              history['consumption'].toDouble()))
          .toList();
      total = jsonData['data']['total'].toString();
    });

    print(chartData);
    print('total');
    print(jsonData['data']['history'][1]['consumption']);
    print(jsonData['data']['total']);
    String dataString = jsonEncode(jsonData['data']['history']);
    prefs.setString('consumption', dataString);
    prefs.setString('total', total);

    print('$total ososo');
    print(prefs.getString('consumption'));
  }

  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, header: 'Maksumus:');
    fetchData2(widget.value);
    fetchData(widget.value);
    //total = getTotal().toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Align(
        child: Container(
          alignment: Alignment.center,

          //width: sinineKastLaius,
          //height: sinineKastKorgus,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: font,
              children: [
                TextSpan(text: 'Seadme maksumus', style: fontSuur),
              ],
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: Container(
          height: 1,
          width: double.infinity,
          color: Colors.black,
        ),
      ),
      Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [],
        ),
      ),
      Align(
        child: Visibility(
            visible: graafik,
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    graafik = !graafik;
                    //graafikuNahtavus = !graafikuNahtavus;
                  });
                },
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.bar_chart,
                      size: 30,
                    ),
                  ),
                ))),
      ),
      Align(
        child: Visibility(
            visible: !graafik,
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    graafik = !graafik;
                    //graafikuNahtavus = !graafikuNahtavus;
                  });
                },
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.table_rows_outlined,
                      size: 30,
                    ),
                  ),
                ))),
      ),
      Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Center(
            child: Column(children: [
              Align(
                child: Container(
                  alignment: Alignment.center,

                  //width: sinineKastLaius,
                  //height: sinineKastKorgus,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: font,
                      children: [
                        TextSpan(text: 'Kokku: $total Eurot', style: font),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !graafik,
                child: Container(
                  height: MediaQuery.of(context).size.height * 2,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: SfCartesianChart(
                      axes: [
                        NumericAxis(
                          name: 'firstAxis',
                          isVisible: false,
                          title: AxisTitle(
                            text: 'Eurot',
                            textStyle: fontVaike,
                          ),
                          labelStyle: fontVaike,
                          /*labelFormat: 'Wh',
                                labelRotation: 90,*/
                        ),
                        NumericAxis(
                          name: 'secondAxis',
                          isVisible: false,
                          title: AxisTitle(
                            text: 'test',
                            textStyle: fontVaike,
                          ),
                        ),
                      ],
                      primaryYAxis: NumericAxis(
                        isVisible: false,
                        title: AxisTitle(
                          text: 'test',
                          textStyle: fontVaike,
                        ),
                      ),
                      primaryXAxis: DateTimeAxis(
                        interval: 1,
                        labelRotation: 270,
                        labelStyle: fontVaike,
                        dateFormat: DateFormat('dd.MM'),
                        minimum: temp.entries.first.key,
                      ),
                      tooltipBehavior: _tooltipBehavior,
                      series: <ChartSeries>[
                        StackedColumnSeries<MapEntry<DateTime, double>,
                            DateTime>(
                          color: Colors.green,
                          width: 0.9,
                          groupName: 'A',
                          //splineType: SplineType.monotonic,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          dataSource: temp.entries.toList(),
                          yAxisName: 'firstAxis',
                          xValueMapper: (entry, _) => entry.key,
                          yValueMapper: (entry, _) => entry.value,
                          enableTooltip: false,
                          dataLabelSettings: DataLabelSettings(
                            offset: Offset(0, -10),
                            isVisible: true,
                            labelAlignment: ChartDataLabelAlignment.outer,
                            textStyle: fontVaike,
                            angle: 270,
                          ),
                          dataLabelMapper: (entry, _) {
                            // Display the data label only if the consumption is not 0
                            if (entry.value == 0) {
                              return ''; // Customize this as needed
                            } else {
                              String temp3 = entry.value.toString();
                              return '$temp3€';
                            }
                          },
                        ),
                        StackedColumnSeries<_ChartData, DateTime>(
                          color: Colors.blue,
                          width: 0.9,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          dataSource: chartData,
                          yAxisName: 'secondAxis',
                          xValueMapper: (_ChartData data, _) => data.date,
                          yValueMapper: (_ChartData data, _) {
                            final yValue = data.consumption;
                            return yValue == 0
                                ? 0
                                : yValue < asi
                                    ? asi
                                    : yValue;
                          },
                          enableTooltip: false,
                          dataLabelSettings: DataLabelSettings(
                            offset: Offset(0, -20),
                            isVisible: true,
                            labelAlignment: ChartDataLabelAlignment.outer,
                            textStyle: fontVaike,
                            angle: 270,
                          ),
                          dataLabelMapper: (_ChartData data, _) {
                            // Display the data label only if the consumption is not 0
                            if (data.consumption == 0) {
                              return ''; // Customize this as needed
                            } else {
                              String temp3 =
                                  data.consumption.toStringAsFixed(2);
                              return '${temp3}Wh';
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                  visible: graafik,
                  child: Row(
                    children: [
                      Center(
                        child: DataTable(
                          dataRowHeight: 20,
                          decoration: BoxDecoration(),
                          columns: const [
                            DataColumn(label: Text('Kuupäev')),
                            DataColumn(label: Text('Eurot')),
                          ],
                          rows: temp.entries.map((entry) {
                            final formattedDate = DateFormat('yyyy.MM.dd')
                                .format(entry.key); // Format the date
                            return DataRow(
                              cells: [
                                DataCell(Text(formattedDate)),
                                DataCell(Text(entry.value.toString())),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                      Center(
                        child: DataTable(
                          dataRowHeight: 20,
                          decoration: BoxDecoration(),
                          columns: const [
                            DataColumn(label: Text('Wh')),
                          ],
                          rows: consumption.entries.map((entry) {
                            // Format the date
                            return DataRow(
                              cells: [
                                DataCell(Text(entry.value.toString())),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  )),
            ]),
          ))
    ]);
  }
}

class _ChartData {
  _ChartData(this.date, this.consumption);

  final DateTime date;
  final double consumption;
}
