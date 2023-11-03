import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:testuus4/lehed/Seadme_Lehed/SeadmeGraafikLeht.dart';
import 'package:testuus4/Arhiiv/SeadmeTarbimisLeht.dart';
import 'package:testuus4/lehed/TarbimisLeht.dart';
import 'package:testuus4/lehed/Seadme_Lehed/dynamicSeadmeInfo.dart';
import 'package:testuus4/lehed/P%C3%B5hi_Lehed/koduleht.dart';
import 'package:testuus4/main.dart';

import '../funktsioonid/maksumusSeadmeKohta.dart';

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
  double asi = 0;

  List<ChartData> chartData2 = [];
  num kokku = 0;
  double asi2 = 0;

  function() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> maksumuseMap = {};
    //Võtab mälust 'users'-i asukohast väärtused

    double calculateSum(Map<DateTime, double> data) {
      double sum = 0.0;
      data.values.forEach((value) {
        sum += value;
        print("sum: $sum");
      });
      kokku = kokku + sum;
      print("kokku: $kokku");
      return sum;
    }

    int j = 0;

    for (var key in seadmeteMap.keys) {
      print("--------------");
      print(seadmeteMap[key]["Seadme_nimi"]);
      print("--------------");
      Map<DateTime, double> dataMap = await seadmeMaksumus(key);
      print("--------------");
      print("${seadmeteMap[key]["Seadme_nimi"]} datamap: $dataMap");
      print("--------------");
      double temp = calculateSum(dataMap);
      String abi = temp.toStringAsFixed(4);
      temp = double.parse(abi);
      maksumuseMap["${seadmeteMap[key]['Seadme_nimi']}"] = temp;
      chartData.clear();
      for (var entry in maksumuseMap.entries) {
        chartData.add(ChartData(entry.key, entry.value));
      }

      print("siin: $chartData");
      setState(() {
        chartData = chartData;
        kokku = kokku;
      });
    }

    double? findMaxY(List<ChartData> data) {
      double? maxY;
      for (var chartData in data) {
        if (chartData.y != null) {
          if (maxY == null || chartData.y! > maxY) {
            maxY = chartData.y;
          }
        }
      }
      return maxY;
    }

// Now, you can call this method to get the maximum value.
    double? maxChartDataValue = findMaxY(chartData);

    setState(() {
      if (maxChartDataValue == null) {
        asi = 0;
      } else {
        asi = maxChartDataValue;
      }
    });
  }

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

    double? findMaxY(List<ChartData> data) {
      double? maxY;
      for (var chartData in data) {
        if (chartData.y != null) {
          if (maxY == null || chartData.y! > maxY) {
            maxY = chartData.y;
          }
        }
      }
      return maxY;
    }

// Now, you can call this method to get the maximum value.
    double? maxChartDataValue = findMaxY(chartData);

    setState(() {
      if (maxChartDataValue == null) {
        asi = 0;
      } else {
        asi = maxChartDataValue;
      }
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
                yValueMapper: (ChartData data, _) {
                  final yValue = data.y;
                  return yValue == 0
                      ? 0
                      : yValue! < asi * 0.20
                          ? asi * 0.20
                          : yValue;
                },
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  labelAlignment: ChartDataLabelAlignment.bottom,
                  textStyle: fontValgeVaike,
                  angle: 270,
                ),
                color: Colors.blue,
                dataLabelMapper: (ChartData data, _) {
                  // Display the data label only if the consumption is not 0
                  if (data.y == 0) {
                    return ''; // Customize this as needed
                  } else {
                    String temp3 = data.y!.toStringAsFixed(3);
                    return ' $temp3';
                  }
                },
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
