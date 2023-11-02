import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
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
  int valitudTunnid = 10;
  double hinnapiir = 50.50;
  Color boxColor = sinineKast;
  bool _notificationsEnabled = false;
  String _selectedTheme = 'Odavaimad Tunnid';
  late bool seadista;
  late double maxTunnid;

  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    seadista = graafikuSeaded['Seadistus_lubatud'];
    maxTunnid = graafikuSeaded['Max_jarjest_valjas'];
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
                    graafikuSeaded['Seadistus_lubatud'] = seadista;
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
                    graafikuSeaded['Max_jarjest_valjas'] = maxTunnid;
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
