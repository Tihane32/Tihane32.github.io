import 'package:flutter/material.dart';
import 'package:testuus4/funktsioonid/maksumusSeadmeKohta.dart';
import 'package:testuus4/lehed/Seadme_Lehed/SeadmeGraafikLeht.dart';
import 'package:testuus4/Arhiiv/SeadmeTarbimisLeht.dart';
import 'Seadme_Lehed/SeadmeYldInfo.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:testuus4/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'paevaGraafik.dart';

class TarbimisLeht extends StatefulWidget {
  const TarbimisLeht(
      {Key? key, required this.seadmeNimi, required this.SeadmeteMap})
      : super(key: key);

  final String seadmeNimi;
  final Map<String, dynamic> SeadmeteMap;
  @override
  _TarbimisLehtState createState() =>
      _TarbimisLehtState(seadmeNimi: seadmeNimi, SeadmeteMap: SeadmeteMap);
}

int koduindex = 2;

class _TarbimisLehtState extends State<TarbimisLeht> {
  _TarbimisLehtState(
      {Key? key, required this.seadmeNimi, required this.SeadmeteMap});
  Map<String, dynamic> SeadmeteMap;
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
    //seadmeMaksumus2(seadmeNimi);
    super.initState();
  }

  int i = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255), //TaustavÃ¤rv
        body: MGraafik(value: seadmeNimi));
  }
}

class MGraafik extends StatefulWidget {
  final String value;

  MGraafik({required this.value});
  @override
  _MGraafikState createState() => _MGraafikState();
}

class _MGraafikState extends State<MGraafik> {
  Map<int, List<double>> paevaMaksumus = {};
  List<_ChartData> chartData = [];
  Map<DateTime, double> temp = {};
  Map<dynamic, dynamic> consumption = {};
  bool graafik = false;
  double asi = 0;
  double asi2 = 0.02;
  String total = '0';
  String total2 = '0';
  String total2Uhik = '';
  double keskmine = 0;

  setPaevamaksumus(paevaList) {
    setState(() {
      paevaMaksumus = paevaList;
      print("käes $paevaList");
    });
  }

