import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/lehed/Login.dart';
import 'package:testuus4/lehed/SeadmeGraafikLeht.dart';
import 'package:testuus4/lehed/abiLeht.dart';
import 'package:testuus4/lehed/drawer.dart';
import 'package:testuus4/lehed/kasutajaSeaded.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testuus4/lehed/keskimiseHinnaAluselTundideValimine.dart';
import 'package:testuus4/lehed/seadmeteList.dart';
import '../funktsioonid/seisukord.dart';
import 'DynaamilineTundideValimine.dart';
import 'dynamicKoduLeht.dart';
import 'navigationBar.dart';
import 'package:testuus4/main.dart';
import 'package:flutter/material.dart';
import '../funktsioonid/graafikGen2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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
  Map<int, bool> ValitudSeadmed = {};
  bool isLoading = true;
  late Map<String, List<String>> minuSeadmedK = {};
  dynamic seadmeGraafik;
  @override
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

      ValitudSeadmed = valitudSeadmeteNullimine(SeadmeteMap);
      isLoading = false;
    });
  }

  @override
  void initState() {
    //seisukord();
    _submitForm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backround,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: appbar,
        title: Text(
          'Seadmete valimine',
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(fontSize: 25),
          ),
        ),
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
                      if (SeadmeteMap[seade]![2] != 'Offline') {
                        setState(() {
                          if (ValitudSeadmed[index] == false) {
                            ValitudSeadmed[index] = true;
                          } else {
                            ValitudSeadmed[index] = false;
                          }
                        });
                        print(ValitudSeadmed);
                        print(ValitudSeadmed[0]);
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
                              color: ValitudSeadmed[index] == true
                                  ? Colors.green
                                  : Colors.grey,
                              width: 8,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                  color: ValitudSeadmed[index] == true
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
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
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
                                        onPressed: () async {
                                          if (SeadmeteMap[seade]![2] !=
                                              'Offline') {
                                            var temp =
                                                await SeadmeGraafikKoostamineGen1(
                                                    SeadmeteMap[seade]![2]);

                                            setState(() {
                                              seadmeGraafik = temp;
                                            });
                                          }
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    title:
                                                        Text('$seade graafik:'),
                                                    content: Container(
                                                      height:
                                                          300, // Adjust as needed
                                                      width:
                                                          300, // Adjust as needed
                                                      child: ListView.builder(
                                                        itemCount: seadmeGraafik
                                                            .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          var item =
                                                              seadmeGraafik[
                                                                  index];
                                                          return Container(
                                                            color: item == 'on'
                                                                ? Colors.green
                                                                : Colors.grey,
                                                            child: ListTile(
                                                              title: Text(
                                                                  index.toString() +
                                                                      ": \t \t \t \t $item",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black)),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ));
                                        },
                                      ),
                              ),
                              Positioned(
                                top: 25,
                                left: 8,
                                child: Container(
                                    child: staatus == 'Offline'
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
                      builder: (context) => DynamilineTundideValimine(
                            valitudSeadmed: ValitudSeadmed,
                          )),
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

Map<int, bool> valitudSeadmeteNullimine(Map<String, List<String>> SeadmeteMap) {
  Map<int, bool> ValitudSeadmed = {};
  int i = 0;
  for (String seade in SeadmeteMap.keys) {
    ValitudSeadmed[i] = false;
    i++;
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

SeadmeGraafikKoostamineGen1(String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? storedKey = prefs.getString('key');
  String storedKeyString = jsonDecode(storedKey!);
  var headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  var data = {
    'channel': '0',
    'id': '80646f81ad9a',
    'auth_key': storedKeyString,
  };

  var url = Uri.parse('https://shelly-64-eu.shelly.cloud/device/settings');

  var res = await http.post(url, headers: headers, body: data);

  await Future.delayed(const Duration(seconds: 2));
  //Kui post läheb läbi siis:

  final httpPackageJson = json.decode(res.body) as Map<String, dynamic>;

  var seadmeGraafik1 =
      httpPackageJson['data']['device_settings']['relays'][0]['schedule_rules'];

  print('seadme graafik enne tootlemist');
  print(seadmeGraafik1);

  Map<int, String> map = {};

  for (var item in seadmeGraafik1) {
    var parts = item.split('-');
    var time = int.parse(parts[0]);
    var status = parts[2];
    map[time] = status;
  }

  String? lastStatus;

  for (int i = 0; i <= 2300; i += 100) {
    if (map.containsKey(i)) {
      lastStatus = map[i];
    } else if (lastStatus != null) {
      map[i] = lastStatus;
    }
  }

  print('seadme graafik peale tootlemist');
  print(map);

  return map;
}
