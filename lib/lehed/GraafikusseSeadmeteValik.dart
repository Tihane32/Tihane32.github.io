import 'package:flutter/material.dart';
import 'package:testuus4/lehed/Login.dart';
import 'package:testuus4/lehed/SeadmeGraafikLeht.dart';
import 'package:testuus4/lehed/abiLeht.dart';
import 'package:testuus4/lehed/drawer.dart';
import 'package:testuus4/lehed/kasutajaSeaded.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testuus4/lehed/keskimiseHinnaAluselTundideValimine.dart';
import 'package:testuus4/lehed/seadmeteList.dart';
import 'navigationBar.dart';
import 'package:testuus4/main.dart';

class SeadmeteValmisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SeadmeteListValimine(),
    );
  }
}

class SeadmeteListValimine extends StatefulWidget {
  const SeadmeteListValimine({Key? key}) : super(key: key);

  @override
  State<SeadmeteListValimine> createState() => _SeadmeteListValimineState();
}

class _SeadmeteListValimineState extends State<SeadmeteListValimine> {
  String onoffNupp = 'Shelly ON';

  int koduindex = 1;

  Map<String, bool> ValitudSeadmed = {};
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

  void initState() {
    super.initState();
    ValitudSeadmed = valitudSeadmeteNullimine(SeadmeteMap);
  }

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
          crossAxisCount: 1,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 5),
        ),
        itemCount: SeadmeteMap.length,
        itemBuilder: (context, index) {
          final seade = SeadmeteMap.keys.elementAt(index);
          final pilt = SaaSeadmePilt(SeadmeteMap, seade);
          final staatus = SaaSeadmeolek(SeadmeteMap, seade);
          return GestureDetector(
            onTap: () {
              setState(() {
                if (ValitudSeadmed[seade] == false) {
                  ValitudSeadmed[seade] = true;
                } else {
                  ValitudSeadmed[seade] = false;
                }
              });
              print(ValitudSeadmed[seade]);
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: ValitudSeadmed[seade] == true
                      ? Colors.green
                      : Colors.grey,
                  width: 8,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        child: Image.asset(
                          pilt,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 8,
                    child: Visibility(
                      visible: staatus == 'off',
                      child: IconButton(
                        iconSize: 60,
                        icon: Icon(
                          Icons.warning_amber_rounded,
                          size: 80,
                          color: Colors.amber,
                        ),
                        color: Colors.blue,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text("  Seadmel graafik puudub"),
                                  ));
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
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color.fromARGB(255, 115, 162, 195),
          fixedColor: Color.fromARGB(255, 157, 214, 171),
          unselectedItemColor: Colors.white,
          selectedIconTheme: IconThemeData(size: 40),
          unselectedIconTheme: IconThemeData(size: 30),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: 'Tühista',
              icon: Icon(Icons.arrow_back),
            ),
            BottomNavigationBarItem(
              label: 'Tundide Valimine',
              icon: Icon(Icons.arrow_forward),
            ),
          ],
          currentIndex: koduindex,
          onTap: (int kodu) {
            setState(() {
              koduindex = kodu;
              if (koduindex == 0) {
                Navigator.push(
                  //Kui vajutatakse Hinnagraafiku ikooni peale, siis viiakse Hinnagraafiku lehele
                  context,
                  MaterialPageRoute(builder: (context) => const SeadmeteList()),
                );
              } else if (koduindex == 1) {
                Navigator.push(
                  //Kui vajutatakse Teie seade ikooni peale, siis viiakse Seadmetelisamine lehele
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const KeskmiseHinnaAluselTundideValimine()),
                );
              }
            });
          }),
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

Map<String, bool> valitudSeadmeteNullimine(
    Map<String, List<String>> SeadmeteMap) {
  Map<String, bool> ValitudSeadmed = {};
  for (String seade in SeadmeteMap.keys) {
    ValitudSeadmed[seade] = false;
  }
  print('ValitudSeadmed :');
  print(ValitudSeadmed);
  return ValitudSeadmed;
}
