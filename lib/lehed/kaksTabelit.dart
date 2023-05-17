import 'package:flutter/material.dart';
import 'package:testuus4/funktsioonid/lulitamine.dart';
import 'hinnaGraafik.dart';
import 'Login.dart';
import 'koduleht.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'seadmeSeaded.dart';
import 'package:testuus4/funktsioonid/seisukord.dart';
import 'SeadmeSeadedManuaalsed.dart';

class MinuSeadmed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SeadmeTabel(),
    );
  }
}

class SeadmeTabel extends StatefulWidget {
  const SeadmeTabel({Key? key}) : super(key: key);

  @override
  _SeadmeTabelState createState() => _SeadmeTabelState();
}

int koduindex = 0;

class _SeadmeTabelState extends State<SeadmeTabel> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Scaffold(
        //backgroundColor: Color.fromARGB(255, 189, 216, 225), //Taustavärv
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 115, 162, 195),
          title: const Text('Shelly pistik'),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginApp()),
                );
              },
              child: const Text('Log in'),
            ),
          ],
        ),

        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 235, 206, 120),
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(style: BorderStyle.solid, width: 1.0),
                ),
                child: Text(
                  '  Kontolt lisatud Seadmed:  ',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Expanded(
              child: KontoSeadmed(onTap1: (rowData) {
                print('Tapped row with data: $rowData');
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginApp()),
                    );
                  },
                ),
                const DecoratedBox(
                  decoration: const BoxDecoration(color: Colors.cyan),
                  child: Text(
                    'Manuaalselt lisatud Seadmed:',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ManuaalsedSeadmed(onTap: (rowData) {
                print('Tapped row with data: $rowData');
              }),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Color.fromARGB(255, 115, 162, 195),
            fixedColor: Color.fromARGB(255, 77, 245, 170),
            unselectedItemColor: Colors.black,
            selectedIconTheme: IconThemeData(size: 30),
            unselectedIconTheme: IconThemeData(size: 22),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                label: 'Seadmed',
                icon: Icon(Icons.electrical_services_rounded),
              ),
              BottomNavigationBarItem(
                label: 'Kodu',
                icon: Icon(Icons.home),
              ),
              BottomNavigationBarItem(
                label: 'Hinnagraafik',
                icon: Icon(Icons.table_rows_outlined),
              ),
            ],
            currentIndex: koduindex,
            onTap: (int kodu) {
              setState(() {
                koduindex = kodu;

                if (koduindex == 2) {
                  Navigator.push(
                    //Kui vajutatakse Hinnagraafiku ikooni peale, siis viiakse Hinnagraafiku lehele

                    context,

                    MaterialPageRoute(builder: (context) => HinnaGraafik()),
                  );
                } else if (koduindex == 1) {
                  Navigator.push(
                    //Kui vajutatakse Teie seade ikooni peale, siis viiakse Seadmetelisamine lehele

                    context,

                    MaterialPageRoute(builder: (context) => const KoduLeht()),
                  );
                }
              });
            }),
      ),
    );
  }
}

class ManuaalsedSeadmed extends StatelessWidget {
  ManuaalsedSeadmed({Key? key, required this.onTap}) : super(key: key);

  final Function(List<String>) onTap;

  final Map<String, List<String>> minuSeadmedM = {
    '123': ['123', 'Boiler 55', 'Shelly plug S'],
    '456': ['456', 'Kulmik 1', 'Shelly plug'],
    '789': ['789', 'Kulmik 2', 'Shelly plug S'],
    '7': ['789', 'Kulmik 2', 'Shelly plug S'],
    '78': ['789', 'Kulmik 2', 'Shelly plug S'],
    '79': ['789', 'Kulmik 2', 'Shelly plug S'],
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: DataTable(
        showCheckboxColumn: false,
        columns: const <DataColumn>[
          DataColumn(
            label: Text(
              'ID',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              'Nimi',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              'Pistik',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ],
        rows: minuSeadmedM.entries
            .map(
              (e) => DataRow(
                cells: [
                  DataCell(Text(e.value[0])),
                  DataCell(Text(e.value[1])),
                  DataCell(Text(e.value[2])),
                ],
                onSelectChanged: (isSelected) {
                  if (isSelected != null && isSelected) {
                    onTap(e.value);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SeadmeSeadedManuaalsed(
                                value: e.value[0],
                              )),
                    );
                  }
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

class KontoSeadmed extends StatefulWidget {
  KontoSeadmed({Key? key, required this.onTap1}) : super(key: key);

  final Function(List<String>) onTap1;
  @override
  _KontoSeadmedState createState() => _KontoSeadmedState();
}

class _KontoSeadmedState extends State<KontoSeadmed> {
  late Map<String, List<String>> minuSeadmedK = {};
  bool isLoading = true;
  void initState() {
    super.initState();
    _submitForm();
  }

  Future _submitForm() async {
    minuSeadmedK.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedJsonMap = prefs.getString('seadmed');
    if (storedJsonMap != null) {
      Map<String, dynamic> storedMap = json.decode(storedJsonMap);
      await Future.delayed(const Duration(seconds: 3));
      var i = 0;
      for (String Seade in storedMap.keys) {
        seisukord();
        var id = storedMap['Seade$i']['Seadme_ID'];
        var name = storedMap['Seade$i']['Seadme_nimi'];
        var pistik = storedMap['Seade$i']['Seadme_pistik'];
        var olek = storedMap['Seade$i']['Seadme_olek'];
        print('olek: $olek');
        Map<String, List<String>> ajutineMap = {
          Seade: ['$id', '$name', '$pistik', '$olek'],
        };
        minuSeadmedK.addAll(ajutineMap);
        i++;
      }
      print(minuSeadmedK);
    }
    setState(() {
      minuSeadmedK = minuSeadmedK;
      isLoading = false;
    });
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: DataTable(
                showCheckboxColumn: false,
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      'Nimi',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Pistik',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Olek',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
                rows: minuSeadmedK.entries
                    .map(
                      (e) => DataRow(
                        cells: [
                          DataCell(Text(e.value[1])),
                          DataCell(Text(e.value[2])),
                          DataCell(
                            IgnorePointer(
                              ignoring:
                                  e.value[3] != "on" && e.value[3] != "off",
                              child: Container(
                                decoration: e.value[3] != "Offline"
                                    ? BoxDecoration(
                                        //border: Border.all(width: 2, color: Colors.black)
                                        //boxShadow: [
                                        //BoxShadow(
                                        //color: Colors.grey.withOpacity(1),
                                        //spreadRadius: -2,
                                        //blurRadius: 0,
                                        //offset: Offset(0, 3),
                                        //blurStyle: BlurStyle.solid // changes position of shadow
                                        //),
                                        //],
                                        )
                                    : null,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: e.value[3] == "Offline"
                                        ? Colors.blue[0]
                                        : Colors.blue[100],
                                  ),
                                  onPressed: () {
                                    lulitamine(e.value[0]);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MinuSeadmed(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    e.value[3],
                                    style: TextStyle(
                                      color: e.value[3] == "on"
                                          ? Color.fromARGB(255, 38, 152, 41)
                                          : e.value[3] == "off"
                                              ? Colors.red
                                              : Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                        onSelectChanged: (isSelected) {
                          if (isSelected != null && isSelected) {
                            onTap(e.value);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SeadmeSeaded(
                                  value: e.value[0],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
    );
  }

  void onTap(List<String> value) {}
}
