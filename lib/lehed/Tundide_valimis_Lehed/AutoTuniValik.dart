import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../main.dart';
import '../../parameters.dart';
import 'DynaamilineTundideValimine.dart';
import 'package:intl/intl.dart';

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
  double hinnapiir = 50.50;
  Color boxColor = sinineKast;
  bool _notificationsEnabled = false;
  String _selectedTheme = 'Odavaimad Tunnid';
  double tootamisAeg = 7;
  Map<double, String> tootamisMap = {
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
                  'Häälestuse seaded:',
                  style: font,
                ),
                trailing: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DynamilineTundideValimine(
                                  valitudSeadmed: valitudSeadmed,
                                  i: 5,
                                  luba: '',
                                  eelmineleht: 3,
                                )),
                      );
                    },
                    icon: Icon(
                      Icons.settings,
                      color: Colors.black,
                      size: 30.0,
                    ))),
            ListTile(
              title: Text(
                'Automaatjuhtimise kestus: ${tootamisMap[tootamisAeg]}',
                style: font,
              ),
              subtitle: Slider(
                value: tootamisAeg,
                onChanged: (newValue) {
                  setState(() {
                    tootamisAeg = newValue;
                  });
                },
                divisions: 13,
                min: 1,
                max: 14,
                label: tootamisMap[tootamisAeg],
              ),
            ),
            ListTile(
              title: Text(
                'Lülitusgraafiku koostamis algoritm',
                style: font,
              ),
              trailing: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: boxColor,
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    style: font,
                    dropdownColor: sinineKast,
                    borderRadius: borderRadius,
                    value: _selectedTheme,
                    onChanged: (lylitusViis) {
                      setState(() {
                        _selectedTheme = lylitusViis!;
                      });
                    },
                    items: <String>[
                      'Odavaimad Tunnid',
                      'Hinnapiir',
                      'Tarbimis muster',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _selectedTheme == 'Odavaimad Tunnid',
              child: ListTile(
                title: Text(
                  'Soovitud tundide arv',
                  style: font,
                ),
                trailing: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Center(
                    // Center the TextField vertically in the increased-height Container
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onSubmitted: (value) {
                        setState(() {
                          int parsedValue = int.tryParse(value) ?? 0;
                          if (parsedValue > 24) {
                            parsedValue = 24;
                          }
                          valitudTunnid = parsedValue;
                        });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        hintText: valitudTunnid.toString(),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 8.0),
                      ),
                      style: font,
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _selectedTheme == 'Hinnapiir',
              child: ListTile(
                title: Text(
                  'hinnapiir',
                  style: font,
                ),
                trailing: Container(
                  width: 60,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Center(
                    // Center the TextField vertically in the increased-height Container
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onSubmitted: (value) {
                        setState(() {
                          double parsedValue = double.tryParse(value) ?? 0;
                          if (parsedValue > 24) {
                            parsedValue = 24;
                          }
                          hinnapiir = parsedValue;
                        });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        hintText: hinnapiir.toString(),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 8.0),
                      ),
                      style: font,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
