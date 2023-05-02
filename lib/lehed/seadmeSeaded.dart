import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  late TextEditingController _controller;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    String? storedJsonMap = prefs.getString('seadmed');

    Map<String, dynamic> storedMap = json.decode(storedJsonMap!);

    var name = storedMap['Seade0']['Seadme_nimi'];

    setState(() {
      _controller.text = name;
    });
  }

  Future<void> _savePreferences(String name) async {
    await prefs.setString('seadmed', name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Settings'),
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
          ],
        ),
      ),
    );
  }
}
