import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:testuus4/main.dart';

double findMaximumYValue(List<ChartDataPoint> dataPoints) {
  double max = double.negativeInfinity;
  for (int i = 0; i < dataPoints.length; i++) {
    if (dataPoints[i].y > max) {
      max = dataPoints[i].y;
    }
  }
  return max;
}

class PaevaTarbimine extends StatelessWidget {
  final String date;
  final String value;
  final int rowIndex;
  final Map<int, List<double>> paevaMaksumus;

  PaevaTarbimine({
    required this.date,
    required this.value,
    required this.rowIndex,
    required this.paevaMaksumus,
  });

  @override
  Widget build(BuildContext context) {
    final List<double> temp = paevaMaksumus[rowIndex]!;
    final List<int> xValues = List.generate(temp.length, (index) => index);

    final List<ChartDataPoint> dataPoints = [];
    for (int i = 0; i < temp.length; i++) {
      dataPoints.add(ChartDataPoint(x: xValues[i], y: temp[i]));
    }
    double maxYValue = findMaximumYValue(dataPoints);
    return Container(
      height: MediaQuery.of(context).size.height * 1.5,
      child: RotatedBox(
        quarterTurns: 1,
        child: SfCartesianChart(
          axes: [
            NumericAxis(
              name: 'firstAxis',
              isVisible: false,
              title: AxisTitle(
                text: 'Eurot',
                textStyle: fontVaike,
              ),
              labelStyle: fontVaike,
              /*labelFormat: 'Wh',
                    labelRotation: 90,*/
            ),
            NumericAxis(
              name: 'secondAxis',
              isVisible: false,
              title: AxisTitle(
                text: 'test',
                textStyle: fontVaike,
              ),
            ),
          ],
          primaryXAxis: CategoryAxis(
            //interval: 1,
            labelRotation: 270,
            labelStyle: fontVaike,
            //visibleMinimum: -0.5,
            //minimum: 0
          ),
          primaryYAxis: NumericAxis(
            isVisible: false,
            title: AxisTitle(
              text: 'test',
              textStyle: fontVaike,
            ),
          ),
          series: <ChartSeries>[
            StackedColumnSeries<ChartDataPoint, int>(
              width: 0.9,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              //splineType: SplineType.monotonic,
              dataSource: dataPoints,
              yAxisName: 'firstAxis',
              dataLabelSettings: DataLabelSettings(
                offset: Offset(0, -10),
                isVisible: true,
                labelAlignment: ChartDataLabelAlignment.outer,
                textStyle: fontVaike,
                angle: 270,
              ),
              xValueMapper: (ChartDataPoint data, _) => data.x,
              yValueMapper: (ChartDataPoint data, _) => data.y,
            ),
            StackedColumnSeries<ChartDataPoint, int>(
                //splineType: SplineType.monotonic,
                width: 0.9,
                color: Colors.green,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                dataSource: dataPoints,
                yAxisName: 'secondAxis',
                groupName: 'A',
                dataLabelSettings: DataLabelSettings(
                  offset: Offset(0, -20),
                  isVisible: true,
                  labelAlignment: ChartDataLabelAlignment.outer,
                  textStyle: fontVaike,
                  angle: 270,
                ),
                dataLabelMapper: (data, _) {
                  // Display the data label only if the consumption is not 0
                  if (data.y == 0) {
                    return ''; // Customize this as needed
                  } else {
                    String temp3 = "";
                    if (data.y < 1) {
                      double abi = data.y * 100;
                      temp3 = abi.toStringAsFixed(2);
                      return '$temp3 senti';
                    }
                    temp3 = data.y.toStringAsFixed(2);
                    return '$temp3€';
                  }
                },
                xValueMapper: (ChartDataPoint data, _) => data.x,
                yValueMapper: (ChartDataPoint data, _) {
                  final yValue = data.y;
                  return yValue == 0
                      ? 0
                      : yValue < maxYValue * 0.4
                          ? maxYValue * 0.4
                          : yValue;
                }),
          ],
        ),
      ),
    );
  }
}

class ChartDataPoint {
  final int x;
  final double y;

  ChartDataPoint({required this.x, required this.y});
}
