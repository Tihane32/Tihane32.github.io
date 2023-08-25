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
                  Center(
                    child: MGraafik(value: SeadmeteMap[seadmeNimi]![1]),
                  ),
                  Visibility(
                    visible: graafikuNahtavus,
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
  Map<DateTime, double> temp = {};
  Map<dynamic, dynamic> consumption = {};
  bool graafik = false;

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

  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, header: 'Maksumus:');

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
                  child: SfCartesianChart(
                    primaryXAxis: DateTimeAxis(
                      labelStyle: fontVaike,
                      dateFormat: DateFormat('dd.MM'),
                      minimum: temp.entries.first.key,
                    ),
                    primaryYAxis: NumericAxis(
                      title: AxisTitle(
                        text: 'Eurot',
                        textStyle: fontVaike,
                      ),
                      labelStyle: fontVaike,
                      /*labelFormat: 'Wh',
                              labelRotation: 90,*/
                    ),
                    tooltipBehavior: _tooltipBehavior,
                    series: <ChartSeries>[
                      ColumnSeries<MapEntry<DateTime, double>, DateTime>(
                        //splineType: SplineType.monotonic,
                        dataSource: temp.entries.toList(),
                        xValueMapper: (entry, _) => entry.key,
                        yValueMapper: (entry, _) => entry.value,
                        enableTooltip: true,
                        dataLabelSettings: DataLabelSettings(
                          offset: Offset(0, 5),
                          isVisible: true,
                          labelAlignment: ChartDataLabelAlignment.outer,
                          textStyle: fontVaike,
                          angle: 270,
                        ),
                        dataLabelMapper: (entry, _) {
                          // Display the data label only if the consumption is not 0
                          if (entry.value == 0) {
                            return ''; // Customize this as needed
                          }
                        },
                      ),
                    ],
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
