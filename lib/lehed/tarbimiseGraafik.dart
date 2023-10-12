import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:testuus4/lehed/SeadmeGraafikLeht.dart';
import 'package:testuus4/Arhiiv/SeadmeTarbimisLeht.dart';
import 'package:testuus4/lehed/TarbimisLeht.dart';
import 'package:testuus4/lehed/dynamicSeadmeInfo.dart';
import 'package:testuus4/lehed/koduleht.dart';
import 'package:testuus4/main.dart';

class TarbimiseGraafik extends StatefulWidget {
  final Map<String, dynamic> tarbimiseMap;

  TarbimiseGraafik(this.tarbimiseMap, {Key? key}) : super(key: key);

  @override
  State<TarbimiseGraafik> createState() => _TarbimiseGraafikState(tarbimiseMap);
}

class _TarbimiseGraafikState extends State<TarbimiseGraafik> {
  Map<String, dynamic> SeadmeteMap = {};
  final Map<String, dynamic> tarbimiseMap;

  _TarbimiseGraafikState(this.tarbimiseMap);
  List<ChartData> chartData = [];

  getChartData() {
    print("tarbimiseMap: $tarbimiseMap");
    // Convert the tarbimiseMap data to a list of ChartData objects

    List<ChartData> chartData1 = [];
    tarbimiseMap.forEach((key, value) {
      chartData1.add(ChartData(key, value));
    });
    setState(() {
      chartData = chartData1;
    });
    //return chartData;
  }

  getSeadmeteMap(Map<String, dynamic> seadmeteMap) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //await prefs.clear();

    String? storedJsonMap = prefs.getString('seadmed');
    if (storedJsonMap != null) {
      storedJsonMap = prefs.getString('seadmed');
      Map<String, dynamic> storedMap = json.decode(storedJsonMap!);

      setState(() {
        SeadmeteMap = storedMap;
      });
    }
  }

  @override
  void initState() {
    getChartData();
    getSeadmeteMap(SeadmeteMap);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Get the chart data

    return Container(
      height: MediaQuery.of(context).size.height * chartData.length * 0.06,
      //width: double.infinity,
      child: RotatedBox(
        quarterTurns: 1,
        child: Container(
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(
                labelRotation: 270, interval: 1, labelStyle: fontVaike),
            primaryYAxis: NumericAxis(labelRotation: 270, isVisible: false),
            series: <ChartSeries>[
              // Renders spline chart
              ColumnSeries<ChartData, String>(
                onPointTap: (pointInteractionDetails) {
                  int? rowIndex = pointInteractionDetails.pointIndex;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DunaamilineSeadmeLeht(
                        seadmeNimi: SeadmeteMap.keys.elementAt(rowIndex!),
                        SeadmeteMap: SeadmeteMap,
                        valitud: 1,
                      ),
                    ),
                  );
                },
                width: 1,
                spacing: 0.3,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  labelAlignment: ChartDataLabelAlignment.bottom,
                  textStyle: fontValgeVaike,
                  angle: 270,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
}
