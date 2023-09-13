import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:testuus4/funktsioonid/maksumusSeadmeKohta.dart';
import 'package:testuus4/main.dart';

class MaksumuseGraafik extends StatefulWidget {
  @override
  State<MaksumuseGraafik> createState() => _MaksumuseGraafikState();
}

class _MaksumuseGraafikState extends State<MaksumuseGraafik> {
  List<ChartData> chartData = [];
  @override
  void initState() {
    super.initState();
    function();
  }

  function() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> maksumuseMap = {};
    //Võtab mälust 'users'-i asukohast väärtused
    var seadmedJSONmap = prefs.getString('seadmed');

    if (seadmedJSONmap == null) {
      return 0;
    }
    Map<String, dynamic> storedMap = json.decode(seadmedJSONmap);
    int j = 0;
    for (var i in storedMap.values) {
      String asendus = storedMap['Seade$j']['Seadme_ID'] as String;
      String asendus1 = storedMap['Seade$j']['Seadme_nimi'] as String;
      j++;

      print("seadmemaksusmu ${await seadmeMaksumus(asendus)}");
      double calculateSum(Map<DateTime, double> data) {
        double sum = 0.0;
        data.values.forEach((value) {
          sum += value;
        });
        return sum;
      }

// Call seadmeMaksumus to get the map
      Map<DateTime, double> dataMap = await seadmeMaksumus(asendus);

// Calculate the sum of the double values in the map
      double temp = calculateSum(dataMap);

      maksumuseMap["$asendus1"] = temp;
    }
    chartData.clear();

    for (var entry in maksumuseMap.entries) {
      chartData.add(ChartData(entry.key, entry.value));
    }
    print("lõpp");
    print(chartData);
    print(maksumuseMap);
    setState(() {
      chartData = chartData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * chartData.length * 0.04,
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
                //width: 0.9,
                //spacing: 0.5,
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
