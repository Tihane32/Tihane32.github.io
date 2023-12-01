import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/funktsioonid/seisukord.dart';
import 'package:testuus4/funktsioonid/token.dart';
import 'package:testuus4/lehed/P%C3%B5hi_Lehed/dynamicKoduLeht.dart';
import 'package:testuus4/main.dart';
import '../funktsioonid/saaShellyConf.dart';
import '../funktsioonid/salvestaGrupp.dart';

class uuedSeadmed extends StatefulWidget {
  uuedSeadmed({required this.uuedSeadmedString});
  final Map<String, dynamic> uuedSeadmedString;

  @override
  _uuedSeadmedState createState() => _uuedSeadmedState();
}

class _uuedSeadmedState extends State<uuedSeadmed> {
  List<bool> checkboxValues = [];
  Map<int, Map<String, dynamic>> newMap = {};
  @override
  void initState() {
    super.initState();
    print(widget.uuedSeadmedString[0]);

    int index = 0;
    setState(() {
      widget.uuedSeadmedString.forEach((key, value) {
        newMap[index] = {key: value};
        index++;
      });
    });
    // Initialize the list of checkbox values with default values
    checkboxValues = List.generate(newMap.length, (index) => true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 115, 162, 195),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Seadmete lisamine',
              style: GoogleFonts.roboto(
                textStyle: const TextStyle(fontSize: 25),
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.uuedSeadmedString.length,
              itemBuilder: (context, index) {
                final seadmeInfo = newMap[index] ?? {};
                print(seadmeInfo); // Add null check
                var seadmeNimi;
                seadmeInfo.forEach((key, value) {
                  if (value is Map<String, dynamic> &&
                      value.containsKey('Seadme_nimi')) {
                    seadmeNimi = value['Seadme_nimi'];
                    return;
                  }
                });
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Transform.scale(
                            scale: 1.5,
                            child: Checkbox(
                              shape: CircleBorder(),
                              activeColor: Color.fromARGB(255, 69, 207, 44),
                              value: checkboxValues[index],
                              onChanged: (Newvalue) {
                                setState(() {
                                  if (Newvalue == false) {}
                                  checkboxValues[index] = Newvalue!;
                                  print(checkboxValues);
                                  print("new valueeeee");
                                });
                              },
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 150,
                                child: Text(
                                  seadmeNimi,
                                  style: fontSuur,
                                  //textAlign: TextAlign.start, // Change this to your desired font
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          GestureDetector(
            onTap: () async {
              await sort(checkboxValues, newMap);
              // Navigate to another page when the button is pressed
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DynaamilenieKoduLeht(i: 1)),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: sinineKast,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(
                      color: Color.fromARGB(41, 0, 0, 0),
                      width: 2,
                    )),
                width: 200,
                height: sinineKastKorgus,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(text: 'OK', style: fontSuur),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

Future<void> sort(List<bool> checkboxValues,
    Map<int, Map<String, dynamic>> uuedSeadmedString) async {
  int i = uuedSeadmedString.length;
  int j = 0;
  Map<int, Map<String, dynamic>> reindexedMap = {};
  for (j = 0; j < i; j++) {
    print("$j $checkboxValues");
    if (checkboxValues[j] == false) {
      print("this is false $j");
      print("uuedSeadmed $uuedSeadmedString");
      uuedSeadmedString.remove(j);

// Update the original map with the reindexed map
    }
  }
  uuedSeadmedString;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var seadmedJSON = prefs.getString('seadmed');
  Map<String, Map<String, dynamic>> confShelly = {};
  confShelly = await saaShellyConf();
  print('T: confShelly =$confShelly');
  print('T:uuedSeadmedString =$uuedSeadmedString');
  print('T:seadmedJSON =$seadmedJSON');
  if (seadmedJSON != null) {
    Map<String, dynamic> temperaMap = {};
    Map<String, dynamic> niiskusMap = {};
    Map<String, dynamic> valgusMap = {};
    //anduriteMap['Niiskus_andurid'] as Map<String, dynamic>;
    //anduriteMap['Valgus_andurid'] as Map<String, dynamic>;
    //temperaMap = anduriteMap['Temp_andurid'] as Map<String, dynamic>;

    for (var innerMap in uuedSeadmedString.values) {
      print('T: inermap = $innerMap');
      var keys = innerMap.keys.toList();
      var firstKey = keys[0];
      String cat = innerMap[firstKey]['Seadme_cat'];
      print('T: seadme cat = $cat');
      var tuupKey = innerMap[firstKey]['Seadme_tuup'];
      print('T: tuupKey>: $tuupKey');
      var values = innerMap.values;
      print('T: values: $values');
      if (cat == 'relay') {
        seadmeteMap.addAll(innerMap);
      }
      print(confShelly[tuupKey]!['temperature']);
      if (confShelly[tuupKey]!['temperature'] == 'true') {
        innerMap.forEach((key, value) {
          temperaMap[firstKey] = value;
        });
      }
      if (confShelly[tuupKey]!['moisture'] == 'true') {
        innerMap.forEach((key, value) {
          niiskusMap[firstKey] = value;
        });
      }
      if (confShelly[tuupKey]!['ligth'] == 'true') {
        innerMap.forEach((key, value) {
          valgusMap[firstKey] = value;
        });
      }
    }

    anduriteMap['Temp_andurid'] = temperaMap;
    anduriteMap['Niiskus_andurid'] = niiskusMap;
    anduriteMap['Valgus_andurid'] = valgusMap;

    String seadmedMap = json.encode(seadmeteMap);
    await prefs.setString('seadmed', seadmedMap);
    await getToken3();
    await seisukord();
  } else {
    Map<String, dynamic> convertedMap = {};
    Map<String, dynamic> temperaMap = {};
    Map<String, dynamic> niiskusMap = {};
    Map<String, dynamic> valgusMap = {};
    //anduriteMap['Niiskus_andurid'] as Map<String, dynamic>;
    //anduriteMap['Valgus_andurid'] as Map<String, dynamic>;
    //temperaMap = anduriteMap['Temp_andurid'] as Map<String, dynamic>;

    for (var innerMap in uuedSeadmedString.values) {
      print('T: inermap = $innerMap');
      var keys = innerMap.keys.toList();
      var firstKey = keys[0];
      String cat = innerMap[firstKey]['Seadme_cat'];
      print('T: seadme cat = $cat');
      var tuupKey = innerMap[firstKey]['Seadme_tuup'];
      print('T: tuupKey>: $tuupKey');
      var values = innerMap.values;
      print('T: values: $values');
      if (cat == 'relay') {
        convertedMap.addAll(innerMap);
      }
      print(confShelly[tuupKey]!['temperature']);
      if (confShelly[tuupKey]!['temperature'] == 'true') {
        innerMap.forEach((key, value) {
          temperaMap[firstKey] = value;
        });
      }
      if (confShelly[tuupKey]!['moisture'] == 'true') {
        innerMap.forEach((key, value) {
          niiskusMap[firstKey] = value;
        });
      }
      if (confShelly[tuupKey]!['ligth'] == 'true') {
        innerMap.forEach((key, value) {
          valgusMap[firstKey] = value;
        });
      }
    }
    anduriteMap['Temp_andurid'] = temperaMap;
    anduriteMap['Niiskus_andurid'] = niiskusMap;
    anduriteMap['Valgus_andurid'] = valgusMap;
    seadmeteMap = convertedMap;
    String seadmedMap = json.encode(convertedMap);
    await prefs.setString('seadmed', seadmedMap);
    await getToken3();
    await seisukord();
  }
  print("---------------------");
  print('Tprint: $seadmeteMap');
  print("---------------------");
  print('Tprint: $anduriteMap');
  print("---------------------");
  //kirjutamegruppimappi koik seadmed
  SalvestaUusGrupp('Kõik Seadmed', {}, '', '', '');
}
