import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';





class TarbimiseGraafik extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('Seade 1', 35),
      ChartData('Seade 2', 13),
      ChartData('Seade 3', 34),
      ChartData('Seade 4', 35),
      ChartData('Seade 5', 13),
      ChartData('Seade 6', 34),
      
      
    ];
    return RotatedBox(
      quarterTurns: 1,
      child: Container(
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(labelRotation: 270,),
          primaryYAxis: NumericAxis(labelRotation: 270,),
          series: <ChartSeries>[
            // Renders spline chart
            ColumnSeries<ChartData, String>(
              width: 0.9,
                        spacing: 0.5,
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
            ),
          ],
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
