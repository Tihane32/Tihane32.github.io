import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:testuus4/funktsioonid/Elering.dart';
import 'package:testuus4/funktsioonid/tarbmineSeadmeKohta.dart';
import 'package:testuus4/main.dart';

double findMaximumYValue(dataPoints) {
  double max = double.negativeInfinity;
  for (int i = 0; i < dataPoints.length; i++) {
    print('Data Point $i: x=${dataPoints[i].x}, y=${dataPoints[i].y}');
    if (dataPoints[i].y > max) {
      max = dataPoints[i].y;
    }
  }
  return max;
}

class PaevaTarbimine extends StatefulWidget {
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
  State<PaevaTarbimine> createState() => _PaevaTarbimineState();
}

class _PaevaTarbimineState extends State<PaevaTarbimine> {
  List<double> paevaTarbimine = [];
  List<double> paevaHind = [];
  String formattedDate = '';
  getList() async {
    String dateTimeString =
        '${widget.date}'; // Replace with your widget.date value

// Parse the datetime string into a DateTime object
    DateTime dateTime = DateTime.parse(dateTimeString);

// Format the DateTime object to get yyyy-MM-dd
    formattedDate = DateFormat('yyyy.MM.dd').format(dateTime);
    var temp = await getTarbimine(widget.value, widget.date, "day");

    List<double> temp2 =
        await getElering(dateTime, dateTime.add(Duration(days: 1)));
    setState(() {
      paevaTarbimine = temp;
      paevaHind = temp2;
      print('paevagraafik $paevaTarbimine << ${widget.paevaMaksumus}');
    });
  }

  @override
  void initState() {
    getList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<double> temp = widget.paevaMaksumus[widget.rowIndex]!;
    final List<int> xValues = List.generate(temp.length, (index) => index);
    final List<String> customLabels = [
      '00:00',
      '01:00',
      '02:00',
      '03:00',
      '04:00',
      '05:00',
      '06:00',
      '07:00',
      '08:00',
      '09:00',
      '10:00',
      '11:00',
      '12:00',
      '13:00',
      '14:00',
      '15:00',
      '16:00',
      '17:00',
      '18:00',
      '19:00',
      '20:00',
      '21:00',
      '22:00',
      '23:00',
      '24:00',
    ];
    final List<ChartDataPoint> dataPoints = [];
    for (int i = 0; i < temp.length; i++) {
      dataPoints.add(ChartDataPoint(x: customLabels[i], y: temp[i]));
    }
    final List<ChartDataPoint> dataPoints2 = [];
    for (int i = 0; i < paevaTarbimine.length; i++) {
      dataPoints2.add(ChartDataPoint(x: customLabels[i], y: paevaTarbimine[i]));
    }

    final List<ChartDataPoint> dataPoints3 = [];
    for (int i = 0; i < paevaHind.length; i++) {
      dataPoints3.add(ChartDataPoint(x: customLabels[i], y: paevaHind[i]));
    }

    double maxYValue = findMaximumYValue(dataPoints);
    double maxYValue2 = findMaximumYValue(dataPoints2);
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            child: Align(
              child: Text(
                '${formattedDate}',
                style: fontSuur,
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            //width: MediaQuery.of(context).size.width * 3,
            height: MediaQuery.of(context).size.height,
            child: RotatedBox(
              quarterTurns: 1,
              child: SfCartesianChart(
                tooltipBehavior: TooltipBehavior(
                  enable: false, // Enable tooltips for this series
                ),
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
                  NumericAxis(
                      name: 'thirdAxis',
                      isVisible: true,
                      title: AxisTitle(
                        alignment: ChartAlignment.center,
                        text: '€/MWh',
                        textStyle: fontVaike,
                      ),
                      labelStyle: fontVaike),
                  NumericAxis(
                    name: 'xAxis',
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
                  StackedColumnSeries<ChartDataPoint, String>(
                    color: Colors.blue,
                    width: 0.9,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    //splineType: SplineType.monotonic,
                    dataSource: dataPoints2,
                    yAxisName: 'firstAxis',
                    dataLabelSettings: DataLabelSettings(
                      offset: Offset(0, 0),
                      isVisible: true,
                      labelAlignment: ChartDataLabelAlignment.bottom,
                      textStyle: fontVaike,
                      angle: 270,
                    ),
                    xValueMapper: (ChartDataPoint data, _) => data.x,
                    yValueMapper: (ChartDataPoint data, _) {
                      final yValue = data.y;
                      return yValue == 0
                          ? 0
                          : yValue < maxYValue2 * 0.4
                              ? maxYValue2 * 0.4
                              : yValue;
                    },

                    dataLabelMapper: (data, _) {
                      print(temp);
                      // Display the data label only if the consumption is not 0
                      if (data.y == 0) {
                        return ''; // Customize this as needed
                      } else {
                        String temp3 = "";

                        temp3 = data.y.toStringAsFixed(2);
                        return '$temp3 Wh';
                      }
                    },
                  ),
                  StackedColumnSeries<ChartDataPoint, String>(
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
                        offset: Offset(0, 0),
                        isVisible: true,
                        labelAlignment: ChartDataLabelAlignment.bottom,
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
                  /*SplineSeries<ChartDataPoint, int>(
                      enableTooltip: true,
                      splineType: SplineType.cardinal,
                      cardinalSplineTension: 1,
                      width: 0.9,
                      color: Colors.red,
                      dataSource: dataPoints3,
                      yAxisName: 'thirdAxis',
                      xAxisName: "xAxis",
                      dataLabelSettings: DataLabelSettings(
                        offset: Offset(0, 0),
                        isVisible: false,
                        labelAlignment: ChartDataLabelAlignment.bottom,
                        textStyle: fontVaike,
                        angle: 270,
                      ),
                      xValueMapper: (ChartDataPoint data, _) => data.x,
                      yValueMapper: (ChartDataPoint data, _) => data.y),*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChartDataPoint {
  final String x;
  final double y;

  ChartDataPoint({required this.x, required this.y});
}
