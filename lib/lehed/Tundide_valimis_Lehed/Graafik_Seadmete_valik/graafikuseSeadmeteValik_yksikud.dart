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
                                          print(seadmeGraafik);

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
  DateTime now = DateTime.now();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? storedKey = prefs.getString('key');
  String storedKeyString = jsonDecode(storedKey!);
  var headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  var data = {
    'channel': '0',
    'id': value,
    'auth_key': storedKeyString,
  };

  var url = Uri.parse('${seadmeteMap[value]["api_url"]}/device/settings');

  var res = await http.post(url, headers: headers, body: data);

  await Future.delayed(const Duration(seconds: 2));
  //Kui post läheb läbi siis:

  final httpPackageJson = json.decode(res.body) as Map<String, dynamic>;

  var seadmeGraafik1 =
      httpPackageJson['data']['device_settings']['relays'][0]['schedule_rules'];

  int paev = 0;

  if (now.weekday == 7) {
    paev = 0;
  } else {
    paev = now.weekday - 1;
  }

  for (var i = 0; i < seadmeGraafik1.length; i++) {
    String mainString = seadmeGraafik1[i];
    if (mainString.contains("-$paev-")) {
      grafikOlems = true;
    }
  }

  if (grafikOlems) {
    List<String> filledTimes = [];
    List<String> graafikParis = [];
    String? lastState;

    for (var i = 0; i < seadmeGraafik1.length; i++) {
      var parts = seadmeGraafik1[i].split('-');
      var currentTime = int.parse(parts[0]);
      var state = parts[2];

      if (i == 0) {
        filledTimes.add(seadmeGraafik1[i]);
      } else {
        var prevParts = seadmeGraafik1[i - 1].split('-');
        var prevTime = int.parse(prevParts[0]);
        var timeDiff = currentTime - prevTime;

        if (timeDiff > 100) {
          for (var j = 1; j < timeDiff / 100; j++) {
            filledTimes.add(
                "${(prevTime + 100 * j).toString().padLeft(4, '0')}-0-$lastState");
          }
        }
        filledTimes.add(seadmeGraafik1[i]);
      }
      lastState = state;
    }

    var lastParts = filledTimes.last.split('-');
    var lastTime = int.parse(lastParts[0]);

    while (lastTime < 2400) {
      lastTime += 100;
      filledTimes.add("${lastTime.toString().padLeft(4, '0')}-0-$lastState");
    }
    if (filledTimes[0] != '0000-$paev-on' ||
        filledTimes[0] != '0000-$paev-off') {
      int maramataPaevad = 24 - filledTimes.length;
      for (int i = 0; i < 24; i++) {
        String tunnike = '';
        if (i < maramataPaevad + 1) {
          if (i < 10) {
            tunnike = '0$i';
          } else {
            tunnike = '$i';
          }
          graafikParis.add("${tunnike}00-0-off");
        } else {
          graafikParis.add(filledTimes[i - maramataPaevad - 1]);
        }
      }
    }

    List<String> onOffStatus = [];

    for (var timeEntry in graafikParis) {
      var parts = timeEntry.split('-');
      var status = parts[2];

      if (status == "on" || status == "off") {
        onOffStatus.add(status);
      }
    }
    return onOffStatus;
  } else {
    List<String> tuhi = ['pole graafikut'];
    return tuhi;
  }
}

SeadmeGraafikKoostamineGen2(
  String value,
) async {
  bool grafikOlems = false;
  DateTime now = DateTime.now();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? storedKey = prefs.getString('key');
  String storedKeyString = jsonDecode(storedKey!);

  List<dynamic> seadmeGraafik1 = await graafikGen2Lugemine(value);
  seadmeGraafik1 = graafikGen2ToGraafikGen1(seadmeGraafik1);
  print(seadmeGraafik1);

  int paev = 0;

  if (now.weekday == 7) {
    paev = 0;
  } else {
    paev = now.weekday - 1;
  }

  for (var i = 0; i < seadmeGraafik1.length; i++) {
    String mainString = seadmeGraafik1[i];
    if (mainString.contains("-$paev-")) {
      grafikOlems = true;
    }
  }

  if (grafikOlems) {
    List<String> filledTimes = [];
    List<String> graafikParis = [];
    String? lastState;

    for (var i = 0; i < seadmeGraafik1.length; i++) {
      var parts = seadmeGraafik1[i].split('-');
      var currentTime = int.parse(parts[0]);
      var state = parts[2];

      if (i == 0) {
        filledTimes.add(seadmeGraafik1[i]);
      } else {
        var prevParts = seadmeGraafik1[i - 1].split('-');
        var prevTime = int.parse(prevParts[0]);
        var timeDiff = currentTime - prevTime;

        if (timeDiff > 100) {
          for (var j = 1; j < timeDiff / 100; j++) {
            filledTimes.add(
                "${(prevTime + 100 * j).toString().padLeft(4, '0')}-0-$lastState");
          }
        }
        filledTimes.add(seadmeGraafik1[i]);
      }
      lastState = state;
    }

    var lastParts = filledTimes.last.split('-');
    var lastTime = int.parse(lastParts[0]);

    while (lastTime < 2400) {
      lastTime += 100;
      filledTimes.add("${lastTime.toString().padLeft(4, '0')}-0-$lastState");
    }
    if (filledTimes[0] != '0000-$paev-on' ||
        filledTimes[0] != '0000-$paev-off') {
      int maramataPaevad = 24 - filledTimes.length;
      for (int i = 0; i < 24; i++) {
        String tunnike = '';
        if (i < maramataPaevad + 1) {
          if (i < 10) {
            tunnike = '0$i';
          } else {
            tunnike = '$i';
          }
          graafikParis.add("${tunnike}00-0-off");
        } else {
          graafikParis.add(filledTimes[i - maramataPaevad - 1]);
        }
      }
    }

    List<String> onOffStatus = [];

    for (var timeEntry in graafikParis) {
      var parts = timeEntry.split('-');
      var status = parts[2];

      if (status == "on" || status == "off") {
        onOffStatus.add(status);
      }
    }
    return onOffStatus;
  } else {
    List<String> tuhi = ['pole graafikut'];
    return tuhi;
  }
}

SeadmeGraafikKontrollimineGen1() async {
  bool grafikOlems = false;

  String graafik = '';
  seadmeteMap.forEach((key, value) async {
    if (value['Seadme_generatsioon'] == 1) {
      print("saadab $key");
      List<dynamic> seadmeGraafik1 = await graafikGen1Lugemine(key);
      print("sai $key");
      graafik = seadmeGraafik1.join(", ");
      int paev = getCurrentDayOfWeek();
      print("seadme graafik: $graafik");
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
