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
import 'package:http/http.dart' as http;

class KopeeriGraafikTundideValik extends StatefulWidget {
  final Function updateValitudSeadmed;
  KopeeriGraafikTundideValik(
      {Key? key, this.valitudSeadmed, required this.updateValitudSeadmed})
      : super(key: key);
  final valitudSeadmed;
  @override
  _KopeeriGraafikTundideValikState createState() =>
      _KopeeriGraafikTundideValikState(
          valitudSeadmed: valitudSeadmed,
          updateValitudSeadmed: updateValitudSeadmed);
}

class _KopeeriGraafikTundideValikState
    extends State<KopeeriGraafikTundideValik> {
  _KopeeriGraafikTundideValikState(
      {Key? key,
      required this.valitudSeadmed,
      required this.updateValitudSeadmed});
  Function updateValitudSeadmed;
  var valitudSeadmed;
  int koduindex = 1;
  bool isLoading = false;
  String selectedPage = 'Kopeeri graafik';
  double vahe = 10;
  int valitudTunnid = 10;
  Color boxColor = sinineKast;
  Map<String, bool> ValitudGraafik = {};

  dynamic seadmeGraafik;
  @override
  void initState() {
    //seisukord();
    SeadmeGraafikKontrollimineGen1();
    super.initState();
    ValitudGraafik = valitudSeadmeteNullimine();
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Scaffold(
        body: GestureDetector(
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 5),
                  ),
                  itemCount: seadmeteMap.length,
                  itemBuilder: (context, index) {
                    final seade = seadmeteMap.keys.elementAt(index);
                    final pilt = seadmeteMap[seade]["Seadme_pilt"];
                    final staatus = seadmeteMap[seade]["Seadme_olek"];

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          ValitudGraafik = valitudSeadmeteNullimine();
                        });
                        print(seadmeteMap[seade]["Graafik"]);
                        if (seadmeteMap[seade]["Graafik"] == 'jah') {
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
                        print(seadmeteMap);
                        print(ValitudGraafik);
                        print(valitudSeadmed);
                        updateValitudSeadmed(ValitudGraafik);
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
                                  child: seadmeteMap[seade]["Graafik"] == 'ei'
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
                                          onPressed: () async {
                                            if (seadmeteMap[seade]
                                                    ["Seadme_olek"] !=
                                                'Offline') {
                                              var temp =
                                                  await SeadmeGraafikKoostamineGen1(
                                                      seade);

                                              setState(() {
                                                seadmeGraafik = temp;
                                              });
                                            }
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      title: Text(
                                                          '$seade graafik: \n' +
                                                              seadmeGraafik),
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
                                        seadmeteMap[seade]["Seadme_nimi"],
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

Map<String, bool> valitudSeadmeteNullimine() {
  Map<String, bool> ValitudSeadmed = {};
  seadmeteMap.forEach((key, value) {
    ValitudSeadmed[key] = false;
  });
  return ValitudSeadmed;
}

SaaSeadmegraafik(SeadmeNimi) {
  List<String>? deviceInfo = seadmeteMap[SeadmeNimi];
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

  Map<int, String> map = {};

  for (var item in seadmeGraafik1) {
    var parts = item.split('-');
    var time = int.parse(parts[0]);
    var status = parts[2];
    map[time] = status;
  }

  String? lastStatus;
  List<String> seadmeGraafik2 = [];

  for (int i = 0; i <= 2300; i += 100) {
    if (map.containsKey(i)) {
      lastStatus = map[i];
    } else if (lastStatus != null) {
      map[i] = lastStatus;
    }

    if (lastStatus != null) {
      seadmeGraafik2
          .add("${i.toString().padLeft(4, '0')}: \t \t \t \t $lastStatus \n");
    }
  }

  String seadmeGraafik3 = '';

  for (var item in seadmeGraafik2) {
    seadmeGraafik3 += item;
  }

  return seadmeGraafik3.toString();
}
