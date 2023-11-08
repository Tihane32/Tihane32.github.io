import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../funktsioonid/salvestaSeadistus.dart';
import '../../main.dart';
import 'DynaamilineTundideValimine.dart';
import 'package:intl/intl.dart';

class TunniSeaded extends StatefulWidget {
  TunniSeaded({
    Key? key,
    this.valitudSeadmed,
  }) : super(key: key);
  final valitudSeadmed;
  @override
  _TunniSeadedState createState() => _TunniSeadedState(
        valitudSeadmed: valitudSeadmed,
      );
}

class _TunniSeadedState extends State<TunniSeaded> {
  _TunniSeadedState({
    Key? key,
    required this.valitudSeadmed,
  });
  var valitudSeadmed;
  int koduindex = 1;
  bool isLoading = true;
  String selectedPage = 'Kopeeri graafik';
  double vahe = 10;
  //int valitudTunnid = 10;
  //double hinnapiir = 50.50;
  Color boxColor = sinineKast;
  bool _notificationsEnabled = false;
  String _selectedTheme = 'Odavaimad Tunnid';
  bool seadista = false;
  double maxTunnid = 10;

  TextEditingController _textController = TextEditingController();

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
      seadista = seadmeteMap[valitudSeade]['Seadistus_lubatud'];
      maxTunnid = seadmeteMap[valitudSeade]['Max_jarjest_valjas'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                'Rakenda seaded graafikule',
                style: font,
              ),
              trailing: Switch(
                value: seadista,
                onChanged: (bool value) {
                  setState(() {
                    seadista = value;
                    salvestaSeadistus(
                        'Seadistus_lubatud', seadista, valitudSeadmed);
                  });
                },
              ),
            ),
            ListTile(
                title: Text(
                  'Tunnid kus seade peab töötama',
                  style: font,
                ),
                trailing: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DynamilineTundideValimine(
                                  valitudSeadmed: valitudSeadmed,
                                  i: 4,
                                  luba: 'jah',
                                  eelmineleht: 0,
                                )),
                      );
                    },
                    icon: Icon(
                      Icons.more_time_rounded,
                      color: Colors.green,
                      size: 30,
                    ))),
            ListTile(
                title: Text(
                  'Tunnid kus seade ei tohi töödata',
                  style: font,
                ),
                trailing: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DynamilineTundideValimine(
                                  valitudSeadmed: valitudSeadmed,
                                  i: 4,
                                  luba: 'ei',
                                  eelmineleht: 0,
                                )),
                      );
                    },
                    icon: Icon(
                      Icons.more_time_rounded,
                      color: Colors.red,
                      size: 30,
                    ))),
            ListTile(
              title: Text(
                'Maksimum järjest väljas: ${maxTunnid} tundi',
                style: font,
              ),
              subtitle: Slider(
                value: maxTunnid,
                onChanged: (newValue) {
                  setState(() {
                    maxTunnid = newValue;
                    salvestaSeadistus(
                        'Max_jarjest_valjas', maxTunnid, valitudSeadmed);
                  });
                },
                divisions: 11,
                min: 1,
                max: 12,
                label: maxTunnid.toString(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
