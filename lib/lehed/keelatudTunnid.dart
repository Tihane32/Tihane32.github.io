import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/lehed/GraafikusseSeadmeteValik.dart';
import 'package:testuus4/lehed/P%C3%B5hi_Lehed/dynamicKoduLeht.dart';
import 'package:testuus4/lehed/Tundide_valimis_Lehed/keskimiseHinnaAluselTundideValimine.dart';
import '../funktsioonid/seisukord.dart';
import '../main.dart';
import '../widgets/AbiLeht.dart';
import 'Tundide_valimis_Lehed/hinnaPiiriAluselTunideValimine.dart';
import 'package:http/http.dart' as http;

class KeelatudTunnid extends StatefulWidget {
  KeelatudTunnid({
    Key? key,
    this.valitudSeadmed,
    required this.luba,
  }) : super(key: key);
  String luba;
  final valitudSeadmed;
  @override
  _KeelatudTunnidState createState() => _KeelatudTunnidState(
        valitudSeadmed: valitudSeadmed,
        luba: luba,
      );
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
  List aktiivTunnid = [];
  Color valitudvarv = Colors.red;
  String valitudSuund = 'Lubatud';
  List valjasTunnid = [];
  List seesTunnid = [];

  @override
  void initState() {
    super.initState();
    seesTunnid = graafikuSeaded['Kelleatud_tunnid'];
    valjasTunnid = graafikuSeaded['Lubatud_tunnid'];

    if (luba == 'ei') {
      valitudvarv = Colors.red;
      valitudSuund = 'Keelatud';
      aktiivTunnid = valjasTunnid;
    } else {
      valitudvarv = Colors.green;
      valitudSuund = 'Lubatud';
      aktiivTunnid = seesTunnid;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: 40,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$valitudSuund tundide valimine',
              style: font,
            ),
          ],
        ),
      ),
      body: ListView.separated(
        separatorBuilder: (BuildContext context, int index) => const Divider(
          color: Colors.transparent,
        ),
        padding: const EdgeInsets.all(8),
        itemCount: 24,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Align(alignment: Alignment.center, child: Text('$index:00')),
            tileColor: aktiivTunnid.contains(index)
                ? valitudvarv
                : Color.fromARGB(255, 218, 207, 207),
            onTap: () {
              setState(() {
                if (aktiivTunnid.contains(index)) {
                  aktiivTunnid.remove(index);
                } else {
                  aktiivTunnid.add(index);
                }
                if (luba == 'ei') {
                  graafikuSeaded['Kelleatud_tunnid'] = aktiivTunnid;
                } else {
                  graafikuSeaded['Lubatud_tunnid'] = aktiivTunnid;
                }
              });
            },
          );
        },
      ),
    );
  }
}
