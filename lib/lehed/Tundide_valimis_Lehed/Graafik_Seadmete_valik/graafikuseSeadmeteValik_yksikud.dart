import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testuus4/funktsioonid/graafikGen1.dart';
import 'package:testuus4/funktsioonid/graafikGen2.dart';
import 'package:testuus4/lehed/Seadme_Lehed/SeadmeGraafikLeht.dart';
import 'package:testuus4/parameters.dart';
import 'package:testuus4/widgets/hoitatus.dart';
import '../../../funktsioonid/seisukord.dart';
import '../../../funktsioonid/token.dart';
import '../../../widgets/PopUpGraafik.dart';
import '../DynaamilineTundideValimine.dart';
import '../../Põhi_Lehed/dynamicKoduLeht.dart';
import 'package:testuus4/main.dart';
import 'package:http/http.dart' as http;

class SeadmeteListValimine_yksikud extends StatefulWidget {
  final Function saaValitudSeadmed;
  const SeadmeteListValimine_yksikud(
      {Key? key, required this.saaValitudSeadmed})
      : super(key: key);

  @override
  State<SeadmeteListValimine_yksikud> createState() =>
      _SeadmeteListValimine_yksikudState(
        saaValitudSeadmed: saaValitudSeadmed,
      );
}

class _SeadmeteListValimine_yksikudState
    extends State<SeadmeteListValimine_yksikud> {
  _SeadmeteListValimine_yksikudState({
    Key? key,
    required this.saaValitudSeadmed,
  });
  Function saaValitudSeadmed;
  Map<String, bool> ValitudSeadmed = {};
  bool isLoading = false;

  dynamic seadmeGraafik;
  @override
  int koduindex = 1;

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

  _submitForm() async {
    await SeadmeGraafikKontrollimineGen1();

    //await prefs.clear();

    /* minuSeadmedK.addAll(ajutineMap);
        if (minuSeadmedK[name]![4] == '1') {
          minuSeadmedK[name]![5] = await SeadmeGraafikKontrollimineGen1(id);
        } else if (minuSeadmedK[name]![4] == '2') {
          minuSeadmedK[name]![5] =
              'ei'; //await SeadmeGraafikKontrollimineGen2(id);
        }*/
  }

  @override
  initState() {
    //_submitForm();
    ValitudSeadmed = valitudSeadmeteNullimine();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backround,
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
                      if (seadmeteMap[seade]["Seadme_olek"] != 'Offline') {
                        setState(() {
                          if (ValitudSeadmed[seade] == false) {
                            ValitudSeadmed[seade] = true;
                          } else {
                            ValitudSeadmed[seade] = false;
                          }
                        });
                        saaValitudSeadmed(ValitudSeadmed);
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
                                child: seadmeteMap[seade]["Graafik"] == 'ei' ||
                                        staatus == 'Offline'
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
                                          if (seadmeteMap[seade]
                                                  ["Seadme_generatsioon"] ==
                                              1) {
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
                                          } else {
                                            if (seadmeteMap[seade]
                                                    ["Seadme_olek"] !=
                                                'Offline') {
                                              var temp =
                                                  await SeadmeGraafikKoostamineGen2(
                                                      seade);

                                              setState(() {
                                                seadmeGraafik = temp;
                                              });
                                            }
                                          }

                                          PopUpGraafik(
                                              context,
                                              '${seadmeteMap[seade]["Seadme_nimi"]} graafik:',
                                              seadmeGraafik);
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
    );
  }
}

Map<String, bool> valitudSeadmeteNullimine() {
  Map<String, bool> ValitudSeadmed = {};
  seadmeteMap.forEach((key, value) async {
    ValitudSeadmed[key] = false;
  });
  return ValitudSeadmed;
}

