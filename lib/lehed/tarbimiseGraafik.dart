import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:testuus4/main.dart';




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
    return Container(
      height: MediaQuery.of(context).size.height*chartData.length*0.04,
      //width: double.infinity,
      child: Expanded(
        child: RotatedBox(
          quarterTurns: 1,
          child: Container(
            
            child: SfCartesianChart(
      
              primaryXAxis: CategoryAxis(labelRotation: 270,interval: 1, labelStyle: fontVaike),
              primaryYAxis: NumericAxis(labelRotation: 270,isVisible: false),
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
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
}
