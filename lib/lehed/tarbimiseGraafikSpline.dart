import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:testuus4/main.dart';

import '../parameters.dart';

class TarbimiseGraafikSpline extends StatelessWidget {
/*DateTime now = DateTime.now();
    late DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    late DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

   late List<ChartData> chartData = [
      ChartData(startOfWeek, 10),
      ChartData(startOfWeek.add(Duration(days: 1)), 20),
      ChartData(startOfWeek.add(Duration(days: 2)), 10),
      ChartData(startOfWeek.add(Duration(days: 3)), 30),
      ChartData(startOfWeek.add(Duration(days: 4)), 10),
      ChartData(startOfWeek.add(Duration(days: 5)), 40),
      ChartData(endOfWeek, 50),
    ];*/

  
  @override
  Widget build(BuildContext context) {

    final List<ChartData> chartData = [
      
            ChartData(DateTime(2016, 8,14), 10),
            ChartData(DateTime(2016, 8,15), 12),
            ChartData(DateTime(2016, 8,16), 14),
            ChartData(DateTime(2016, 8,17), 15),
            ChartData(DateTime(2016, 8,18), 11),
            ChartData(DateTime(2016, 8,19), 10),
            ChartData(DateTime(2016, 8,20), 14),
           
    ];
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      //width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(right:12.0),
        child: Container(
          child: SfCartesianChart(
            primaryXAxis: DateTimeAxis(
              majorGridLines: MajorGridLines(width: 1),
              //minorGridLines: MinorGridLines(width: 10),
                dateFormat: DateFormat('dd.MM'),
                //interval: 1,
                labelStyle: fontVaike),
            primaryYAxis: NumericAxis(
              majorGridLines: MajorGridLines(width: 1),

                minimum: chartData.map((data) => data.y!).reduce((min, value) => min > value ? value : min) * 0.5,
                isVisible: true,
                labelStyle: fontVaike,
                
                //anchorRangeToVisiblePoints: true,
                title: AxisTitle(
                              text: 'kWh',
                              textStyle: fontVaike,
                              alignment: ChartAlignment.center),
                              
                              ),
            series: <ChartSeries>[
              // Renders spline chart
              SplineSeries<ChartData, DateTime>(
                //width: 0.9,
                //spacing: 0.5,
      splineType: SplineType.cardinal,
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  labelAlignment: ChartDataLabelAlignment.bottom,
                  textStyle: fontVaike,
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
  final DateTime x;
  final double? y;
}
