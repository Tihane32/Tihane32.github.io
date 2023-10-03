import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/lehed/GraafikusseSeadmeteValik.dart';
import 'package:testuus4/lehed/dynamicKoduLeht.dart';
import 'package:testuus4/lehed/keskimiseHinnaAluselTundideValimine.dart';
import '../funktsioonid/seisukord.dart';
import '../main.dart';
import 'AbiLeht.dart';
import 'hinnaPiiriAluselTunideValimine.dart';
import 'package:http/http.dart' as http;

class AutoTundideValik extends StatefulWidget {
  final Function updateValitudSeadmed;
  AutoTundideValik(
      {Key? key, this.valitudSeadmed, required this.updateValitudSeadmed})
      : super(key: key);
  final valitudSeadmed;
  @override
  _AutoTundideValikState createState() => _AutoTundideValikState(
      valitudSeadmed: valitudSeadmed,
      updateValitudSeadmed: updateValitudSeadmed);
}

class _AutoTundideValikState extends State<AutoTundideValik> {
  _AutoTundideValikState(
      {Key? key,
      required this.valitudSeadmed,
      required this.updateValitudSeadmed});
  Function updateValitudSeadmed;
  var valitudSeadmed;
  int koduindex = 1;
  bool isLoading = true;
  String selectedPage = 'Kopeeri graafik';
  double vahe = 10;
  int valitudTunnid = 10;
  Color boxColor = sinineKast;
  bool _notificationsEnabled = false;
  String _selectedTheme = 'Light';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Enable Notifications'),
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Seaded'),
              trailing: DropdownButton<String>(
                value: _selectedTheme,
                onChanged: (value) => _notificationsEnabled,
                items: <String>['Light', 'Dark']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            // Add more settings options as you need
          ],
        ),
      ),
    );
  }
}
