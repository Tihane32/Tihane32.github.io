import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/funktsioonid/token.dart';
//void main() => runApp(MyApp());

class EnergiaGraafikApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Chart App',
      home: MyChartPage(),
    );
  }
}

class MyChartPage extends StatefulWidget {
  @override
  _MyChartPageState createState() => _MyChartPageState();
}

class _MyChartPageState extends State<MyChartPage> {
  List<_ChartData> chartData = [];

  Future<void> fetchData() async {
    /*SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ajutineKasutajanimi = prefs.getString('Kasutajanimi');
    String? sha1Hash = prefs.getString('Kasutajaparool');

var headers1 = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    var kasutajaAndmed = {
      'email': ajutineKasutajanimi,
      'password': sha1Hash,
      'var': '2',
    };
    var sisselogimiseUrl = Uri.parse('https://api.shelly.cloud/auth/login');
    var sisselogimiseVastus = await http.post(sisselogimiseUrl,
        headers: headers1, body: kasutajaAndmed);
var vastusJSON =
        json.decode(sisselogimiseVastus.body) as Map<String, dynamic>;
    var token = vastusJSON['data']['token'];
    */

    var headers = {
    'Authorization': 'Bearer $token',
    };
    print('siin');
    var data = {
      'id': '80646f81ad9a',
      'channel': '0',
      'date_range': 'custom',
      'date_from': '2023-04-01 00:00:00',
      'date_to': '2023-04-30 23:59:59',
    };

    var url = Uri.parse(
        'https://shelly-64-eu.shelly.cloud/statistics/relay/consumption');
    var res = await http.post(url, headers: headers, body: data);
    if (res.statusCode != 200)
      throw Exception('http.post error: statusCode= ${res.statusCode}');
    final jsonData = json.decode(res.body);
    final historyData = jsonData['data']['history'] as List<dynamic>;

    chartData = historyData
        .map((history) => _ChartData(DateTime.parse(history['datetime']),
            history['consumption'].toDouble()))
        .toList();
  }

  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, header: 'Tarbitud:');
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarbimise graafik'),
      ),
      body: FutureBuilder<void>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: SfCartesianChart(
                primaryXAxis: DateTimeAxis(
                    title: AxisTitle(text: 'Kuupäev'), interval: 1),
                primaryYAxis: NumericAxis(
                    labelFormat: '{value} Wh',
                    title: AxisTitle(text: 'Tarbimine'),
                    interval: 10),
                tooltipBehavior: _tooltipBehavior,
                series: <ChartSeries<_ChartData, DateTime>>[
                  SplineSeries<_ChartData, DateTime>(
                    splineType: SplineType.monotonic,
                    dataSource: chartData,
                    xValueMapper: (_ChartData data, _) => data.date,
                    yValueMapper: (_ChartData data, _) => data.consumption,
                    enableTooltip: true,
                  ),
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.date, this.consumption);

  final DateTime date;
  final double consumption;
}
