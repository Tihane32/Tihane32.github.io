import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

void main() => runApp(SeadmeInfo());

class SeadmeInfo extends StatelessWidget {
  const SeadmeInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Device Settings',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DeviceSettingsPage(),
    );
  }
}

class DeviceSettingsPage extends StatefulWidget {
  const DeviceSettingsPage({Key? key}) : super(key: key);

  @override
  _DeviceSettingsPageState createState() => _DeviceSettingsPageState();
}

class _DeviceSettingsPageState extends State<DeviceSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Device Settings'),
        ),
        body: Column(
          children: [
            Expanded(
              child: SeadmeNimi(),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Tarbimise graafik:',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Expanded(
              child: EGraafik(),
            ),
          ],
        ));
  }
}

class SeadmeNimi extends StatefulWidget {
  const SeadmeNimi({Key? key}) : super(key: key);

  @override
  _SeadmeNimiState createState() => _SeadmeNimiState();
}

class _SeadmeNimiState extends State<SeadmeNimi> {
  late TextEditingController _controller;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    String? storedJsonMap = _prefs.getString('seadmed');

    if (storedJsonMap != null) {
      Map<String, dynamic> storedMap = json.decode(storedJsonMap);
      var name = storedMap['Seade0']['Seadme_nimi'];
      setState(() {
        _controller.text = name;
      });
    }
  }

  Future<void> _savePreferences(String name) async {
    await _prefs.setString(
        'seadmed',
        json.encode({
          'Seade0': {'Seadme_nimi': name}
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Device Name',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          const SizedBox(height: 8.0),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter device name',
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () async {
              String name = _controller.text.trim();
              await _savePreferences(name);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Device name saved'),
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class EGraafik extends StatefulWidget {
  @override
  _EGraafikState createState() => _EGraafikState();
}

class _EGraafikState extends State<EGraafik> {
  List<_ChartData> chartData = [];

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
    //Todo peab lisama beareri saamise
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
    return FutureBuilder<void>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Center(
            child: SfCartesianChart(
              primaryXAxis:
                  DateTimeAxis(title: AxisTitle(text: 'Kuupäev'), interval: 1),
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
    );
  }
}

class _ChartData {
  _ChartData(this.date, this.consumption);

  final DateTime date;
  final double consumption;
}
