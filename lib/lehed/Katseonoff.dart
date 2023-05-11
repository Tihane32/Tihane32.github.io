import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(GraafikAPP());
}

class GraafikAPP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: _LulitusGraafik(),
    );
  }
}

class _LulitusGraafik extends StatefulWidget {
  const _LulitusGraafik({Key? key}) : super(key: key);

  @override
  _LulitusGraafikState createState() => _LulitusGraafikState();
}

class _LulitusGraafikState extends State<_LulitusGraafik> {
  late Map<String, dynamic> lulitus;

  @override
  void initState() {
    super.initState();
    lulitus = {
      '00': ['00.00', 12, false],
      '01': ['01.00', 15, false],
      '02': ['02.00', 30, true],
      '03': ['03.00', 6.4, false],
      '04': ['04.00', 14, true],
      '05': ['05.00', 18, true],
      '06': ['06.00', 20, false],
      '07': ['07.00', 12, true],
      '08': ['08.00', 8, false],
      '09': ['09.00', 22, true],
      '10': ['10.00', 16, false],
      '11': ['11.00', 19, true],
      '12': ['12.00', 24, true],
      '13': ['13.00', 28, true],
      '14': ['14.00', 60, true],
      '15': ['15.00', 32, true],
      '16': ['16.00', 36, true],
      '17': ['17.00', 34, true],
      '18': ['18.00', 28, false],
      '19': ['19.00', 24, true],
      '20': ['20.00', 20, false],
      '21': ['21.00', 18, true],
      '22': ['22.00', 14, true],
      '23': ['23.00', 12, false],
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(
          minimum: 0,
        ),
        series: [
          ColumnSeries(
              dataSource: lulitus.values.toList(),
              xValueMapper: (data, _) => data[0],
              yValueMapper: (data, _) => data[1],
              dataLabelMapper: (data, _) => data[1].toString() + '€/MWh',
              pointColorMapper: (data, _) =>
                  data[2] ? Colors.green : Colors.red,
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                labelAlignment: ChartDataLabelAlignment.middle,
                textStyle: TextStyle(fontSize: 20, color: Colors.black),
                angle: 270,
              )),
        ],
      ),
    );
  }
}
