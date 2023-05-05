import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/lehed/energiaGraafik.dart';
import 'dart:convert';
import 'graafikuKoostamine.dart';
import 'package:testuus4/lehed/kaksTabelit.dart';

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
  _DeviceSettingsPageState createState() => _DeviceSettingsPageState();
}

class _DeviceSettingsPageState extends State<DeviceSettingsPage> {
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
                MaterialPageRoute(builder: (context) => GraafikLeht(widget.value)),
              );
            },
          ),
        ],
      ),
      body: Padding(
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
                  SnackBar(
                    content: Text('Device name saved: $name'),
                  ),
                );
              },
              child: const Text('Save'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EnergiaGraafikApp()),
                );
              },
              child: const Text('Vaata tarbimise graafikut'),
            ),
          ],
        ),
      ),
    );
  }
}
