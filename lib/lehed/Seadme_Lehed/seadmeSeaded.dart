import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/funktsioonid/graafikGen2.dart';
import 'dart:convert';
import '../../main.dart';
import '../../Arhiiv/graafikuKoostamine.dart';
import 'package:testuus4/Arhiiv/kaksTabelit.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:testuus4/funktsioonid/Elering.dart';
import '../../Arhiiv/seadmedKontoltNim.dart';

class SeadmeSeaded extends StatelessWidget {
  final String value;
  const SeadmeSeaded({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Device Settings',
      //theme: ThemeData(
      //primarySwatch: Colors.blue,
      //),
      //theme: ThemeData.dark(),
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
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MinuSeadmed()),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SeadmeNimi(
                            value: widget.value,
                          )),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.calendar_today_rounded),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GraafikLeht(widget.value)),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
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
                'Lülitusgraafik:',
                style: TextStyle(fontSize: 20, color: Colors.white),
              )),
            ),
          ),
          Expanded(
            child: _LulitusGraafik(value: value),
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

class _LulitusGraafik extends StatefulWidget {
  final String value;
  const _LulitusGraafik({Key? key, required this.value}) : super(key: key);

  @override
  _LulitusGraafikState createState() => _LulitusGraafikState();
}

class _LulitusGraafikState extends State<_LulitusGraafik> {
  late Map<String, dynamic> lulitus;

  Future test(String value) async {
    lulitus = {
      '0000': ['00.00', 0, false],
      '0100': ['01.00', 0, false],
      '0200': ['02.00', 0, true],
      '0300': ['03.00', 0, false],
      '0400': ['04.00', 0, true],
      '0500': ['05.00', 0, true],
      '0600': ['06.00', 0, false],
      '0700': ['07.00', 0, true],
      '0800': ['08.00', 0, false],
      '0900': ['09.00', 0, true],
      '1000': ['10.00', 0, false],
      '1100': ['11.00', 0, true],
      '1200': ['12.00', 0, true],
      '1300': ['13.00', 0, true],
      '1400': ['14.00', 0, true],
      '1500': ['15.00', 0, true],
      '1600': ['16.00', 0, true],
      '1700': ['17.00', 0, true],
      '1800': ['18.00', 0, false],
      '1900': ['19.00', 0, true],
      '2000': ['20.00', 0, false],
      '2100': ['21.00', 0, true],
      '2200': ['22.00', 0, false],
      '2300': ['23.00', 0, false],
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();

    []; //Võtab mälust 'users'-i asukohast väärtused
    var seadmedJSONmap = prefs.getString('seadmed');

    Map<String, dynamic> storedMap = json.decode(seadmedJSONmap!);

    String? storedKey = prefs.getString('key');

    String storedKeyString = jsonDecode(storedKey!);
    var j = 0;
    var authKey = storedKeyString;
    // ignore: unused_local_variable
    for (var i in storedMap.values) {
      if (storedMap['Seade$j']['Seadme_ID'] == value) {
        var seadeGen = storedMap['Seade$j']['Seadme_generatsioon'] as int;

        if (seadeGen == 2) {
          bool k = false;
          var graafikud = Map<String, dynamic>();

          //await graafikuteSaamine(graafikud, value);
          var elering = await getElering('täna');
          setState(() {
            j = 0;
            for (var i = 0; i < 24; i++) {
              String asendus = '$j';
              print('asenuds');
              print(j);

              if (j < 10) {
                asendus = '0' + asendus + '00';
              } else {
                asendus = asendus + '00';
              }
              print(asendus);

              lulitus[asendus][1] = elering[i]['price'];

              //print(lulitus[asendus][1]);

              //print(elering[i]['price']);
              var s = 1;
              // ignore: unused_local_variable
              for (var devices in graafikud.values) {
                var aeg = graafikud['$s']['Timespec'];
                bool onoff = graafikud['$s']['On/Off'];

                List<String> parts = aeg.split(' ');
                var temp = parts[2];
                var u = int.parse(temp);
                var ajutine = parts[2] as String;

                if (u < 10) {
                  ajutine = '0' + ajutine + '.00';
                } else {
                  ajutine = ajutine + '.00';
                }
                if (lulitus[asendus][0] == ajutine) {
                  lulitus[asendus][2] = onoff;
                  k = onoff;
                }
                print('siin');
                print(lulitus[asendus][1]);
                lulitus[asendus][2] = k;
                if (s < graafikud.length) {
                  s++;
                }
              }
              if (j != 23) {
                j++;
              }
            }
            print(lulitus);
          });
        }
        if (seadeGen == 1) {
          DateTime now = DateTime.now();
          int tana = now.weekday - 1;

          List<String> newList = [];
          var headers = {
            'Content-Type': 'application/x-www-form-urlencoded',
          };

          var data = {
            'channel': '0',
            'id': value,
            'auth_key': authKey,
          };

          var url =
              Uri.parse('${seadmeteMap[value]["api_url"]}/device/settings');
          var res = await http.post(url, headers: headers, body: data);
          await Future.delayed(const Duration(seconds: 2));
          //Kui post läheb läbi siis:

          final httpPackageJson = json.decode(res.body) as Map<String, dynamic>;

          var scheduleRules1 = httpPackageJson['data']['device_settings']
              ['relays'][0]['schedule_rules'];
          print(scheduleRules1);
          var ajutine = prefs.getString('dynamicList$value');
          print('dynamicList$value');
          print('asjutine $ajutine');
          if (ajutine != null) {
            scheduleRules1 = ajutine.split(',');
          }
          for (String item in scheduleRules1) {
            List<String> parts = item.split('-');
            if (parts[1].length > 1) {
              for (int i = 0; i < parts[1].length; i++) {
                //lülituskäsk tehakse iga "-" juures pooleks ja lisatakse eraldi listi
                String newItem = '${parts[0]}-${parts[1][i]}-${parts[2]}';
                newList.add(newItem);
              }
            } else {
              newList.add(item);
            }
          }
          List<String> filteredRules = [];

          RegExp regExp = RegExp("-$tana-");

          for (var rule in newList) {
            if (regExp.hasMatch(rule)) {
              filteredRules.add(rule);
            }
          }
          var elering = await getElering('täna');
          var i = 0;

          setState(() {
            i = filteredRules.length;
            var u = 0;

            bool k = false;
            for (var j = 0; j < 24; j++) {
              String asendus = '$j';
              if (j < 10) {
                asendus = '0' + asendus + '00';
              } else {
                asendus = asendus + '00';
              }
              for (u = 0; u < i; u++) {
                List<String> parts = filteredRules[u].split('-');

                String timeString = parts[0];
                String formattedTime =
                    timeString.substring(0, 2) + '.' + timeString.substring(2);

                if (formattedTime == lulitus[asendus][0]) {
                  if (parts[2] == 'on') {
                    lulitus[asendus][2] = true;
                    k = true;
                  } else {
                    lulitus[asendus][2] = false;
                    k = false;
                  }
                } /*else {
            if (j != 0) {
              var ajutine = j - 1;

              String asendus1 = '$ajutine';
              if (ajutine < 10) {
                asendus1 = '0' + asendus1 + '00';
              } else {
                asendus1 = asendus1 + '00';
              }

              lulitus[asendus][2] = lulitus[asendus1][2];
            }
          }*/
                //print(lulitus['$j']);
              }
              lulitus[asendus][2] = k;
              lulitus[asendus][1] = elering[j]['price'];
            }
          });
        }
        break;
      }
      j++;
    }
  }

  @override
  void initState() {
    test(widget.value);
    super.initState();
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
                  data[2] ? Colors.green : Color.fromARGB(255, 164, 159, 159),
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                labelAlignment: ChartDataLabelAlignment.middle,
                textStyle: TextStyle(fontSize: 10, color: Colors.black),
                angle: 270,
              )),
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
    var data = {
      'id': value,
      'channel': '0',
      'date_range': 'custom',
      'date_from': '2023-04-01 00:00:00',
      'date_to': '2023-04-30 23:59:59',
    };

    var url = Uri.parse(
        '${seadmeteMap[value]["api_url"]}/statistics/relay/consumption');
    var res = await http.post(url, headers: headers, body: data);
    if (res.statusCode != 200)
      throw Exception('http.post error: statusCode= ${res.statusCode}');
    final jsonData = json.decode(res.body);
    final historyData = jsonData['data']['history'] as List<dynamic>;
    print(historyData);
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
      child: FutureBuilder<void>(
        future: fetchData(widget.value),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: SfCartesianChart(
                primaryXAxis: DateTimeAxis(title: AxisTitle(text: 'Kuupäev')),
                primaryYAxis: NumericAxis(
                  labelFormat: '{value} Wh',
                  labelRotation: 45,
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
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.date, this.consumption);

  final DateTime date;
  final double consumption;
}
