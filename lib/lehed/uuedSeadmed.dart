import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testuus4/funktsioonid/seisukord.dart';
import 'package:testuus4/lehed/dynamicKoduLeht.dart';
import 'package:testuus4/lehed/koduleht.dart';
import 'package:testuus4/Arhiiv/seadmedKontoltNim.dart';
import 'package:testuus4/main.dart';
import 'package:flutter/material.dart';
import 'package:testuus4/funktsioonid/KeskmineHind.dart';
import 'package:testuus4/lehed/Login.dart';
import 'package:testuus4/lehed/abiLeht.dart';
import 'package:testuus4/lehed/drawer.dart';
import 'package:testuus4/lehed/uuedSeadmed.dart';
import 'package:testuus4/lehed/lisaSeade.dart';
import 'package:testuus4/lehed/rakenduseSeaded.dart';
import '../Arhiiv/kaksTabelit.dart';
import '../Arhiiv/hinnaGraafik.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testuus4/funktsioonid/hetketarbimine.dart';
import 'package:testuus4/funktsioonid/tarbimine.dart';
import 'package:testuus4/funktsioonid/maksumus.dart';
import 'hindJoonise.dart';
import '../funktsioonid/hetke_hind.dart';
import 'package:testuus4/main.dart';
import 'minuPakett.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Arhiiv/navigationBar.dart';
import 'dart:convert';

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
  int i = 0;
  int j = 0;
  for (j = 0; j < uuedSeadmedString.length; j++) {
    if (checkboxValues[i] == false) {
      uuedSeadmedString.remove(i);

// Re-index the remaining entries
      Map<int, Map<String, dynamic>> reindexedMap = {};
      int newIndex = 0;

      uuedSeadmedString.forEach((key, value) {
        final newKey = newIndex;
        reindexedMap[newKey] = value;
        newIndex++;
      });

// Update the original map with the reindexed map
      uuedSeadmedString = reindexedMap;
    }
    i++;
  }
  print("optsi $uuedSeadmedString");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var seadmedJSON = prefs.getString('seadmed');
  if (seadmedJSON != null) {
    Map<String, dynamic> seadmed = json.decode(seadmedJSON);
    num pikkus = seadmed.length + uuedSeadmedString.length;

    final reindexedMap = <String, dynamic>{};
    i = 0;
    for (var k = seadmed.length; k < pikkus; k++) {
      int newIndex = k;
      seadmed['Seade$k'] = uuedSeadmedString['Seade$i'];

      i++;
    }
    seadmeteMap = seadmed;
    String seadmedMap = json.encode(seadmed);
    await prefs.setString('seadmed', seadmedMap);
    await seisukord();
  } else {
    Map<String, dynamic> convertedMap = {};

    for (var innerMap in uuedSeadmedString.values) {
      convertedMap.addAll(innerMap);
    }
    seadmeteMap = convertedMap;
    String seadmedMap = json.encode(convertedMap);
    await prefs.setString('seadmed', seadmedMap);
    await seisukord();
  }
}
