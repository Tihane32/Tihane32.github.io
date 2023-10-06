import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testuus4/lehed/SeadmeGraafikLeht.dart';
import 'package:testuus4/widgets/hoitatus.dart';
import '../funktsioonid/seisukord.dart';
import '../funktsioonid/token.dart';
import 'DynaamilineTundideValimine.dart';
import 'dynamicKoduLeht.dart';
import 'package:testuus4/main.dart';
import 'package:http/http.dart' as http;

class SeadmeteListValimine extends StatefulWidget {
  const SeadmeteListValimine({Key? key}) : super(key: key);

  @override
  State<SeadmeteListValimine> createState() => _SeadmeteListValimineState();
}

class _SeadmeteListValimineState extends State<SeadmeteListValimine> {
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

  Future _submitForm() async {
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
  void initState() {
    ValitudSeadmed = valitudSeadmeteNullimine();
    _submitForm;
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
                          print(ValitudSeadmed);
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
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0)),
                                              ),
                                              titlePadding:
                                                  EdgeInsets.only(top: 10.0),
                                              contentPadding:
                                                  EdgeInsets.only(top: 10.0),
                                              title: Align(
                                                alignment: Alignment.center,
                                                child: Text('${seadmeteMap[seade]["Seadme_nimi"]} graafik:'),
                                              ),
                                              content: Container(
                                                height: 528,
                                                child: Column(
                                                  children: List.generate(
                                                    seadmeGraafik.length,
                                                    (index) {
                                                      var item =
                                                          seadmeGraafik[index];
                                                      return Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: item == 'on'
                                                              ? Colors.green
                                                              : Color.fromARGB(
                                                                  255,
                                                                  202,
                                                                  200,
                                                                  200),
                                                          border: Border.all(
                                                              color: Color
                                                                  .fromARGB(82,
                                                                      0, 0, 0),
                                                              width: 0.5),
                                                        ),
                                                        child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            index < 10
                                                                ? "0${index.toString()}:00"
                                                                : "${index.toString()}:00",
                                                            style: font,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
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
                if (ValitudSeadmed.values.any((value) => value == true)) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DynamilineTundideValimine(
                            valitudSeadmed: ValitudSeadmed, i: 1, luba: '')),
                  );
                } else {
                  Hoiatus(
                    context,
                    'Enne graafiku koostamist valige kaasatavad seadmed!',
                  );
                }
              }
            });
          }),
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

SaaSeadmegraafik(SeadmeNimi) {
  String deviceInfo = seadmeteMap[SeadmeNimi];
  if (deviceInfo != null) {
    String graafik = deviceInfo[5];
    return graafik;
  }
  return null; // Device key not found in the map
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

  var url = Uri.parse('https://shelly-64-eu.shelly.cloud/device/settings');

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
    print(graafikParis);

    List<String> onOffStatus = [];

    for (var timeEntry in graafikParis) {
      var parts = timeEntry.split('-');
      var status = parts[2];

      if (status == "on" || status == "off") {
        onOffStatus.add(status);
      }
    }
    print(onOffStatus);
    return onOffStatus;
  } else {
    List<String> tuhi = ['pole graafikut'];
    return tuhi;
  }
}

SeadmeGraafikKoostamineGen2(
  String value,
) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var graafikud = Map<String, dynamic>();
  List temp = List.empty(growable: true);

  String token = await getToken();
  var headers = {
    'Authorization': 'Bearer $token',
  };

  var data = {
    'id': value,
    'method': 'schedule.list',
  };

  var url = Uri.parse(
      'https://shelly-64-eu.shelly.cloud/fast/device/gen2_generic_command');
  var res = await http.post(url, headers: headers, body: data);
  if (res.statusCode == 200) {
    var resJSON = jsonDecode(res.body) as Map<String, dynamic>;
    if (resJSON == null) {
      return; // stop the function if resJSON is null
    }
    var jobs = resJSON['data']['jobs'];
    if (jobs == null) {
      // handle the case where jobs is null
      return;
    }
    jobs = resJSON['data']['jobs'] as List<dynamic>;
    int k = 0;
    for (var job in jobs) {
      DateTime now = DateTime.now();

      // Create a DateFormat instance to format the date
      DateFormat dateFormat =
          DateFormat('EEE'); // 'EEE' gives the abbreviated weekday name

      // Format the current date to get the weekday abbreviation (e.g., "MON," "TUE," etc.)
      String formattedWeekday = dateFormat.format(now);
      formattedWeekday = formattedWeekday.toUpperCase();

      String date = job['timespec'].split(" ")[5];
      if (date == formattedWeekday) {
        var id = job['id'] as int;
        var timespec = job['timespec'] as String;
        temp.add(id);

        var calls = job['calls'] as List<dynamic>;
        var graafik = Map<String, dynamic>();
        for (var call in calls) {
          var params = call['params']['on'];

          graafik['Timespec'] = timespec;
          graafik['On/Off'] = params;
          graafikud['$id'] = graafik;
        }
      }
      k++;
    }
  }
}

SeadmeGraafikKontrollimineGen1() async {
  bool grafikOlems = false;
  DateTime now = DateTime.now();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? storedKey = prefs.getString('key');
  String storedKeyString = jsonDecode(storedKey!);

  seadmeteMap.forEach((key, value) async {
    if (value['Seadme_generatsioon'] == 1) {
      var headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      var data = {
        'channel': '0',
        'id': key,
        'auth_key': value["Cloud_key"],
      };

      var url = Uri.parse('https://shelly-64-eu.shelly.cloud/device/settings');

      var res = await http.post(url, headers: headers, body: data);

      await Future.delayed(const Duration(seconds: 2));
      //Kui post läheb läbi siis:

      final httpPackageJson = json.decode(res.body) as Map<String, dynamic>;

      var seadmeGraafik1 = httpPackageJson['data']['device_settings']['relays']
          [0]['schedule_rules'];

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
        seadmeteMap[key]["Graafik"] = 'jah';
        //return 'jah';
      } else {
        //return 'ei';
        seadmeteMap[key]["Graafik"] = 'ei';
      }
    }
  });
}
