import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:testuus4/lehed/koduleht.dart';
import 'package:testuus4/main.dart';

class TarbimiseGraafik extends StatefulWidget {
  final Map<String, dynamic> tarbimiseMap;

  TarbimiseGraafik(this.tarbimiseMap, {Key? key}) : super(key: key);

  @override
  State<TarbimiseGraafik> createState() => _TarbimiseGraafikState(tarbimiseMap);
}

class _TarbimiseGraafikState extends State<TarbimiseGraafik> {
final Map<String, dynamic> tarbimiseMap;
 
  _TarbimiseGraafikState(this.tarbimiseMap);

List<ChartData> getChartData() {
    // Convert the tarbimiseMap data to a list of ChartData objects
    List<ChartData> chartData = [];
    tarbimiseMap.forEach((key, value) {
      chartData.add(ChartData(key, value));
    });
    return chartData;
  }
  @override
  Widget build(BuildContext context) {
    List<ChartData> chartData = getChartData(); // Get the chart data
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
