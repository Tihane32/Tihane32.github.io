import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testuus4/funktsioonid/graafikGen1.dart';
import 'package:testuus4/lehed/AbiLeht.dart';
import 'package:testuus4/lehed/SeadmeTarbimisLeht.dart';
import 'package:testuus4/lehed/TarbimisLeht.dart';
import 'SeadmeYldInfo.dart';
import 'seadmeteList.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testuus4/lehed/seadmedKontoltNim.dart';
import 'koduleht.dart';
import 'hinnaPiiriAluselTunideValimine.dart';
import 'dart:math';
import 'package:testuus4/lehed/kaksTabelit.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:testuus4/main.dart';
import 'package:testuus4/funktsioonid/Elering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:testuus4/funktsioonid/lulitamine.dart';

class SeadmeGraafikuLeht extends StatefulWidget {
  const SeadmeGraafikuLeht(
      {Key? key, required this.seadmeNimi, required this.SeadmeteMap})
      : super(key: key);

  final String seadmeNimi;
  final Map<String, List<String>> SeadmeteMap;
  @override
  _SeadmeGraafikuLehtState createState() => _SeadmeGraafikuLehtState(
      seadmeNimi: seadmeNimi, SeadmeteMap: SeadmeteMap);
}

int koduindex = 2;
Color valge = Colors.white;
Color green = Colors.green;

bool hommeNahtav = false;

class _SeadmeGraafikuLehtState extends State<SeadmeGraafikuLeht> {
  _SeadmeGraafikuLehtState(
      {Key? key, required this.seadmeNimi, required this.SeadmeteMap});
  Map<String, List<String>> SeadmeteMap;
  final String seadmeNimi;
  late Map<int, dynamic> lulitusMap;
  int selectedRowIndex = -1;
  late double hindAVG = 0;
  String paevNupp = 'Täna';
  String selectedPage = 'Lülitusgraafik';
  double vahe = 10;
  Color boxColor = sinineKast;
  BorderRadius borderRadius = BorderRadius.circular(5.0);
  Border border = Border.all(
    color: const Color.fromARGB(255, 0, 0, 0),
    width: 2,
  );
  Color homme = valge;
  Color tana = green;
  TextStyle hommeFont = font;
  TextStyle tanaFont = fontValge;
  int? tappedIndex;
  bool kinnitusNahtav = false;
  late Map<int, dynamic> lulitus;
  late Map<int, dynamic> lulitusTana;
  late Map<int, dynamic> lulitusHomme;
  late double temp = 0;

  late double hindMin = 0;
  late double hindMax = 0;

  int tund = 0;

  Map<int, dynamic> keskHind = {
    0: ['0', 0, ''],
    1: ['0.0', 0, ''],
    2: ['1', 0, ''],
    3: ['2', 0, ''],
    4: ['3', 0, ''],
    5: ['4', 0, ''],
    6: ['5', 0, ''],
    7: ['6', 0, ''],
    8: ['7', 0, ''],
    9: ['8', 0, ''],
    10: ['9', 0, ''],
    11: ['10', 0, ''],
    12: ['12', 0, ''],
    13: ['0', 0, ''],
    14: ['0', 0, ''],
    15: ['0', 0, ''],
    16: ['0', 0, ''],
    17: ['0', 0, ''],
    18: ['0', 0, ''],
    19: ['0', 0, ''],
    20: ['0', 0, ''],
    21: ['0', 0, ''],
    22: ['0', 0, ''],
    23: ['0', 0, ''],
    24: ['0', 0, ''],
    25: ['0', 0, ''],
  };