SeadmeGraafikKoostamineGen1(String value) async {
  bool grafikOlems = false;
  List<dynamic> seadmeGraafik1 = await graafikGen1Lugemine(value);

  int paev = getCurrentDayOfWeek();
  seadmeGraafik1 = graafikGen1Filtreerimine(seadmeGraafik1, [paev]);
  for (var i = 0; i < seadmeGraafik1.length; i++) {
    String mainString = seadmeGraafik1[i];
    if (mainString.contains("-$paev-")) {
      grafikOlems = true;
      break;
    }
  }
  seadmeGraafik1 = graafikGen1TabeliLoomine(seadmeGraafik1);
  if (grafikOlems) {
    print(("J: $seadmeGraafik1"));
    return seadmeGraafik1;
  } else {
    List<String> tuhi = ['pole graafikut'];
    return tuhi;
  }
}

SeadmeGraafikKoostamineGen2(
  String value,
) async {
  bool grafikOlems = false;
  List<dynamic> seadmeGraafik1 = await graafikGen2Lugemine(value);
  seadmeGraafik1 = graafikGen2ToGraafikGen1(seadmeGraafik1);
  int paev = getCurrentDayOfWeek();
  for (var i = 0; i < seadmeGraafik1.length; i++) {
    String mainString = seadmeGraafik1[i];
    if (mainString.contains("-$paev-")) {
      grafikOlems = true;
      break;
    }
  }
  List test = graafikGen1Filtreerimine(seadmeGraafik1, [paev]);
  test = graafikGen1TabeliLoomine(test);
  if (grafikOlems) {
    return test;
  } else {
    List<String> tuhi = ['pole graafikut'];
    return tuhi;
  }
}

List graafikGen1TabeliLoomine(seadmeGraafik1) {
  List timeList = [];
  List uusGraafik = [];
  seadmeGraafik1.sort((a, b) {
    final timeA = int.parse(a.substring(0, 4));
    final timeB = int.parse(b.substring(0, 4));

    return timeA.compareTo(timeB);
  });

  for (var i = 0; i < seadmeGraafik1.length; i++) {
    List parts = seadmeGraafik1[i].split('-');

    timeList.add(int.parse(parts[0].substring(0, 2)));
  }
  for (int j = 0; j < 24; j++) {
    if (timeList.contains(j)) {
      List parts = seadmeGraafik1[timeList.indexOf(j)].split('-');
      uusGraafik.add(parts[2]);
    } else {
      uusGraafik.add(uusGraafik[j - 1]);
    }
  }
  return uusGraafik;
}

SeadmeGraafikKontrollimineGen1() async {
  bool grafikOlems = false;

  String graafik = '';
  seadmeteMap.forEach((key, value) async {
    if (value['Seadme_generatsioon'] == 1) {
      List<dynamic> seadmeGraafik1 = await graafikGen1Lugemine(key);
      graafik = seadmeGraafik1.join(", ");
      int paev = getCurrentDayOfWeek();
      if (graafik.contains("-$paev-")) {
        grafikOlems = true;
      }

      if (grafikOlems) {
        seadmeteMap[key]["Graafik"] = 'jah';

        //return 'jah';
      } else {
        //return 'ei';
        seadmeteMap[key]["Graafik"] = 'ei';
      }
    }
  });
}

SeadmeGraafikKontrollimineGen2() async {
  bool grafikOlems = false;
  DateTime now = DateTime.now();

  String graafik = '';
  List<dynamic> graafikList;
  seadmeteMap.forEach((key, value) async {
    if (value['Seadme_generatsioon'] == 2) {
      List<dynamic> jobs = List.empty(growable: true);
      jobs = await graafikGen2Lugemine(key);
      graafikList = await graafikGen2ToGraafikGen1(jobs);
      graafik = graafikList.join(", ");
      await graafikGen1ToGraafikGen2(graafikList);
      int today = getCurrentDayOfWeek();
      if (graafik.contains("-$today-")) {
        seadmeteMap[key]["Graafik"] = 'jah';
      } else {
        seadmeteMap[key]["Graafik"] = 'ei';
      }
    }
  });
}

int getCurrentDayOfWeek() {
  int paev;
  final now = DateTime.now();
  paev = now.weekday - 1;
  return paev; // Adjust for 0-based index
}

int getTommorowDayOfWeek() {
  int paev;
  final now = DateTime.now();
  paev = now.weekday;
  if (paev == 7) {
    paev = 0;
  }
  return paev; // Adjust for 0-based index
}
