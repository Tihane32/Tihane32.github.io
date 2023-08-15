import 'package:flutter/material.dart';

import 'package:testuus4/lehed/Login.dart';
import 'package:testuus4/lehed/SeadmeGraafikLeht.dart';
import 'package:testuus4/lehed/abiLeht.dart';
import 'package:testuus4/lehed/drawer.dart';
import 'package:testuus4/lehed/kasutajaSeaded.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/lehed/rakenduseSeaded.dart';
import 'GraafikusseSeadmeteValik.dart';
import 'dynamicKoduLeht.dart';
import 'kaksTabelit.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:testuus4/funktsioonid/seisukord.dart';
import 'hindJoonise.dart';
import 'navigationBar.dart';
import 'package:testuus4/main.dart';

import 'package:get/get.dart';

class SeadmeteListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: SeadmeteList(),
    );
  }
}

class SeadmeteList extends StatefulWidget {
  const SeadmeteList({Key? key}) : super(key: key);

  @override
  State<SeadmeteList> createState() => _SeadmeteListState();
}

class _SeadmeteListState extends State<SeadmeteList> {
  late Map<String, List<String>> minuSeadmedK = {};
  String onoffNupp = 'Shelly ON';
  void initState() {
    super.initState();
    _submitForm();
  }

  int koduindex = 1;

  Map<String, List<String>> SeadmeteMap = {};
  Set<String> selectedPictures = Set<String>();

  void toggleSelection(String pictureName) {
    setState(() {
      if (selectedPictures.contains(pictureName)) {
        selectedPictures.remove(pictureName);
      } else {
        selectedPictures.add(pictureName);
      }
    });
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
          name: ['assets/boiler1.jpg', '$id', '$olek', '$pistik'],
        };
        minuSeadmedK.addAll(ajutineMap);
        i++;
      }
      print('seadmed');
      print(minuSeadmedK);
      print(SeadmeteMap);
    }
    setState(() {
      SeadmeteMap = minuSeadmedK;
      //isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backround,
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: SeadmeteMap.length + 1,
        itemBuilder: (context, index) {
          if (index == SeadmeteMap.length) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DynaamilenieKoduLeht(i: 2)));
              },
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.grey[300],
                child: Center(
                  child: Icon(
                    Icons.add,
                    size: 48,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          }

          final seade = SeadmeteMap.keys.elementAt(index);
          final pilt = SaaSeadmePilt(SeadmeteMap, seade);
          final staatus = SaaSeadmeolek(SeadmeteMap, seade);
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SeadmeGraafikuLeht(
                    seadmeNimi: SeadmeteMap.keys.elementAt(index),
                    SeadmeteMap: SeadmeteMap,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(1),
              child: Container(
                decoration: BoxDecoration(
                  border: border,
                ),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: staatus == 'on'
                          ? Colors.green
                          : staatus == 'off'
                              ? Colors.red
                              : Colors.grey,
                      width: 8,
                    ),
                  ),
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: ClipRRect(
                          child: Image.asset(
                            pilt,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            iconSize: 60,
                            icon: Icon(Icons.power_settings_new),
                            color: Colors.white,
                            onPressed: () {
                              setState(() {
                                SeadmeteMap =
                                    muudaSeadmeOlek(SeadmeteMap, seade);
                              });
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Visibility(
                          visible: staatus == 'Offline',
                          child: Container(
                            child: Icon(
                              Icons.wifi_off_outlined,
                              size: 60,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Colors.blue.withOpacity(0.6),
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Center(
                            child: Text(
                              seade,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

SaaSeadmePilt(Map<String, List<String>> SeadmeteMap, SeadmeNimi) {
  List<String>? deviceInfo = SeadmeteMap[SeadmeNimi];
  if (deviceInfo != null) {
    String pilt = deviceInfo[0];
    return pilt;
  }
  return null; // Device key not found in the map
}

SaaSeadmeolek(Map<String, List<String>> SeadmeteMap, SeadmeNimi) {
  List<String>? deviceInfo = SeadmeteMap[SeadmeNimi];
  if (deviceInfo != null) {
    String olek = deviceInfo[2];
    return olek;
  }
  return null; // Device key not found in the map
}

muudaSeadmeOlek(Map<String, List<String>> SeadmeteMap, SeadmeNimi) {
  List<String>? deviceInfo = SeadmeteMap[SeadmeNimi];
  if (deviceInfo != null) {
    String status = deviceInfo[2];

    if (status == 'on') {
      deviceInfo[2] = 'off';
      SeadmeteMap[SeadmeNimi] = deviceInfo;
    } else if (status == 'off') {
      deviceInfo[2] = 'on';
      SeadmeteMap[SeadmeNimi] = deviceInfo;
    }
    return SeadmeteMap;
  }
  return SeadmeteMap; // Device key not found in the map
}