  Future norm() async {
    DateTime now = new DateTime.now();

    var date = new DateTime(
        now.year, now.month, now.day, now.hour); // tänase päeva leidmine

    lulitus = {
      0: ['00.00', 0.0, false],
      1: ['01.00', 0.0, false],
      2: ['02.00', 0.0, false],
      3: ['03.00', 0.0, false],
      4: ['04.00', 0.0, false],
      5: ['05.00', 0.0, false],
      6: ['06.00', 0.0, false],
      7: ['07.00', 0.0, false],
      8: ['08.00', 0.0, false],
      9: ['09.00', 0.0, false],
      10: ['10.00', 0.0, false],
      11: ['11.00', 0.0, false],
      12: ['12.00', 0.0, false],
      13: ['13.00', 0.0, false],
      14: ['14.00', 0.0, false],
      15: ['15.00', 0.0, false],
      16: ['16.00', 0.0, false],
      17: ['17.00', 0.0, false],
      18: ['18.00', 0.0, false],
      19: ['19.00', 0.0, false],
      20: ['20.00', 0.0, false],
      21: ['21.00', 0.0, false],
      22: ['22.00', 0.0, false],
      23: ['23.00', 0.0, false],
    };

    lulitusTana = lulitus;
    lulitusHomme = {
      0: ['00.00', 6.22, false],
      1: ['01.00', 34.1, false],
      2: ['02.00', 10.0, false],
      3: ['03.00', 20.0, false],
      4: ['04.00', 30.0, false],
      5: ['05.00', 44.5, false],
      6: ['06.00', 3.6, false],
      7: ['07.00', 3.8, false],
      8: ['08.00', 40.0, false],
      9: ['09.00', 44.6, false],
      10: ['10.00', 4.6, false],
      11: ['11.00', 4.8, false],
      12: ['12.00', 5.1, false],
      13: ['13.00', 22.55, false],
      14: ['14.00', 50.0, false],
      15: ['15.00', 60.0, false],
      16: ['16.00', 70.0, false],
      17: ['17.00', 121.2, false],
      18: ['18.00', 40.2, false],
      19: ['19.00', 80.0, false],
      20: ['20.00', 90.0, false],
      21: ['21.00', 13.5, false],
      22: ['22.00', 24.4, false],
      23: ['23.00', 44.1, false],
    };
    var data = await getElering('tana');
    for (var i = 0; i < 24; i++) {
      lulitusTana[i][1] = data[i]['price'];
    }

    if (date.hour >
        15) //Kui kell on vähem, kui 15 või on saadetud String 'täna'
    {
      var data = await getElering('homme');
      for (var i = 0; i < 24; i++) {
        lulitusHomme[i][1] = data[i]['price'];
      }
    }
    lulitusHomme = await graafik(SeadmeteMap, seadmeNimi, lulitusHomme);
    setState(() {
      hommeNahtav = true; //TODO: testimise jaoks
      if (date.hour > 15) {
        hommeNahtav = true;
      }
      lulitus = lulitusTana;
      tund = date.hour;
      hindMax = maxLeidmine(lulitusTana);
      hindMin = minLeidmine(lulitusTana);
      hindAVG = keskmineHindArvutaus(lulitus);
      temp = hindAVG / 4;
      if (temp < 40) {
        temp = 40;
      }

      keskHind = keskmineHindMapVaartustamine(hindAVG, keskHind, lulitus);
      print('uuuuu');
      print(keskHind);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    []; //Võtab mälust 'users'-i asukohast väärtused
    var seadmedJSONmap = prefs.getString('seadmed');
    String value = SeadmeteMap[seadmeNimi]![1];
    Map<String, dynamic> storedMap = json.decode(seadmedJSONmap!);

    String? storedKey = prefs.getString('key');

    String storedKeyString = jsonDecode(storedKey!);
    var j = 0;
    var authKey = storedKeyString;
    // ignore: unused_local_variable
    for (var i in storedMap.values) {
      if (storedMap['Seade$j']['Seadme_ID'] == value) {
        var seadeGen = storedMap['Seade$j']['Seadme_generatsioon'] as int;

        if (seadeGen == 1) {
          DateTime now = DateTime.now();
          int tana = now.weekday - 1;

          List<String> newList = [];
          var headers = {
            'Content-Type': 'application/x-www-form-urlencoded',
          };

          var data = {
            'channel': '0',
            'id': value,
            'auth_key': authKey,
          };

          var url =
              Uri.parse('https://shelly-64-eu.shelly.cloud/device/settings');
          var res = await http.post(url, headers: headers, body: data);
          await Future.delayed(const Duration(seconds: 2));
          //Kui post läheb läbi siis:

          final httpPackageJson = json.decode(res.body) as Map<String, dynamic>;

          var scheduleRules1 = httpPackageJson['data']['device_settings']
              ['relays'][0]['schedule_rules'];
          for (String item in scheduleRules1) {
            List<String> parts = item.split('-');
            if (parts[1].length > 1) {
              for (int i = 0; i < parts[1].length; i++) {
                //lülituskäsk tehakse iga "-" juures pooleks ja lisatakse eraldi listi
                String newItem = '${parts[0]}-${parts[1][i]}-${parts[2]}';
                newList.add(newItem);
              }
            } else {
              newList.add(item);
            }
          }
          List<String> filteredRules = [];

          RegExp regExp = RegExp("-$tana-");

          for (var rule in newList) {
            if (regExp.hasMatch(rule)) {
              filteredRules.add(rule);
            }
          }

          var i = 0;

          setState(() {
            i = filteredRules.length;
            var u = 0;

            bool k = false;
            for (var j = 0; j < 24; j++) {
              String asendus = '$j';
              if (j < 10) {
                asendus = '0' + asendus + '00';
              } else {
                asendus = asendus + '00';
              }
              for (u = 0; u < i; u++) {
                List<String> parts = filteredRules[u].split('-');

                String timeString = parts[0];
                String formattedTime =
                    timeString.substring(0, 2) + timeString.substring(2);
                if (formattedTime == asendus) {
                  if (parts[2] == 'on') {
                    lulitus[j][2] = true;
                    k = true;
                  } else {
                    lulitus[j][2] = false;
                    k = false;
                  }
                  break;
                } else {
                  if (j != 0) {
                    lulitus[j][2] = lulitus[j - 1][2];
                  }
                }
              }
            }
          });
        }
        break;
      }
      j++;
    }
  }

  @override
  void initState() {
    norm();

    super.initState();
  }

  int i = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color.fromARGB(255, 189, 216, 225), //TaustavÃ¤rv

      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 115, 162, 195),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              seadmeNimi,
              style: GoogleFonts.roboto(
                textStyle: const TextStyle(fontSize: 25),
              ),
            )
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
                  if (selectedPage == 'Tarbimisgraafik') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TarbimisLeht(seadmeNimi: seadmeNimi, SeadmeteMap: SeadmeteMap,)),
                    );
                  } else if (selectedPage == 'Üldinfo') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SeadmeYldinfoLeht(seadmeNimi: seadmeNimi)),
                    );
                  }
                },
                underline: Container(), // or SizedBox.shrink()
                items: <String>['Lülitusgraafik', 'Tarbimisgraafik', 'Üldinfo']
                    .map((String value) {
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
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: vahe),
              Align(
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(text: 'Seadme olek:    ', style: font),
                            TextSpan(
                                text: SeadmeteMap[seadmeNimi]![2], style: font),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          iconSize: 40,
                          onPressed: () {
                            setState(() {
                              SeadmeteMap =
                                  muudaSeadmeOlek(SeadmeteMap, seadmeNimi);
                            });
                          },
                          icon: loeSeadmeOlek(SeadmeteMap, seadmeNimi) ==
                                  'offline'
                              ? Icon(Icons.wifi_off_outlined)
                              : loeSeadmeOlek(SeadmeteMap, seadmeNimi) == 'on'
                                  ? Icon(
                                      Icons.power_settings_new_rounded,
                                      color: Color.fromARGB(255, 77, 152, 81),
                                    )
                                  : Icon(
                                      Icons.power_settings_new_rounded,
                                      color: Colors.red,
                                    ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Container(
                  height: 1,
                  width: double.infinity,
                  color: Colors.black,
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                              child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (tana == valge) {
                                  lulitus = lulitusTana;
                                  tana = green;
                                  tanaFont = fontValge;
                                  homme = valge;
                                  hommeFont = font;
                                  hindMax = maxLeidmine(lulitus);
                                  hindMin = minLeidmine(lulitus);
                                  hindAVG = keskmineHindArvutaus(lulitus);
                                  keskHind = keskmineHindMapVaartustamine(
                                      hindAVG, keskHind, lulitus);
                                  temp = hindAVG / 4;
                                  if (temp < 40 && hindAVG > 40) {
                                    temp = 40;
                                  } else if (hindAVG < 40) {
                                    temp = hindAVG / 2;
                                  }
                                  HapticFeedback.vibrate();
                                } /*else {
                              lulitus = lulitusHomme;
                              tana = valge;
                              tanaFont = font;
                              homme = green;
                              hommeFont = fontValge;
                            }*/
                              });
                            },
                            child: Container(
                              width: 100,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: tana,
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(
                                    color: Colors.green,
                                    width: 3,
                                  )),
                              child: Center(
                                  child: RichText(
                                text: TextSpan(
                                  text: 'Täna',
                                  style: tanaFont,
                                ),
                                textAlign: TextAlign.center,
                              )),
                            ),
                          )),
                          if (hommeNahtav)
                            Center(
                                child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (homme == valge) {
                                    lulitus = lulitusHomme;
                                    homme = green;
                                    hommeFont = fontValge;
                                    tana = valge;
                                    tanaFont = font;
                                    hindMax = maxLeidmine(lulitus);
                                    hindMin = minLeidmine(lulitus);
                                    hindAVG = keskmineHindArvutaus(lulitus);
                                    keskHind = keskmineHindMapVaartustamine(
                                        hindAVG, keskHind, lulitus);
                                    temp = hindAVG / 4;
                                    if (temp < 40 && hindAVG > 40) {
                                      temp = 40;
                                    } else if (hindAVG < 40) {
                                      temp = hindAVG / 2;
                                    }
                                    HapticFeedback.vibrate();
                                  } /*else {
                                lulitus = lulitusTana;
                                homme = valge;
                                hommeFont = font;
                                tana = green;
                                tanaFont = fontValge;
                              }*/
                                });
                              },
                              child: Container(
                                width: 100,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: homme,
                                    borderRadius: BorderRadius.circular(30.0),
                                    border: Border.all(
                                      color: Colors.green,
                                      width: 3,
                                    )),
                                child: Center(
                                    child: RichText(
                                  text: TextSpan(
                                    text: 'Homme',
                                    style: hommeFont,
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                              ),
                            ))
                        ],
                      ),
                    ),
                    SizedBox(height: vahe),
                    /* Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        alignment: Alignment.center,
                        //width: 200,
                        child: Center(
                          child: Column(
                            children: [
                              Align(
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  //width: sinineKastLaius,
                                  //height: sinineKastKorgus,
                                  child: RichText(
                                    text: TextSpan(
                                      style: fontVaike,
                                      children: [
                                        TextSpan(
                                            text: 'Päeva keskmine:',
                                            style: fontVaike),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  //width: sinineKastLaius,
                                  //height: sinineKastKorgus,
                                  child: RichText(
                                    text: TextSpan(
                                      style: fontVaike,
                                      children: [
                                        TextSpan(text: '$hindAVG', style: font),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  //width: sinineKastLaius,
                                  //height: sinineKastKorgus,
                                  child: RichText(
                                    text: TextSpan(
                                      style: fontVaike,
                                      children: [
                                        TextSpan(
                                            text: 'EUR/MWh', style: fontVaike),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        //width: 200,
                        child: Column(
                          children: [
                            Align(
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                //width: sinineKastLaius,
                                //height: sinineKastKorgus,
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: fontVaike,
                                    children: [
                                      TextSpan(
                                          text: '   Päeva miinimum:',
                                          style: fontVaike),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                //width: sinineKastLaius,
                                //height: sinineKastKorgus,
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: fontVaike,
                                    children: [
                                      TextSpan(
                                          text: '   $hindMin', style: font),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                //width: sinineKastLaius,
                                //height: sinineKastKorgus,
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: fontVaike,
                                    children: [
                                      TextSpan(
                                          text: '   EUR/MWh', style: fontVaike),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        //width: 200,
                        child: Column(
                          children: [
                            Align(
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                //width: sinineKastLaius,
                                //height: sinineKastKorgus,
                                child: RichText(
                                  text: TextSpan(
                                    style: fontVaike,
                                    children: [
                                      TextSpan(
                                          text: 'Päeva maksimum:',
                                          style: fontVaike),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                //width: sinineKastLaius,
                                //height: sinineKastKorgus,
                                child: RichText(
                                  text: TextSpan(
                                    style: fontVaike,
                                    children: [
                                      TextSpan(text: '$hindMax', style: font),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                //width: sinineKastLaius,
                                //height: sinineKastKorgus,
                                child: RichText(
                                  text: TextSpan(
                                    style: fontVaike,
                                    children: [
                                      TextSpan(
                                          text: 'EUR/MWh', style: fontVaike),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: vahe * 2),*/
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Align(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              //width: sinineKastLaius,
                              //height: sinineKastKorgus,
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: fontVaike,
                                  children: [
                                    TextSpan(
                                        text: 'EUR / MWh', style: fontVaike),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                          child: RotatedBox(
                        quarterTurns: 1,
                        child: Container(
                          //width: double.infinity,
                          //height: double.infinity,
                          child: SfCartesianChart(
                            primaryXAxis: CategoryAxis(
                              majorGridLines: const MajorGridLines(width: 0),
                              interval: 1,
                              labelRotation: 270,
                              visibleMinimum: -0.35,
                              maximum: 23.5,
                            ),
                            primaryYAxis: NumericAxis(
                              anchorRangeToVisiblePoints: true,
                              axisLine: AxisLine(width: 0),
                              isVisible: true,
                              labelRotation: 270,
                              /* title: AxisTitle(
                              //text: 'EUR/MWh',
                              textStyle: fontVaike,
                              alignment: ChartAlignment.center),*/
                              labelStyle: TextStyle(fontSize: 0),
                            ),
                            series: <ChartSeries>[
                              ColumnSeries(
                                width: 0.9,
                                spacing: 0.1,
                                onPointTap: (pointInteractionDetails) {
                                  int rowIndex =
                                      pointInteractionDetails.pointIndex!;
                                  kinnitusNahtav = true;
                                  setState(() {
                                    lulitus[rowIndex][2] =
                                        !lulitus[rowIndex][2];
                                  });
                                },
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                                dataSource: lulitus.values.toList(),
                                xValueMapper: (data, _) => data[0],
                                yValueMapper: (data, _) {
                                  final yValue = data[1];
                                  return yValue < temp ? temp : yValue;
                                },
                                dataLabelMapper: (data, _) =>
                                    data[1].toString(),
                                pointColorMapper: (data, _) => data[2]
                                    ? Colors.green
                                    : Color.fromARGB(255, 164, 159, 159),
                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  labelAlignment:
                                      ChartDataLabelAlignment.bottom,
                                  textStyle: fontVaike,
                                  angle: 270,
                                ),
                              ),
                              LineSeries(
                                dataSource: keskHind.values.toList(),
                                xValueMapper: (inf, _) => inf[0],
                                yValueMapper: (inf, _) => inf[1],
                                dataLabelMapper: (inf, _) => inf[2],
                                color: Colors.red,
                                dashArray: [20, 22],
                                dataLabelSettings: DataLabelSettings(
                                  offset: Offset(-20, 0),
                                  isVisible: true,
                                  labelAlignment:
                                      ChartDataLabelAlignment.middle,
                                  textStyle: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 231, 17, 17)),
                                  angle: 270,
                                  alignment: ChartAlignment.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: kinnitusNahtav,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    alignment: Alignment.center,
                    width: sinineKastLaius,
                    height: sinineKastKorgus,
                  ),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: kinnitusNahtav,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                if (tana == green) {
                  gen1GraafikLoomine(
                      lulitus, 'täna', SeadmeteMap[seadmeNimi]![1]);
                } else {
                  gen1GraafikLoomine(
                      lulitus, 'homme', SeadmeteMap[seadmeNimi]![1]);
                }
                HapticFeedback.vibrate();
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: sinineKast,
                ),
                width: sinineKastLaius,
                height: sinineKastKorgus,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(text: 'Kinnita', style: fontSuur),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

eskmineHindArvutaus(Map<int, dynamic> lulitus) {
  double summa = 0;

  double AVG;

  int hindNr = 0;

  num mod = pow(10.0, 2);

  lulitus.values.forEach((data) {
    summa += data[1];

    hindNr++;
  });

  AVG = summa / hindNr;

  if (hindNr > 0) {
    return ((AVG * mod).round().toDouble() / mod);
  } else {
    return 0;
  }
}

keskmineHindMapVaartustamine(
    var hindAVG, Map<int, dynamic> keskHind, Map<int, dynamic> lulitus) {
  String kell = '00';

  int madalaimTund = 0;

  int tund = 0;

  for (var entry in lulitus.entries) {
    double price = entry.value[1];

    if (price < madalaimTund) {
      madalaimTund = tund;
    }
  }

  keskHind[0] = [kell + '.00', hindAVG, 'Keskmine hind'];

  for (int i = 1; i < 24; i++) {
    if (i < 10) {
      kell = '0$i';
    } else {
      kell = '$i';
    }

    keskHind[i] = [kell + '.00', hindAVG, ''];

    if (tund == i) {
      keskHind[tund] = [kell + '.00', hindAVG, ''];
    }
  }

  kell = '24.00';

  keskHind[24] = [kell + '.00', hindAVG, ''];

  kell = '25.00';

  keskHind[25] = [kell + '.00', hindAVG, ''];

  keskHind.forEach((key, value) {});

  return keskHind;
}

TunniVarviMuutus(int? rowIndex, Map<int, dynamic> lulitusMap2) {
  if (lulitusMap2[rowIndex][2] == false) {
    lulitusMap2[rowIndex][2] = true;
  } else {
    lulitusMap2[rowIndex][2] = false;
  }
  return lulitusMap2;
}

paevaMuutmine(String paevNupp) {
  if (paevNupp == 'Täna') {
    paevNupp = 'Homme';
  } else if (paevNupp == 'Homme') {
    paevNupp = 'Täna';
  }
  return paevNupp;
}

loeSeadmeOlek(Map<String, List<String>> SeadmeteMap, SeadmeNimi) {
  List<String>? deviceInfo = SeadmeteMap[SeadmeNimi];
  if (deviceInfo != null) {
    String status = deviceInfo[2];
    return status;
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
      lulitamine(deviceInfo[1]);
    } else if (status == 'off') {
      deviceInfo[2] = 'on';
      SeadmeteMap[SeadmeNimi] = deviceInfo;
      lulitamine(deviceInfo[1]);
    }
    return SeadmeteMap;
  }
  return SeadmeteMap; // Device key not found in the map
}

maxLeidmine(Map<int, dynamic> map) {
  double highest = 0;

  map.forEach((key, value) {
    double doubleValue = value[1] as double;

    if (doubleValue > highest) {
      highest = doubleValue;
    }
  });

  return highest;
}

minLeidmine(Map<int, dynamic> map) {
  double highest = 1000000;

  map.forEach((key, value) {
    double doubleValue = value[1] as double;

    if (doubleValue < highest) {
      highest = doubleValue;
    }
  });

  return highest;
}

Future graafik(
    Map<String, List<String>> SeadmeteMap, String seadmeNimi, lulitus) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  []; //Võtab mälust 'users'-i asukohast väärtused
  var seadmedJSONmap = prefs.getString('seadmed');
  String value = SeadmeteMap[seadmeNimi]![1];
  Map<String, dynamic> storedMap = json.decode(seadmedJSONmap!);

  String? storedKey = prefs.getString('key');

  String storedKeyString = jsonDecode(storedKey!);
  var j = 0;
  var authKey = storedKeyString;
  // ignore: unused_local_variable
  for (var i in storedMap.values) {
    if (storedMap['Seade$j']['Seadme_ID'] == value) {
      var seadeGen = storedMap['Seade$j']['Seadme_generatsioon'] as int;

      if (seadeGen == 1) {
        DateTime now = DateTime.now();
        int tana = now.weekday;
        if (tana == 7) {
          tana = 0;
        }
        List<String> newList = [];
        var headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
        };

        var data = {
          'channel': '0',
          'id': value,
          'auth_key': authKey,
        };

        var url =
            Uri.parse('https://shelly-64-eu.shelly.cloud/device/settings');
        var res = await http.post(url, headers: headers, body: data);
        await Future.delayed(const Duration(seconds: 2));
        //Kui post läheb läbi siis:

        final httpPackageJson = json.decode(res.body) as Map<String, dynamic>;

        var scheduleRules1 = httpPackageJson['data']['device_settings']
            ['relays'][0]['schedule_rules'];
        for (String item in scheduleRules1) {
          List<String> parts = item.split('-');
          if (parts[1].length > 1) {
            for (int i = 0; i < parts[1].length; i++) {
              //lülituskäsk tehakse iga "-" juures pooleks ja lisatakse eraldi listi
              String newItem = '${parts[0]}-${parts[1][i]}-${parts[2]}';
              newList.add(newItem);
            }
          } else {
            newList.add(item);
          }
        }
        List<String> filteredRules = [];

        RegExp regExp = RegExp("-$tana-");

        for (var rule in newList) {
          if (regExp.hasMatch(rule)) {
            filteredRules.add(rule);
          }
        }

        var i = 0;

        i = filteredRules.length;
        var u = 0;

        bool k = false;
        for (var j = 0; j < 24; j++) {
          String asendus = '$j';
          if (j < 10) {
            asendus = '0' + asendus + '00';
          } else {
            asendus = asendus + '00';
          }
          for (u = 0; u < i; u++) {
            List<String> parts = filteredRules[u].split('-');

            String timeString = parts[0];
            String formattedTime =
                timeString.substring(0, 2) + timeString.substring(2);
            if (formattedTime == asendus) {
              if (parts[2] == 'on') {
                lulitus[j][2] = true;
                k = true;
              } else {
                lulitus[j][2] = false;
                k = false;
              }
              break;
            } else {
              if (j != 0) {
                lulitus[j][2] = lulitus[j - 1][2];
              }
            }
          }
        }
        ;
      }
      break;
    }
    j++;
  }

  return lulitus;
}
