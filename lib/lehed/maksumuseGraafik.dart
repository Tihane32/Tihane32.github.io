import 'dart:convert';
import 'dart:math';
import 'package:testuus4/lehed/TarbimisLeht.dart';
import 'package:testuus4/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:testuus4/funktsioonid/maksumusSeadmeKohta.dart';
import 'package:testuus4/main.dart';
import 'package:testuus4/parameters.dart';
import 'Seadme_Lehed/dynamicSeadmeInfo.dart';
import 'Põhi_Lehed/koduleht.dart';
/*
class MaksumuseGraafik extends StatefulWidget {
  @override
  State<MaksumuseGraafik> createState() => _MaksumuseGraafikState();
}

class _MaksumuseGraafikState extends State<MaksumuseGraafik> {
  List<ChartData> chartData = [];
  num kokku = 0;
  double asi = 0;
  @override
  void initState() {
    function();

    super.initState();
  }

  function() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> maksumuseMap = {};
    //Võtab mälust 'users'-i asukohast väärtused

    double calculateSum(Map<DateTime, double> data) {
      double sum = 0.0;
      data.values.forEach((value) {
        sum += value;
      });
      kokku = kokku + sum;
      return sum;
    }

    int j = 0;

    for (var key in seadmeteMap.keys) {
      Map<DateTime, double> dataMap = await seadmeMaksumus(key);
      double temp = calculateSum(dataMap);
      String abi = temp.toStringAsFixed(4);
      temp = double.parse(abi);
      maksumuseMap["${seadmeteMap[key]['Seadme_nimi']}"] = temp;
      chartData.clear();
      for (var entry in maksumuseMap.entries) {
        chartData.add(ChartData(entry.key, entry.value));
      }

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                      style: font,
                      children: [
                        TextSpan(
                            text: 'Kokku: ${kokku.toStringAsFixed(4)} €',
                            style: font),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: vahe / 2),
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
                      style: font,
                      children: [
                        TextSpan(text: '€', style: fontVaike),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
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
                            seadmeNimi: seadmeteMap.keys.elementAt(rowIndex!),
                            SeadmeteMap: seadmeteMap,
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
                    color: Colors.green,
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      labelAlignment: ChartDataLabelAlignment.bottom,
                      textStyle: fontValgeVaike,
                      angle: 270,
                    ),
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
        ),
      ],
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
}
*/