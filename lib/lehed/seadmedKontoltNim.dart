import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/funktsioonid/Elering.dart';
import '../funktsioonid/CurrentPrice.dart';
import 'Graafik.dart';
import 'OnOff.dart';
import 'Login.dart';
import 'kaksTabelit.dart';
import 'graafikuValimine.dart';
import 'hinnaGraafik.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[600],
        title: const Text('Shelly pistik'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginApp()),
              );
            },
            child: const Text('Log in'),
          ),
        ],
      ),
      body: Column(
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