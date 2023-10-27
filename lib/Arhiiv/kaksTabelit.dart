import 'package:flutter/material.dart';
import 'package:testuus4/funktsioonid/lulitamine.dart';
import 'package:testuus4/lehed/hindJoonise.dart';
import '../lehed/Login.dart';
import '../lehed/koduleht.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../lehed/seadmeSeaded.dart';
import 'package:testuus4/funktsioonid/seisukord.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:testuus4/main.dart';
import '../lehed/kasutajaSeaded.dart';
import '../lehed/rakenduseSeaded.dart';
import '../lehed/AbiLeht.dart';
import 'drawer.dart';
import 'navigationBar.dart';

class MinuSeadmed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
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
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 208, 236, 239),
          //backgroundColor: Color.fromARGB(255, 189, 216, 225), //Taustavärv
          appBar: AppBar(
            backgroundColor: appbar,
            title: Text(
              'Shelly App',
              style: GoogleFonts.roboto(
                textStyle: const TextStyle(fontSize: 25),
              ),
            ),
            actions: [
              Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    padding: EdgeInsets.only(right: 20),
                    icon: Icon(
                      Icons.menu,
                      size: 30,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                  );
                },
              ),
            ],
          ),
          endDrawer: drawer(),
          body: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
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
                  /*IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginApp()),
                    );
                  },
                ),*/
                  /*const DecoratedBox(
                  decoration: const BoxDecoration(color: Colors.cyan),
                  child: Text(
                    'Manuaalselt lisatud Seadmed:',
                    style: TextStyle(fontSize: 20),
                  ),
                ),*/
                ],
              ),
              /*Expanded(
              child: ManuaalsedSeadmed(onTap: (rowData) {
                print('Tapped row with data: $rowData');
              }),
            ),*/
            ],
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
            ),
            child: SizedBox(
              height: 72,
              child: AppNavigationBar(i: 0),
            ),
          )),
    );
  }
}

/*
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
*/
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
    //await prefs.clear();
    String? storedJsonMap = prefs.getString('seadmed');
    print(storedJsonMap);
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
          ? const Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: CircularProgressIndicator(),
              ),
            )
          : Center(
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerColor:
                      Colors.black, // Set your desired divider color here
                ),
                child: Container(
                  width: MediaQuery.of(context)
                      .size
                      .width, // Take full available width
                  child: DataTable(
                    columnSpacing: 10,
                    //columnSpacing: (MediaQuery.of(context).size.width)/3 ,
                    dividerThickness: 1.0,
                    showCheckboxColumn: false,
                    columns: <DataColumn>[
                      DataColumn(
                        label: Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 226, 116, 73),
                              borderRadius: BorderRadius.circular(14.0),
                              border: Border.all(
                                color: const Color.fromARGB(30, 0, 0, 0),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(3, 3),
                                ),
                              ],
                            ),
                            height: 25,
                            child: Text(
                              'Nimi',
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      /*DataColumn(
                        label: Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 226, 116, 73),
                              borderRadius: BorderRadius.circular(14.0),
                              border: Border.all(
                                color: const Color.fromARGB(30, 0, 0, 0),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(3, 3),
                                ),
                              ],
                            ),
                            height: 25,
                            child: Text(
                              'Mudel',
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),*/
                      DataColumn(
                        label: Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 226, 116, 73),
                              borderRadius: BorderRadius.circular(14.0),
                              border: Border.all(
                                color: const Color.fromARGB(30, 0, 0, 0),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(3, 3),
                                ),
                              ],
                            ),
                            height: 25,
                            child: Text(
                              'Olek',
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    rows: minuSeadmedK.entries
                        .map(
                          (e) => DataRow(
                            cells: [
                              DataCell(
                                Container(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 35,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 237, 202, 146),
                                      borderRadius: BorderRadius.circular(14.0),
                                      border: Border.all(
                                        color:
                                            const Color.fromARGB(30, 0, 0, 0),
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(3, 3),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      ' ${e.value[1]} ',
                                      style: GoogleFonts.openSans(
                                        textStyle: const TextStyle(
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              /*DataCell(
                                Container(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 35,
                                    width: 115,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 237, 202, 146),
                                      borderRadius: BorderRadius.circular(14.0),
                                      border: Border.all(
                                        color:
                                            const Color.fromARGB(30, 0, 0, 0),
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(3, 3),
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      child: Text(
                                        ' ${e.value[2]} ',
                                        style: GoogleFonts.openSans(
                                          textStyle: const TextStyle(
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),*/
                              DataCell(
                                IgnorePointer(
                                  ignoring:
                                      e.value[3] != "on" && e.value[3] != "off",
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Visibility(
                                      visible: e.value[3] != "Offline",
                                      child: CupertinoSwitch(
                                        value: e.value[3] == "on",
                                        onChanged: (newValue) {
                                          lulitamine(e.value[0]);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MinuSeadmed(),
                                            ),
                                          );
                                        },
                                        activeColor: const Color.fromARGB(
                                            255, 53, 166, 81),
                                        trackColor: const Color.fromARGB(
                                            255, 164, 156, 155),
                                      ),
                                      replacement: const Text(
                                        'Offline',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Color.fromARGB(
                                              255, 124, 121, 121),
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
              ),
            ),
    );
  }

  void onTap(List<String> value) {}
}
