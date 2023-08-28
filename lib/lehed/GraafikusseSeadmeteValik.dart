import 'package:flutter/material.dart';
import 'package:testuus4/lehed/Login.dart';
import 'package:testuus4/lehed/SeadmeGraafikLeht.dart';
import 'package:testuus4/lehed/abiLeht.dart';
import 'package:testuus4/lehed/drawer.dart';
import 'package:testuus4/lehed/kasutajaSeaded.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testuus4/lehed/keskimiseHinnaAluselTundideValimine.dart';
import 'package:testuus4/lehed/seadmeteList.dart';
import 'dynamicKoduLeht.dart';
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
      'jah',
    ],
    'Veranda lamp': [
      'assets/verandaLamp1.png',
      '123456',
      'offline',
      'Shelly plug S',
      'ei',
    ],
    'Keldri pump': [
      'assets/pump1.jpg',
      '123456',
      'on',
      'Shelly plug S',
      'jah',
    ],
    'Garaazi pump': [
      'assets/pump1.jpg',
      '123456',
      'offline',
      'Shelly plug S',
      'jah',
    ],
    'Main boiler': [
      'assets/boiler1.jpg',
      '123456',
      'on',
      'Shelly plug S',
      'jah',
    ],
    'Sauna boiler': [
      'assets/boiler1.jpg',
      '123456',
      'off',
      'Shelly plug S',
      'ei',
    ],
  };

  void initState() {
    super.initState();
    ValitudSeadmed = valitudSeadmeteNullimine(SeadmeteMap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backround,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: appbar,
        title: Text(
          'Graafikuse seadmetevalimine',
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(fontSize: 25),
          ),
        ),
      ),
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
          final graafik = SaaSeadmegraafik(SeadmeteMap, seade);
          return GestureDetector(
            onTap: () {
              if (SeadmeteMap[seade]![2] != 'offline') {
                setState(() {
                  if (ValitudSeadmed[seade] == false) {
                    ValitudSeadmed[seade] = true;
                  } else {
                    ValitudSeadmed[seade] = false;
                  }
                });
                print(ValitudSeadmed[seade]);
              } else {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text(
                              "  Seadmel puudub võrgu ühendus, mistõttu ei ole teda võimalik graafikusse kaasata"),
                        ));
              }
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
                      color: ValitudSeadmed[seade] == true
                          ? Colors.green
                          : Colors.grey,
                      width: 8,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Container(
                          color: ValitudSeadmed[seade] == true
                              ? Color.fromARGB(255, 177, 245, 180)
                              : Color.fromARGB(255, 236, 228, 228)),
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
                        top: 8,
                        right: 8,
                        child: graafik == 'ei'
                            ? IconButton(
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
                                            title:
                                                Text("  $seade graafik puudub"),
                                          ));
                                },
                              )
                            : IconButton(
                                iconSize: 60,
                                icon: Icon(
                                  Icons.fact_check_outlined,
                                  size: 80,
                                  color: Colors.blue,
                                ),
                                color: Colors.blue,
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text(
                                                "  $seade graafik: \n \t 00.00 on \n \t 00.10 on \n \t 00.20 on \n \t 03.00 off \n \t ..."),
                                          ));
                                },
                              ),
                      ),
                      Positioned(
                        top: 25,
                        left: 8,
                        child: Container(
                            child: staatus == 'offline'
                                ? Icon(
                                    Icons.wifi_off_outlined,
                                    size: 60,
                                    color: Colors.amber,
                                  )
                                : Icon(
                                    Icons.wifi,
                                    size: 60,
                                    color: Colors.blue,
                                  )),
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
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color.fromARGB(255, 115, 162, 195),
          fixedColor: Color.fromARGB(255, 157, 214, 171),
          unselectedItemColor: Colors.white,
          selectedIconTheme: IconThemeData(size: 40),
          unselectedIconTheme: IconThemeData(size: 30),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: 'Tühista',
              icon: Icon(Icons.cancel),
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
                    context,
                    MaterialPageRoute(
                        builder: (context) => DynaamilenieKoduLeht(i: 1)));
              } else if (koduindex == 1) {
                Navigator.push(
                  //Kui vajutatakse Teie seade ikooni peale, siis viiakse Seadmetelisamine lehele
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          KeskmiseHinnaAluselTundideValimine()),
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

SaaSeadmegraafik(Map<String, List<String>> SeadmeteMap, SeadmeNimi) {
  List<String>? deviceInfo = SeadmeteMap[SeadmeNimi];
  if (deviceInfo != null) {
    String graafik = deviceInfo[4];
    return graafik;
  }
  return null; // Device key not found in the map
}
