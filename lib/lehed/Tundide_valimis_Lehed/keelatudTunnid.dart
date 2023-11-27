import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/lehed/Tundide_valimis_Lehed/Graafik_Seadmete_valik/DynaamilineGraafikusseSeadmeteValik.dart';
import 'package:testuus4/lehed/P%C3%B5hi_Lehed/dynamicKoduLeht.dart';
import 'package:testuus4/lehed/Tundide_valimis_Lehed/keskimiseHinnaAluselTundideValimine.dart';
import '../../funktsioonid/salvestaSeadistus.dart';
import '../../funktsioonid/seisukord.dart';
import '../../main.dart';
import '../../widgets/AbiLeht.dart';
import 'hinnaPiiriAluselTunideValimine.dart';
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

  @override
  void initState() {
    int trueCount = 0;
    String valitudSeade = '';

    for (var entry in valitudSeadmed.entries) {
      if (entry.value) {
        trueCount++;
        valitudSeade = entry.key;
      }
    }
    if (trueCount == 1) {
      if (luba == 'ei') {
        valitudvarv = Colors.red;
        valitudSuund = 'Keelatud';
        aktiivTunnid = seadmeteMap[valitudSeade]['Kelleatud_tunnid'];
      } else {
        valitudvarv = Colors.green;
        valitudSuund = 'Lubatud';
        aktiivTunnid = seadmeteMap[valitudSeade]['Lubatud_tunnid'];
      }
    }
    super.initState();
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
                saklvestaTunnid(luba, valitudSeadmed, aktiivTunnid);
              });
            },
          );
        },
      ),
    );
  }
}

saklvestaTunnid(
    String luba, Map<String, bool> valitudSeadmed, List aktiivTunnid) {
  String tunnid = '';
  if (luba == 'ei') {
    tunnid = 'Kelleatud_tunnid';
  } else {
    tunnid = 'Lubatud_tunnid';
  }
  aktiivTunnid.sort();
  salvestaSeadistus(tunnid, aktiivTunnid, valitudSeadmed);
}
