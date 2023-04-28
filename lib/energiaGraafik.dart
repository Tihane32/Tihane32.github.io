import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
    var headers = {
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/112.0',
      'Accept': 'application/json, text/plain, */*',
      'Accept-Language': 'en-US,en;q=0.5',
      'Accept-Encoding': 'gzip, deflate, br',
      'Authorization':
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJwd2QiLCJpYXQiOjE2ODI3MTI3ODIsInVzZXJfaWQiOiIxNTE0MDQ0Iiwic24iOiIxIiwidXNlcl9hcGlfdXJsIjoiaHR0cHM6XC9cL3NoZWxseS02NC1ldS5zaGVsbHkuY2xvdWQiLCJuIjo0ODkxLCJleHAiOjE2ODI3OTkxODJ9.bYPlbAuHARSarJ6J_8l8PLzJG463YePltVS5jxKR-QI',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Origin': 'https://home.shelly.cloud',
      'Connection': 'keep-alive',
      'Referer': 'https://home.shelly.cloud/',
      'Sec-Fetch-Dest': 'empty',
      'Sec-Fetch-Mode': 'cors',
      'Sec-Fetch-Site': 'same-site',
    };
    print('siin');
    var data = {
      'id': '30c6f7828098',
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

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Chart'),
      ),
      body: FutureBuilder<void>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: SfCartesianChart(
                primaryXAxis: DateTimeAxis(),
                series: <ChartSeries<_ChartData, DateTime>>[
                  LineSeries<_ChartData, DateTime>(
                    dataSource: chartData,
                    xValueMapper: (_ChartData data, _) => data.date,
                    yValueMapper: (_ChartData data, _) => data.consumption,
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
