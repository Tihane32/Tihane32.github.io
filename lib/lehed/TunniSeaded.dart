import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import 'DynaamilineTundideValimine.dart';
import 'package:intl/intl.dart';

class TunniSeaded extends StatefulWidget {
  final Function updateValitudSeadmed;
  TunniSeaded(
      {Key? key, this.valitudSeadmed, required this.updateValitudSeadmed})
      : super(key: key);
  final valitudSeadmed;
  @override
  _TunniSeadedState createState() => _TunniSeadedState(
      valitudSeadmed: valitudSeadmed,
      updateValitudSeadmed: updateValitudSeadmed);
}

class _TunniSeadedState extends State<TunniSeaded> {
  _TunniSeadedState(
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
  double hinnapiir = 50.50;
  Color boxColor = sinineKast;
  bool _notificationsEnabled = false;
  String _selectedTheme = 'Odavaimad Tunnid';
  double maxtunnid = 7;
  Map<int, int> tunniMap = {
    1: 2,
    2: 3,
    3: 4,
    4: 5,
    5: 6,
    6: 7,
    7: 8,
    8: 9,
    9: 10,
    10: 11,
    11: 12
  };
  double bufferPerjood = 3;

  TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                'Saada teavitus kui seade ei ole kättesaadav',
                style: font,
              ),
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
                                luba: 'jah')),
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
                                luba: 'ei')),
                      );
                    },
                    icon: Icon(
                      Icons.more_time_rounded,
                      color: Colors.red,
                      size: 30,
                    ))),
            ListTile(
              title: Text(
                'Maksimum järjest väljas: ${tunniMap[maxtunnid]} tundi',
                style: font,
              ),
              subtitle: Slider(
                value: maxtunnid,
                onChanged: (newValue) {
                  setState(() {
                    maxtunnid = newValue;
                  });
                },
                divisions: 10,
                min: 1,
                max: 11,
                label: tunniMap[maxtunnid].toString() + 'tundi',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
