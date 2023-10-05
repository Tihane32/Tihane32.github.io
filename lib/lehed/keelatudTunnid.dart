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
  KeelatudTunnid({Key? key, this.valitudSeadmed, required this.luba})
      : super(key: key);
  String luba;
  final valitudSeadmed;
  @override
  _KeelatudTunnidState createState() =>
      _KeelatudTunnidState(valitudSeadmed: valitudSeadmed, luba: luba);
}

class _KeelatudTunnidState extends State<KeelatudTunnid> {
  _KeelatudTunnidState({
    Key? key,
    required this.valitudSeadmed,
    required this.luba,
  });

  String luba;
  var valitudSeadmed;
  int koduindex = 1;
  Set<int> _selectedHours = {};
  Color valitudvarv = Colors.red;

  @override
  void initState() {
    super.initState();

    if (luba == 'ei') {
      valitudvarv = Colors.red;
    } else {
      valitudvarv = Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 115, 162, 195),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$luba tundide valimine'),
          ],
        ),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: 24,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('$index:00'),
            tileColor:
                _selectedHours.contains(index) ? valitudvarv : Colors.grey,
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
    );
  }
}
