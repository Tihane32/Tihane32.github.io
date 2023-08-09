import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';





class TarbimiseGraafik extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData(2010, 35),
      ChartData(2011, 13),
      ChartData(2012, 34),
      ChartData(2013, 27),
      ChartData(2014, 40),
      ChartData(2015, 40),
      ChartData(2016, 40),
      ChartData(2017, 40),
    ];
    return Scaffold(
      
      body: SingleChildScrollView(
        child: Center(
          child: RotatedBox(
            quarterTurns: 1,
            child: Container(
              child: SfCartesianChart(
                primaryXAxis: NumericAxis(labelRotation: 270,),
                primaryYAxis: NumericAxis(labelRotation: 270,),
                series: <ChartSeries>[
                  // Renders spline chart
                  ColumnSeries<ChartData, int>(
                    width: 0.9,
                              spacing: 0.5,
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final double? y;
}