  fetchData(value) async {
    DateTime currentDateTime = DateTime.now();

    // Calculate the first day of the current month
    DateTime firstDayOfMonth =
        DateTime(currentDateTime.year, currentDateTime.month);

    // Calculate the last day of the current month
    DateTime lastDayOfMonth =
        DateTime(currentDateTime.year, currentDateTime.month + 1, 1);
    // Create the map with dates and initial values of 0
    //Map<DateTime, double> temp = {};
    setState(() {
      for (DateTime date = firstDayOfMonth;
          date.isBefore(lastDayOfMonth);
          date = date.add(const Duration(days: 1))) {
        temp[date] = 0.0;
      }
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonData = prefs.getString('consumption') ?? '[]';
    List<dynamic> decodedList = jsonDecode(jsonData);
    for (var j = 0; j < decodedList.length; j++) {
      dynamic i = 0;
      String k = '';
      i = decodedList[j]['consumption'];
      k = i.toStringAsFixed(2);
      consumption[j] = k;
    }
    double abi = 0;
    temp = await seadmeMaksumus2(value, setPaevamaksumus);
    for (DateTime date = firstDayOfMonth;
        date.isBefore(lastDayOfMonth);
        date = date.add(const Duration(days: 1))) {
      if (!temp.containsKey(date)) {
        temp[date] = 0.0;
      }
    }

    setState(() {
      temp = temp.map((key, value) =>
          MapEntry(key, double.parse(value.toStringAsFixed(3))));
      for (var value in temp.values) {
        abi = abi + value;
      }
      total = abi.toStringAsFixed(3);
      keskmine = double.parse(total) / double.parse(total2);
    });

    double findMaxValue(Map<DateTime, double> temp) {
      double max = double
          .negativeInfinity; // Initialize with negative infinity as the starting maximum value

      // Iterate through the values in the map
      for (var value in temp.values) {
        if (value > max) {
          max = value; // Update max if a larger value is found
        }
      }

      return max;
    }

    double maxTempValue = findMaxValue(temp);

    setState(() {
      asi2 = maxTempValue;
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
      total2 = '0';
      for (DateTime date = firstDayOfMonth;
          date.isBefore(lastDayOfMonth);
          date = date.add(const Duration(days: 1))) {
        chartData.add(_ChartData(date, 0.0));
      }
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var headers = {
      'Authorization': 'Bearer ${tokenMap[value]}',
    };
    var data = {
      'id': value,
      'channel': '0',
      'date_range': 'custom',
      'date_from': '$firstDayOfMonth',
      'date_to': '$lastDayOfMonth',
    };

    var url = Uri.parse(
        '${seadmeteMap[value]["api_url"]}/statistics/relay/consumption');
    var res = await http.post(url, headers: headers, body: data);
    if (res.statusCode != 200) {
      throw Exception('http.post error: statusCode= ${res.statusCode}');
    }
    final jsonData = json.decode(res.body);
    final historyData = jsonData['data']['history'] as List<dynamic>;
    setState(() {
      chartData = historyData
          .map((history) => _ChartData(DateTime.parse(history['datetime']),
              history['consumption'].toDouble()))
          .toList();
      total2 = jsonData['data']['total'].toString();
      total2Uhik = jsonData['data']['units']['consumption'].toString();
    });

    double findMaxValue(List<_ChartData> chartData) {
      if (chartData.isEmpty) {
        return 0.0; // Return 0 or any default value if the list is empty.
      }
      return chartData.map((data) => data.consumption).reduce(max);
    }

// Now, you can call this method to get the maximum value.
    double maxChartDataValue = findMaxValue(chartData);

    setState(() {
      asi = maxChartDataValue;
    });

    String dataString = jsonEncode(jsonData['data']['history']);
    prefs.setString('consumption', dataString);
    prefs.setString('total', total2);
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
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          pinned: true,
          title: IntrinsicHeight(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Kokku: $total € ja $total2 $total2Uhik',
                            style: font,
                          ),
                        )),
                    Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Keskmiselt: ${keskmine.toStringAsFixed(2)} €/$total2Uhik',
                            style: font,
                          ),
                        )),
                  ],
                ),
                Positioned(
                  right: 0,
                  top: -5,
                  child: Row(
                    children: [
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
                                  child: const Icon(
                                    Icons.bar_chart,
                                    size: 30,
                                    color: Colors.black,
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
                                  child: const Icon(
                                    Icons.table_rows_outlined,
                                    size: 30,
                                    color: Colors.black,
                                  ),
                                ))),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  Column(children: [
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
                              //edgeLabelPlacement: EdgeLabelPlacement.hide,
                              //visibleMinimum: DateTime(2023, 8,31),
                              interval: 1,
                              labelRotation: 270,
                              labelStyle: fontVaike,
                              dateFormat: DateFormat('dd.MM'),
                              //minimum: temp.entries.first.key,
                            ),
                            tooltipBehavior: _tooltipBehavior,
                            series: <ChartSeries>[
                              StackedColumnSeries<MapEntry<DateTime, double>,
                                  DateTime>(
                                onPointTap: (pointInteractionDetails) {
                                  List<DateTime> dateTimes = temp.keys.toList();
                                  int rowIndex =
                                      pointInteractionDetails.pointIndex as int;
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return FractionallySizedBox(
                                        heightFactor: 0.8,
                                        widthFactor: 0.8,
                                        child: Material(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          //height: MediaQuery.of(context).size.height*0.5,
                                          //width: MediaQuery.of(context).size.width,

                                          child: PaevaTarbimine(
                                              date: dateTimes[rowIndex]
                                                  .toString(),
                                              value: widget.value,
                                              rowIndex: rowIndex,
                                              paevaMaksumus: paevaMaksumus),
                                        ),
                                      );
                                    },
                                  );
                                },
                                color: Colors.green,
                                width: 0.9,
                                groupName: 'A',
                                //splineType: SplineType.monotonic,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                                dataSource: temp.entries.toList(),
                                yAxisName: 'firstAxis',
                                xValueMapper: (entry, _) => entry.key,
                                yValueMapper: (entry, _) {
                                  final yValue = entry.value;
                                  return yValue == 0
                                      ? 0
                                      : yValue < asi2 * 0.25
                                          ? asi2 * 0.25
                                          : yValue;
                                },
                                enableTooltip: false,
                                dataLabelSettings: DataLabelSettings(
                                  offset: const Offset(0, -10),
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
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                                dataSource: chartData,
                                yAxisName: 'secondAxis',
                                xValueMapper: (_ChartData data, _) => data.date,
                                yValueMapper: (_ChartData data, _) {
                                  final yValue = data.consumption;
                                  return yValue == 0
                                      ? 0
                                      : yValue < asi * 0.25
                                          ? asi * 0.25
                                          : yValue;
                                },
                                enableTooltip: false,
                                dataLabelSettings: DataLabelSettings(
                                  offset: const Offset(0, -20),
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
                      child: Container(
                        height: MediaQuery.of(context).size.height * 2,
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: SfCartesianChart(
                            axes: [
                              NumericAxis(
                                name: 'firstAxis',
                                minorGridLines: MinorGridLines(width: 0.0),
                                majorGridLines: MajorGridLines(width: 0.0),
                                isVisible: false,
                                title: AxisTitle(
                                  text: 'Eurot',
                                  textStyle: fontVaike,
                                ),
                                labelStyle: fontVaike,
                                labelAlignment: LabelAlignment.start,
                                labelRotation: 0,
                              ),
                              NumericAxis(
                                majorGridLines: MajorGridLines(width: 0.0),
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
                              //edgeLabelPlacement: EdgeLabelPlacement.hide,
                              //visibleMinimum: DateTime(2023, 8,31),
                              interval: 1,
                              labelRotation: 270,
                              labelStyle: fontVaike,
                              dateFormat: DateFormat('dd.MM'),
                              //minimum: temp.entries.first.key,
                            ),
                            tooltipBehavior: _tooltipBehavior,
                            series: <ChartSeries>[
                              LineSeries<MapEntry<DateTime, double>, DateTime>(
                                markerSettings:
                                    const MarkerSettings(isVisible: true),
                                onPointTap: (pointInteractionDetails) {
                                  List<DateTime> dateTimes = temp.keys.toList();
                                  int rowIndex =
                                      pointInteractionDetails.pointIndex as int;
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return FractionallySizedBox(
                                        heightFactor: 0.8,
                                        widthFactor: 0.8,
                                        child: Material(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          //height: MediaQuery.of(context).size.height*0.5,
                                          //width: MediaQuery.of(context).size.width,

                                          child: PaevaTarbimine(
                                              date: dateTimes[rowIndex]
                                                  .toString(),
                                              value: widget.value,
                                              rowIndex: rowIndex,
                                              paevaMaksumus: paevaMaksumus),
                                        ),
                                      );
                                    },
                                  );
                                },
                                color: Colors.green,
                                width: 5,

                                //splineType: SplineType.monotonic,

                                dataSource: temp.entries.toList(),
                                yAxisName: 'firstAxis',
                                xValueMapper: (entry, _) => entry.key,
                                yValueMapper: (entry, _) {
                                  final yValue = entry.value;
                                  return yValue == 0
                                      ? 0
                                      : yValue < asi2 * 0.25
                                          ? asi2 * 0.25
                                          : yValue;
                                },
                                enableTooltip: false,
                                dataLabelSettings: DataLabelSettings(
                                  showZeroValue: false,
                                  offset: const Offset(15, 0),
                                  opacity: 0.8,
                                  isVisible: true,
                                  labelAlignment:
                                      ChartDataLabelAlignment.middle,
                                  labelIntersectAction:
                                      LabelIntersectAction.none,
                                  useSeriesColor: true,
                                  textStyle: fontEritiVaike,
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
                              LineSeries<_ChartData, DateTime>(
                                markerSettings:
                                    const MarkerSettings(isVisible: true),
                                color: Colors.blue,
                                width: 5,
                                dataSource: chartData,
                                yAxisName: 'secondAxis',
                                xValueMapper: (_ChartData data, _) => data.date,
                                yValueMapper: (_ChartData data, _) {
                                  final yValue = data.consumption;
                                  return yValue == 0
                                      ? 0
                                      : yValue < asi * 0.25
                                          ? asi * 0.25
                                          : yValue;
                                },
                                enableTooltip: false,
                                dataLabelSettings: DataLabelSettings(
                                  opacity: 0.8,
                                  showZeroValue: false,
                                  offset: const Offset(-15, 0),
                                  isVisible: true,
                                  labelAlignment:
                                      ChartDataLabelAlignment.middle,
                                  labelIntersectAction:
                                      LabelIntersectAction.none,
                                  useSeriesColor: true,
                                  textStyle: fontEritiVaike,
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
                    )
                  ])
                ],
              );
            },
            childCount: 1,
          ),
        ),
      ],
    );
  }
}

class _ChartData {
  _ChartData(this.date, this.consumption);

  final DateTime date;
  final double consumption;
}
