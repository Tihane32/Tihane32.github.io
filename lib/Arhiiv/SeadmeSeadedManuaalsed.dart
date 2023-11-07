import 'package:flutter/material.dart';
import 'dart:convert';
import 'graafikuKoostamine.dart';
import 'package:testuus4/Arhiiv/kaksTabelit.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:testuus4/funktsioonid/Elering.dart';
import 'seadmedKontoltNim.dart';

class SeadmeSeadedManuaalsed extends StatelessWidget {
  final String value;
  const SeadmeSeadedManuaalsed({Key? key, required this.value})
      : super(key: key);

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
                'Lülitus graafik:',
                style: TextStyle(fontSize: 20, color: Colors.white),
              )),
            ),
          ),
          Expanded(
            child: _LulitusGraafik(),
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
            child: Container(
              color: Colors.amber,
            ),
          )
        ],
      ),
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

  Future test() async {
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
    DateTime now = DateTime.now();
    int tana = now.weekday - 1;

    List<String> newList = [];
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    var data = {
      'channel': '0',
      'id': '80646f81ad9a',
      'auth_key':
          'MTcxYTNjdWlk99F3FBAA1664CCBA1DB1A6FE1A156072DB6AF5A8F1B4A1B0ACB7C82002649DADF1114D97483D4E12',
    };

    var url = Uri.parse('https://shelly-64-eu.shelly.cloud/device/settings');
    var res = await http.post(url, headers: headers, body: data);
    await Future.delayed(const Duration(seconds: 2));
    //Kui post läheb läbi siis:

    final httpPackageJson = json.decode(res.body) as Map<String, dynamic>;

    final scheduleRules1 = httpPackageJson['data']['device_settings']['relays']
        [0]['schedule_rules'];

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
      print(elering[0]['price']);

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
            print('oige: $j');
            if (parts[2] == 'on') {
              lulitus[asendus][2] = true;
              k = true;
              print('sisse');
            } else {
              lulitus[asendus][2] = false;
              k = false;
              print('välja');
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

  @override
  void initState() {
    test();
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
                  data[2] ? Colors.green : Colors.red,
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
