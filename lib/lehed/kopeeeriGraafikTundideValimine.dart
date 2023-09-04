import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/lehed/GraafikusseSeadmeteValik.dart';
import 'package:testuus4/lehed/dynamicKoduLeht.dart';
import 'package:testuus4/lehed/keskimiseHinnaAluselTundideValimine.dart';
import '../funktsioonid/seisukord.dart';
import '../main.dart';
import 'AbiLeht.dart';
import 'hinnaPiiriAluselTunideValimine.dart';

class KopeeriGraafikTundideValik extends StatefulWidget {
  const KopeeriGraafikTundideValik({Key? key}) : super(key: key);

  @override
  _KopeeriGraafikTundideValikState createState() =>
      _KopeeriGraafikTundideValikState();
}

class _KopeeriGraafikTundideValikState
    extends State<KopeeriGraafikTundideValik> {
  int koduindex = 1;
  bool isLoading = true;
  String selectedPage = 'Kopeeri graafik';
  double vahe = 10;
  int valitudTunnid = 10;
  Color boxColor = sinineKast;
  Map<String, bool> ValitudGraafik = {};

  late Map<String, List<String>> minuSeadmedK = {};
  dynamic seadmeGraafik;
  @override
  void initState() {
    //seisukord();
    _submitForm();
    super.initState();
    ValitudGraafik = valitudSeadmeteNullimine(SeadmeteMap);
  }

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
      await seisukord();
      storedJsonMap = prefs.getString('seadmed');
      Map<String, dynamic> storedMap = json.decode(storedJsonMap!);
      await Future.delayed(const Duration(seconds: 3));
      var i = 0;
      for (String Seade in storedMap.keys) {
        var id = storedMap['Seade$i']['Seadme_ID'];
        var name = storedMap['Seade$i']['Seadme_nimi'];
        var pistik = storedMap['Seade$i']['Seadme_pistik'];
        var olek = storedMap['Seade$i']['Seadme_olek'];
        print('olek: $olek');
        Map<String, List<String>> ajutineMap = {
          name: ['assets/boiler1.jpg', '$id', '$olek', '$pistik', 'jah'],
        };
        minuSeadmedK.addAll(ajutineMap);
        i++;
      }
      //TODO: eemalda j'rgmine rida kui gen2 tgraafik tootab
      minuSeadmedK['Shelly Pro PM']![4] = 'ei';
      print('seadmed');
      print(minuSeadmedK);
      print(SeadmeteMap);
    }
    setState(() {
      SeadmeteMap = minuSeadmedK;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 115, 162, 195),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Graafiku valimine'),
            ],
          ),
          actions: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButton<String>(
                  value: selectedPage,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPage = newValue!;
                    });
                    if (selectedPage == 'Hinnapiir') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LylitusValimisLeht2()),
                      );
                    } else if (selectedPage == 'Minu eelistused') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AbiLeht()),
                      );
                    } else if (selectedPage == 'Keskmine hind') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LylitusValimisLeht1()),
                      );
                    }
                  },
                  underline: Container(), // or SizedBox.shrink()
                  items: <String>[
                    'Keskmine hind',
                    'Hinnapiir',
                    'Minu eelistused',
                    'Kopeeri graafik'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        body: GestureDetector(
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : GridView.builder(
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
                        setState(() {
                          ValitudGraafik =
                              valitudSeadmeteNullimine(SeadmeteMap);
                        });
                        if (graafik == 'jah') {
                          setState(() {
                            if (ValitudGraafik[seade] == false) {
                              ValitudGraafik[seade] = true;
                            }
                          });
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text("  Seadmel puudub graafik"),
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
                                color: ValitudGraafik[seade] == true
                                    ? Colors.green
                                    : Colors.grey,
                                width: 8,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                    color: ValitudGraafik[seade] == true
                                        ? Color.fromARGB(255, 177, 245, 180)
                                        : Color.fromARGB(255, 236, 228, 228)),
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
                                  child: graafik == 'ei'
                                      ? IconButton(
                                          iconSize: 60,
                                          icon: Icon(
                                            Icons.warning_amber_rounded,
                                            size: 80,
                                            color: Colors.amber,
                                          ),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      title: Text(
                                                          "  $seade graafik puudub"),
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
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      title: Text(
                                                          "  $seade graafik: \n \t 00.00 on \n \t 00.10 on \n \t 00.20 on \n \t 03.00 off \n \t ..."),
                                                    ));
                                          },
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
        ),
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Color.fromARGB(255, 115, 162, 195),
            fixedColor: Color.fromARGB(255, 157, 214, 171),
            unselectedItemColor: Colors.white,
            //selectedIconTheme: IconThemeData(size: 40),
            //unselectedIconTheme: IconThemeData(size: 30),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                label: 'Seadmed',
                icon: Icon(
                  Icons.list_outlined,
                  size: 40,
                ),
              ),
              BottomNavigationBarItem(
                label: 'Kinnita',
                icon: Icon(
                  Icons.check_circle_outlined,
                  size: 40,
                ),
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
                    MaterialPageRoute(
                        builder: (context) => SeadmeteListValimine()),
                  );
                } else if (koduindex == 1) {
                  Navigator.push(
                    //Kui vajutatakse Teie seade ikooni peale, siis viiakse Seadmetelisamine lehele
                    context,
                    MaterialPageRoute(
                        builder: (context) => DynaamilenieKoduLeht(
                              i: 1,
                            )),
                  );
                }
              });
            }),
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
