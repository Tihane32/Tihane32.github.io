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
import 'DynaamilineTundideValimine.dart';
import 'hinnaPiiriAluselTunideValimine.dart';
import 'package:http/http.dart' as http;

import 'keelatudTunnid.dart';

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
  String _selectedTheme = 'Odavaimad Tunnid';
  double _selectedDuration = 7;
  Map<double, String> _durationMap = {
    1: '1 päev',
    2: '2 päeva',
    3: '3 päeva',
    4: '4 päeva',
    5: '5 päeva',
    6: '6 päeva',
    7: '1 nädal',
    8: '2 nädalat',
    9: '3 nädalat',
    10: '1 kuu',
    11: '2 kuud',
    12: '3 kuud',
    13: 'pool aastat',
    14: 'igavesti',
  };
  Set<int> _selectedHours = {};
  TextEditingController _textController = TextEditingController();
  String? get readableDuration => _durationMap[_selectedDuration];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Saada teavitus kui seade ei ole kättesaadav'),
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
              title: Text('Kestus: $readableDuration'),
              subtitle: Slider(
                value: _selectedDuration,
                onChanged: (newValue) {
                  setState(() {
                    _selectedDuration = newValue;
                  });
                },
                divisions: 13,
                min: 1,
                max: 14,
                label: readableDuration,
              ),
            ),
            ListTile(
              title: Text('Vali lülitusgraafiku koostamis algoritm'),
              trailing: DropdownButton<String>(
                value: _selectedTheme,
                onChanged: (lylitusViis) {
                  setState(() {
                    _selectedTheme = lylitusViis!;
                  });
                },
                items: <String>[
                  'Odavaimad Tunnid',
                  'Hinnapiir',
                  'Minu eelistusd',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Visibility(
              visible: _selectedTheme == 'Odavaimad Tunnid',
              child: ListTile(
                title: Text('Sisesta soovitud tundide arv'),
                trailing: Container(
                  width: 100,
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _selectedTheme == 'Hinnapiir',
              child: ListTile(
                title: Text('Sisesta hinnapiir'),
                trailing: Container(
                  width: 100,
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
                title: Text('Vali tunnid kus seade peab töötama'),
                trailing: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DynamilineTundideValimine(
                                valitudSeadmed: valitudSeadmed,
                                i: 4,
                                luba: 'jah')),
                      );
                    },
                    icon: Icon(
                      Icons.more_time_rounded,
                      color: Colors.green,
                      size: 30,
                    ))),
            ListTile(
                title: Text('Vali tunnid kus seade ei tohi töödata'),
                trailing: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DynamilineTundideValimine(
                                valitudSeadmed: valitudSeadmed,
                                i: 4,
                                luba: 'ei')),
                      );
                    },
                    icon: Icon(
                      Icons.more_time_rounded,
                      color: Colors.red,
                      size: 30,
                    ))),
          ],
        ),
      ),
    );
  }
}
