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
  print("optsi $uuedSeadmedString");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var seadmedJSON = prefs.getString('seadmed');
  Map<String, Map<String, dynamic>> confShelly = {};
  confShelly = await saaShellyConf();
  print(
      'siin...............................................................................');
  if (seadmedJSON != null) {
    for (var innerMap in uuedSeadmedString.values) {
      if (innerMap['Seadme_cat'] == 'relay') {
        seadmeteMap.addAll(innerMap);
      } else {
        if (confShelly[innerMap['Seadme_tuup']]!['temperature'] == true) {
          anduriteMap['Temp_andurid'].addAll(innerMap);
        }
        if (confShelly[innerMap['Seadme_tuup']]!['moisture'] == true) {
          anduriteMap['Niiskus_andurid'].addAll(innerMap);
        }
        if (confShelly[innerMap['Seadme_tuup']]!['ligth'] == true) {
          anduriteMap['Valgus_andurid'].addAll(innerMap);
        }
      }
    }

    String seadmedMap = json.encode(seadmeteMap);
    await prefs.setString('seadmed', seadmedMap);
    await getToken3();
    await seisukord();
  } else {
    Map<String, dynamic> convertedMap = {};

    for (var innerMap in uuedSeadmedString.values) {
      if (innerMap['Seadme_cat'] == 'relay') {
        convertedMap.addAll(innerMap);
      }
    }
    seadmeteMap = convertedMap;
    String seadmedMap = json.encode(convertedMap);
    await prefs.setString('seadmed', seadmedMap);
    await getToken3();
    await seisukord();
  }
  print("---------------------");
  print(seadmeteMap);
  print("---------------------");
  //kirjutamegruppimappi koik seadmed
  SalvestaUusGrupp('Kõik Seadmed', {}, '', '', '');
}

/*{
  "isok": true,
  "data": {
    "devices": {
      "80646f80f713": {
        "id": "80646f80f713",
        "type": "SHPLG-S",
        "category": "relay",======================================================================================
        "position": 0,
        "gen": 1,
        "channel": 0,
        "channels_count": 1,
        "mode": "relay",
        "name": "Trevori plug",
        "room_id": 1,
        "image": "images/device_images/SHPLG-S.png",
        "exclude_event_log": false,
        "modified": 1697798471,
        "ip": "172.22.22.229",
        "ssid": "MisVahid?",
        "no_room_cons": false,
        "no_account_cons": false
      },
      "7086c9": {
        "id": "7086c9",
        "type": "SHHT-1",============================================================================================
        "category": "sensor",
        "position": 1,
        "gen": 1,
        "channel": 0,
        "channels_count": 1,
        "mode": "",
        "name": "Temperatuur",
        "room_id": 1,
        "image": "images/device_images/SHHT-1.png",
        "exclude_event_log": false,
        "modified": 1698244105,
        "ip": "172.22.22.203",
        "ssid": "iPhone (5)"
      }
    },
    "rooms": {
      "1": {
        "name": "Selleri",
        "image": "images/room_def/bedroom_img_def_m.jpg",
        "position": 1,
        "overview_style": false,
        "floor": 1,
        "id": 1,
        "modified": 1695376539
      }
    },
    "groups": {},
    "dashboards": {}
  }
}
*/
