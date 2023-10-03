import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testuus4/lehed/DynaamilineTundideValimine.dart';
import 'package:testuus4/lehed/GraafikusseSeadmeteValik.dart';
import 'package:testuus4/lehed/dynamicKoduLeht.dart';
import '../funktsioonid/Elering.dart';
import '../main.dart';
import 'AbiLeht.dart';
import 'koduleht.dart';
import 'hinnaPiiriAluselTunideValimine.dart';
import 'dart:math';
import 'package:testuus4/lehed/kaksTabelit.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'kopeeeriGraafikTundideValimine.dart';
import 'package:testuus4/lehed/DynaamilineTundideValimine.dart';

class AutoTundideValimine extends StatefulWidget {
  final Function updateLulitusMap;

  AutoTundideValimine(
      {Key? key, required this.lulitusMap, required this.updateLulitusMap})
      : super(key: key);

  var lulitusMap;
  @override
  _AutoTundideValimineState createState() =>
      _AutoTundideValimineState(
          lulitusMap: lulitusMap, updateLulitusMap: updateLulitusMap);
}

int koduindex = 1;

 Color valge = Colors.white;
Color green = Colors.green;
class _AutoTundideValimineState
    extends State<AutoTundideValimine> {
  _AutoTundideValimineState(
      {Key? key, required this.lulitusMap, required this.updateLulitusMap});
  Function updateLulitusMap;
  var lulitusMap;
  int selectedRowIndex = -1;
  String selectedPage = 'Keskmine hind';
  double vahe = 10;
  int valitudTunnid = 12;
  Color boxColor = sinineKast;
   bool _notificationsEnabled = false;
  String _selectedTheme = 'Light';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body:ListView(
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
            title: Text('Theme'),
            trailing: DropdownButton<String>(
              value: _selectedTheme,
              onChanged: (String newValue) {
                setState(() {
                  _selectedTheme = newValue;
                });
              },
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
    );
    )
  }
}
