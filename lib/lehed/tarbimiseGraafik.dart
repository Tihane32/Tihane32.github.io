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
  final String ajatarbimine;
  TarbimiseGraafik(this.tarbimiseMap, this.ajatarbimine, {Key? key})
      : super(key: key);

  @override
  State<TarbimiseGraafik> createState() =>
      _TarbimiseGraafikState(tarbimiseMap, ajatarbimine);
}

class _TarbimiseGraafikState extends State<TarbimiseGraafik> {
  final Map<String, dynamic> tarbimiseMap;

  final ajatarbimine;

  _TarbimiseGraafikState(this.tarbimiseMap, this.ajatarbimine);
  List<ChartData> chartData = [];
  double asi = 0;

  List<ChartData> chartData2 = [];
  num kokku = 0;
  double asi2 = 0;

  function() async {
    Map<String, dynamic> maksumuseMap = {};
    //Võtab mälust 'users'-i asukohast väärtused

    double calculateSum(Map<DateTime, double> data) {
      double sum = 0.0;
      for (var value in data.values) {
        sum += value;
      }
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
      chartData2.clear();
      for (var entry in maksumuseMap.entries) {
        chartData2.add(ChartData(entry.key, entry.value));
      }

      setState(() {
        chartData2 = chartData2;
        kokku = kokku;
      });
    }

    double? findMaxY(List<ChartData> data) {
      double? maxY;
      for (var chartData2 in data) {
        if (chartData2.y != null) {
          if (maxY == null || chartData2.y! > maxY) {
            maxY = chartData2.y;
          }
        }
      }
      return maxY;
    }

// Now, you can call this method to get the maximum value.
    double? maxChartDataValue2 = findMaxY(chartData2);

    setState(() {
      if (maxChartDataValue2 == null) {
        asi = 0;
      } else {
        asi = maxChartDataValue2;
      }
    });
  }

  getChartData() {
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

  @override
  void initState() {
    function();
    getChartData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Get the chart data

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      //width: double.infinity,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            "Kokku: ${kokku.toStringAsFixed(4)} € ja $ajatarbimine kWh \n  Keskmiselt: ${(kokku / num.parse(ajatarbimine)).toStringAsFixed(4)} €/kWh",
            textAlign: TextAlign.center,
            style: font,
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              RotatedBox(
                quarterTurns: 1,
                child: Container(
                  color: Colors.white,
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                        labelRotation: 270, interval: 1, labelStyle: fontVaike),
                    axes: [
                      NumericAxis(
                        name: 'firstAxis',
                        minorGridLines: const MinorGridLines(width: 0.0),
                        majorGridLines: const MajorGridLines(width: 0.0),
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
                        majorGridLines: const MajorGridLines(width: 0.0),
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
                    series: <ChartSeries>[
                      // Renders spline chart
                      ColumnSeries<ChartData, String>(
                        yAxisName: "firstAxis",
                        onPointTap: (pointInteractionDetails) {
                          int? rowIndex = pointInteractionDetails.pointIndex;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DunaamilineSeadmeLeht(
                                seadmeNimi:
                                    seadmeteMap.keys.elementAt(rowIndex!),
                                SeadmeteMap: seadmeteMap,
                                valitud: 1,
                              ),
                            ),
                          );
                        },
                        width: 1,
                        spacing: 0.3,
                        borderRadius: const BorderRadius.only(
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
                          textStyle: fontVaike,
                          angle: 270,
                        ),
                        color: Colors.blue,
                        dataLabelMapper: (ChartData data, _) {
                          // Display the data label only if the consumption is not 0
                          if (data.y == 0) {
                            return ''; // Customize this as needed
                          } else {
                            String temp3 = data.y!.toStringAsFixed(3);
                            return ' $temp3 kWh';
                          }
                        },
                      ),
                      ColumnSeries<ChartData, String>(
                        yAxisName: "secondAxis",
                        onPointTap: (pointInteractionDetails) {
                          int? rowIndex = pointInteractionDetails.pointIndex;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DunaamilineSeadmeLeht(
                                seadmeNimi:
                                    seadmeteMap.keys.elementAt(rowIndex!),
                                SeadmeteMap: seadmeteMap,
                                valitud: 1,
                              ),
                            ),
                          );
                        },
                        width: 1,
                        spacing: 0.3,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        dataSource: chartData2,
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
                          textStyle: fontVaike,
                          angle: 270,
                        ),
                        dataLabelMapper: (ChartData data, _) {
                          // Display the data label only if the consumption is not 0
                          if (data.y == 0) {
                            return ''; // Customize this as needed
                          } else {
                            String temp3 = data.y!.toStringAsFixed(3);
                            return ' $temp3 €';
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50,),
              RotatedBox(
                quarterTurns: 0,
                child: Container(
                    height: 250,
                    color: Colors.white,
                    child: SfCartesianChart(
                      legend: Legend(textStyle: fontVaikeLight,
                          isVisible: true, position: LegendPosition.bottom, overflowMode: LegendItemOverflowMode.wrap),
                      series: <ChartSeries>[
                        StackedColumnSeries<ExpenseData, String>(
                          dataSource: [
                            ExpenseData('Mon', 500, 300, 200),
                            ExpenseData('Tue', 600, 400, 300),
                            ExpenseData('Wed', 700, 500, 400),
                            ExpenseData('Thu', 800, 600, 500),
                            ExpenseData('Fri', 200, 300, 100),
                            ExpenseData('Sat', 200, 300, 100),
                            ExpenseData('Sun', 200, 300, 100),
                          ],
                          
                          xValueMapper: (ExpenseData expense, _) =>
                              expense.month,
                          yValueMapper: (ExpenseData expense, _) =>
                              expense.food,
                          name: 'Elektriauto \n 500 €',
                          color: Colors.green,
                        ),
                        StackedColumnSeries<ExpenseData, String>(
                            dataSource: [
                              ExpenseData('Mon', 200, 400, 100),
                              ExpenseData('Tue', 300, 500, 200),
                              ExpenseData('Wed', 400, 600, 300),
                              ExpenseData('Thu', 500, 700, 400),
                              ExpenseData('Fri', 200, 300, 100),
                              ExpenseData('Sat', 200, 100, 100),
                            ExpenseData('Sun', 200, 300, 100),
                            ],
                            xValueMapper: (ExpenseData expense, _) =>
                                expense.month,
                            yValueMapper: (ExpenseData expense, _) =>
                                expense.clothing,
                            name: 'Külmkapp \n 200 €',
                            color: Colors.blue),
                        StackedColumnSeries<ExpenseData, String>(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(10)),
                            dataSource: [
                              ExpenseData('Mon', 100, 200, 50),
                              ExpenseData('Tue', 150, 250, 100),
                              ExpenseData('Wed', 200, 300, 150),
                              ExpenseData('Thu', 250, 350, 200),
                              ExpenseData('Fri', 200, 300, 100),
                              ExpenseData('Sat', 200, 300, 100),
                            ExpenseData('Sun', 200, 300, 300),
                            ],
                            xValueMapper: (ExpenseData expense, _) =>
                                expense.month,
                            yValueMapper: (ExpenseData expense, _) =>
                                expense.utilities,
                            name: 'LED lamp \n 100 €',
                            color: Colors.orange),
                      ],
                      primaryXAxis: CategoryAxis(),
                      primaryYAxis: NumericAxis(
                        title: AxisTitle(text: 'Kulu (€)'),
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

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
}

class ExpenseData {
  final String month;
  final double food;
  final double clothing;
  final double utilities;

  ExpenseData(this.month, this.food, this.clothing, this.utilities);
}
