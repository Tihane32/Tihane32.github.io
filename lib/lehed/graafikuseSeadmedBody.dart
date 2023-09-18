import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../funktsioonid/seisukord.dart';
import 'package:testuus4/main.dart';

import 'GraafikusseSeadmeteValik.dart';

class SeadmeteListValimineBody extends StatefulWidget {
  const SeadmeteListValimineBody({Key? key}) : super(key: key);

  @override
  State<SeadmeteListValimineBody> createState() =>
      _SeadmeteListValimineBodyState();
}

class _SeadmeteListValimineBodyState extends State<SeadmeteListValimineBody> {
  Map<String, bool> ValitudSeadmed = {};
  bool laeb = true;
  late Map<String, List<String>> minuSeadmedK = {};
  String onoffNupp = 'Shelly ON';
  @override
  void initState() {
    //seisukord();
    _submitForm();
    super.initState();
    ValitudSeadmed = valitudSeadmeteNullimine(SeadmeteMap);
  }

  int koduindex = 1;

  Map<String, List<String>> SeadmeteMap = {};

  Future _submitForm() async {
    minuSeadmedK.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //await prefs.clear();

    String? storedJsonMap = prefs.getString('seadmed');
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
        Map<String, List<String>> ajutineMap = {
          name: ['assets/boiler1.jpg', '$id', '$olek', '$pistik', 'jah'],
        };
        minuSeadmedK.addAll(ajutineMap);
        i++;
      }
    }
    setState(() {
      SeadmeteMap = minuSeadmedK;
      laeb = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backround,
      body: laeb
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
                        if (ValitudSeadmed[seade] == false) {
                          ValitudSeadmed[seade] = true;
                        } else {
                          ValitudSeadmed[seade] = false;
                        }
                      });
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
