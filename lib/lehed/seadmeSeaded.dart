import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/lehed/energiaGraafik.dart';
import 'dart:convert';
import 'graafikuKoostamine.dart';
import 'package:testuus4/lehed/kaksTabelit.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

class SeadmeSeaded extends StatelessWidget {
  final String value;
  const SeadmeSeaded({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Device Settings',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DeviceSettingsPage(value: value),
    );
  }
}

class DeviceSettingsPage extends StatefulWidget {
  final String value;
  const DeviceSettingsPage({Key? key, required this.value}) : super(key: key);

  @override
  _DeviceSettingsPageState createState() =>
      _DeviceSettingsPageState(value: value);
}

class _DeviceSettingsPageState extends State<DeviceSettingsPage> {
  final String value;
  _DeviceSettingsPageState({Key? key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Settings'),
        leading: IconButton(
          icon: const Icon(Icons.navigate_before),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MinuSeadmed()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GraafikLeht(widget.value)),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SeadmeNimi(value: value),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(style: BorderStyle.solid, width: 1.0),
              ),
              child: Center(
                  child: Text(
                'Tarbimise graafik:',
                style: TextStyle(fontSize: 20, color: Colors.white),
              )),
            ),
          ),
          Expanded(
            child: EGraafik(value: value),
          ),
        ],
      ),
    );
  }
}

class SeadmeNimi extends StatefulWidget {
  final String value;
  const SeadmeNimi({Key? key, required this.value}) : super(key: key);

  @override
  _SeadmeNimiState createState() => _SeadmeNimiState();
}

class _SeadmeNimiState extends State<SeadmeNimi> {
  late TextEditingController _controller;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _loadPreferences(widget.value);
  }

  Future<void> _loadPreferences(String value) async {
    prefs = await SharedPreferences.getInstance();
    String? storedJsonMap = prefs.getString('seadmed');
    print(value);
    Map<String, dynamic> storedMap = json.decode(storedJsonMap!);
    var j = 0;
    for (var i in storedMap.values) {
      if (storedMap['Seade$j']['Seadme_ID'] == value) {
        await prefs.setString('KohaNumber', '$j');
        var name = storedMap['Seade$j']['Seadme_nimi'];
        setState(() {
          _controller.text = name;
        });
      }

      j++;
    }
  }

  Future<void> _savePreferences(String name) async {
    prefs = await SharedPreferences.getInstance();
    String? storedJsonMap = prefs.getString('seadmed');
    String? koht = prefs.getString('KohaNumber');
    Map<String, dynamic> storedMap = json.decode(storedJsonMap!);
    print('map $storedMap');

    var seade = storedMap['Seade$koht'];
    seade['Seadme_nimi'] = name;
    storedMap['Seade$koht'] = seade;
    await prefs.setString('seadmed', json.encode(storedMap));
    print(storedMap);
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
  final String value;

  EGraafik({required this.value});
  @override
  _EGraafikState createState() => _EGraafikState();
}

class _EGraafikState extends State<EGraafik> {
  List<_ChartData> chartData = [];

  Future<void> fetchData(value) async {
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
      'id': value,
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
    fetchData(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: fetchData(widget.value),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Center(
            child: SfCartesianChart(
              primaryXAxis:
                  DateTimeAxis(title: AxisTitle(text: 'Kuupäev'), interval: 5),
              primaryYAxis: NumericAxis(
                labelFormat: '{value} Wh',
                title: AxisTitle(text: 'Tarbimine'),
              ),
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
