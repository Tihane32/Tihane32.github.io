import 'package:flutter/material.dart';

import 'package:testuus4/lehed/Login.dart';
import 'package:testuus4/lehed/SeadmeGraafikLeht.dart';
import 'package:testuus4/lehed/abiLeht.dart';
import 'package:testuus4/lehed/drawer.dart';
import 'package:testuus4/lehed/kasutajaSeaded.dart';

import 'package:testuus4/lehed/rakenduseSeaded.dart';
import 'GraafikusseSeadmeteValik.dart';
import 'kaksTabelit.dart';

import 'package:google_fonts/google_fonts.dart';

import 'hindJoonise.dart';
import 'navigationBar.dart';
import 'package:testuus4/main.dart';

class SeadmeteListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  String onoffNupp = 'Shelly ON';

  int koduindex = 1;

  Map<String, List<String>> SeadmeteMap = {
    'Keldri boiler': [
      'assets/boiler1.jpg',
      '123456',
      'off',
      'Shelly plug S',
    ],
    'Veranda lamp': [
      'assets/verandaLamp1.png',
      '123456',
      'offline',
      'Shelly plug S',
    ],
    'veranda lamp': [
      'assets/verandaLamp1.png',
      '123456',
      'on',
      'Shelly plug S',
    ],
    'Keldri pump': [
      'assets/pump1.jpg',
      '123456',
      'on',
      'Shelly plug S',
    ],
    'Garaazi pump': [
      'assets/pump1.jpg',
      '123456',
      'offline',
      'Shelly plug S',
    ],
    'Main boiler': [
      'assets/boiler1.jpg',
      '123456',
      'on',
      'Shelly plug S',
    ],
    'Sauna boiler': [
      'assets/boiler1.jpg',
      '123456',
      'off',
      'Shelly plug S',
    ],
  };
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backround,
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: SeadmeteMap.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SeadmeteListValimine(),
                    ),
                  );
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

            final seade = SeadmeteMap.keys.elementAt(index - 1);
            final pilt = SaaSeadmePilt(SeadmeteMap, seade);
            final staatus = SaaSeadmeolek(SeadmeteMap, seade);
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SeadmeGraafikuLeht(
                      seadmeNimi: SeadmeteMap.keys.elementAt(index - 1),
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
                                  SeadmeteMap = muudaSeadmeOlek(SeadmeteMap, seade);
                                });
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Visibility(
                            visible: staatus == 'offline',
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
            height: navBarHeight,
            child: AppNavigationBar(i: 0),
          ),
        ));
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
