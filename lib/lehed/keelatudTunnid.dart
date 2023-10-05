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

class KeelatudTunnid extends StatefulWidget {
  KeelatudTunnid({Key? key, this.valitudSeadmed}) : super(key: key);
  final valitudSeadmed;
  @override
  _KeelatudTunnidState createState() => _KeelatudTunnidState(
        valitudSeadmed: valitudSeadmed,
      );
}

class _KeelatudTunnidState extends State<KeelatudTunnid> {
  _KeelatudTunnidState({
    Key? key,
    required this.valitudSeadmed,
  });

  var valitudSeadmed;
  int koduindex = 1;
  Set<int> _selectedHours = {};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Scaffold(
        body: ListView.builder(
          shrinkWrap: true,
          itemCount: 24,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text('$index:00'),
              tileColor:
                  _selectedHours.contains(index) ? Colors.red : Colors.green,
              onTap: () {
                setState(() {
                  if (_selectedHours.contains(index)) {
                    _selectedHours.remove(index);
                  } else {
                    _selectedHours.add(index);
                  }
                });
              },
            );
          },
        ),
      ),
    );
  }
}
