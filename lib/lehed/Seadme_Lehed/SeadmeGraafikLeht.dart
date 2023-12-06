import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testuus4/funktsioonid/genMaaramine.dart';
import 'package:testuus4/funktsioonid/graafikGen1.dart';
import 'package:testuus4/funktsioonid/graafikGen2.dart';
import 'package:testuus4/widgets/AbiLeht.dart';
import 'package:testuus4/Arhiiv/SeadmeTarbimisLeht.dart';
import 'package:testuus4/lehed/Tundide_valimis_Lehed/Graafik_Seadmete_valik/DynaamilineGraafikusseSeadmeteValik.dart';
import 'package:testuus4/lehed/TarbimisLeht.dart';
import 'package:testuus4/lehed/P%C3%B5hi_Lehed/dynamicKoduLeht.dart';
import 'package:testuus4/lehed/Seadme_Lehed/dynamicSeadmeInfo.dart';
import '../../funktsioonid/KeskmineHindArvutus.dart';
import '../../widgets/kinnitus.dart';
import '../Tundide_valimis_Lehed/Graafik_Seadmete_valik/graafikuseSeadmeteValik_yksikud.dart';
import 'SeadmeYldInfo.dart';
import '../Põhi_Lehed/seadmeteListDynaamiline.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testuus4/Arhiiv/seadmedKontoltNim.dart';
import '../Põhi_Lehed/koduleht.dart';
import '../Tundide_valimis_Lehed/hinnaPiiriAluselTunideValimine.dart';
import 'dart:math';
import 'package:testuus4/Arhiiv/kaksTabelit.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:testuus4/main.dart';
import 'package:testuus4/funktsioonid/Elering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:testuus4/funktsioonid/lulitamine.dart';import 'package:testuus4/parameters.dart';
import 'package:testuus4/funktsioonid/token.dart';
import 'package:testuus4/main.dart';

class SeadmeGraafikuLeht extends StatefulWidget {
  const SeadmeGraafikuLeht(
      {Key? key, required this.seadmeNimi, required this.SeadmeteMap})
      : super(key: key);

  final String seadmeNimi;
  final Map<String, dynamic> SeadmeteMap;
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
  Map<String, dynamic> SeadmeteMap;
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

  Map<int, dynamic> keskHind = {};

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
   var data = await getElering(DateTime.now(),DateTime.now().add(Duration(days: 1)));
    
    for (var i = 0; i < 24; i++) {
      lulitusTana[i][1] = data[i];
    }

    if (date.hour >=
        15) //Kui kell on vähem, kui 15 või on saadetud String 'täna'
    {
      var data = await getElering(DateTime.now().add(Duration(days: 1)),DateTime.now().add(Duration(days: 2)));
      for (var i = 0; i < 24; i++) {
        lulitusHomme[i][1] = data[i];
      }
    }

    setState(() {
      if (date.hour >= 15) {
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
    });

    List<dynamic> graafik = [];
    if (seadmeteMap[seadmeNimi]["Seadme_generatsioon"] == 1) {
      graafik = await graafikGen1Lugemine(seadmeNimi);
    } else {
      graafik = await graafikGen2Lugemine(seadmeNimi);
      graafik = graafikGen2ToGraafikGen1(graafik);
    }

    int tana = getCurrentDayOfWeek();
    int homme = getTommorowDayOfWeek();

    List<int> paevadTana = [tana];
    List<dynamic> graafikTana = [];
    List<int> paevadHomme = [homme];
    List<dynamic> graafikHomme = [];
    graafikTana = graafikGen1Filtreerimine(graafik, paevadTana);
    graafikHomme = graafikGen1Filtreerimine(graafik, paevadHomme);
    setState(() {
      lulitus = graafikGen1ToLulitusMap(lulitus, graafikTana);
      lulitusHomme = graafikGen1ToLulitusMap(lulitusHomme, graafikHomme);
    });

    /*SharedPreferences prefs = await SharedPreferences.getInstance();

    []; //Võtab mälust 'users'-i asukohast väärtused
    var seadmedJSONmap = prefs.getString('seadmed');

    Map<String, dynamic> storedMap = json.decode(seadmedJSONmap!);

    String? storedKey = prefs.getString('key');
    int gen = 1;
    String storedKeyString = jsonDecode(storedKey!);
    var j = 0;
    var authKey = storedKeyString;
    // ignore: unused_local_variable

    var seadeGen = storedMap[seadmeNimi]['Seadme_generatsioon'] as int;

    if (seadeGen == 1) {
      lulitusHomme = await graafik(SeadmeteMap, seadmeNimi, lulitusHomme);
      gen = 1;
      DateTime now = DateTime.now();
      int tana = now.weekday - 1;

      List<String> newList = [];
      var headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      var data = {
        'channel': '0',
        'id': seadmeNimi,
        'auth_key': authKey,
      };

      var url = Uri.parse('https://shelly-64-eu.shelly.cloud/device/settings');
      var res = await http.post(url, headers: headers, body: data);
      await Future.delayed(const Duration(seconds: 2));
      //Kui post läheb läbi siis:

      final httpPackageJson = json.decode(res.body) as Map<String, dynamic>;

      var scheduleRules1 = httpPackageJson['data']['device_settings']['relays']
          [0]['schedule_rules'];
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
        gen = 1;
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
    } else {
      var graafikud = await gen2GraafikSaamine(seadmeNimi, lulitus, "tana");
      var graafikud1 =
          await gen2GraafikSaamine(seadmeNimi, lulitusHomme, "homme");
      setState(() {
        gen = 2;
        lulitus = graafikud;
        lulitusHomme = graafikud1;
      });
    }*/
  }

  @override
  void initState() {
    seadmeKinnitus = false;
    norm();

    super.initState();
  }

  int i = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Column(
          children: [
            SizedBox(height: vahe / 2),
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
                        Center(
                            child: hommeNahtav
                                ? GestureDetector(
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
                                          hindAVG =
                                              keskmineHindArvutaus(lulitus);
                                          keskHind =
                                              keskmineHindMapVaartustamine(
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
                                          borderRadius:
                                              BorderRadius.circular(30.0),
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
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: Text(
                                                    'Homne graafik ei ole hetkel kättesaadav\nProovige uuesti kell 15.00'),
                                              ));
                                    },
                                    child: Container(
                                      width: 100,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 209, 205, 205),
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          border: Border.all(
                                            color:
                                                Color.fromARGB(255, 12, 12, 12),
                                            width: 3,
                                          )),
                                      child: Center(
                                          child: RichText(
                                        text: TextSpan(
                                            text: 'Homme', style: font),
                                        textAlign: TextAlign.center,
                                      )),
                                    ),
                                  ))
                      ],
                    ),
                  ),
                  Center(
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
                                                text: '€/MWh',
                                                style: fontVaike),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
                                                text: 'Min: $hindMin',
                                                style: fontVaike),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
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
                                        style: fontVaikePunane,
                                        children: [
                                          TextSpan(
                                              text: 'Kesk: $hindAVG',
                                              style: fontVaikePunane),
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
                                              text: 'Max: $hindMax',
                                              style: fontVaike),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /*Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        child: Container(
                          alignment: Alignment.center,

                          //width: sinineKastLaius,
                          //height: sinineKastKorgus,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: fontVaike,
                                children: [
                                  TextSpan(text: '€/MWh', style: fontVaike),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),*/
                ],
              ),
            ),
          ],
        ),
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            height: MediaQuery.of(context).size.height,
            child: Center(
                child: RotatedBox(
              quarterTurns: 1,
              child: Container(
                //width: double.infinity,
                //height: double.infinity,
                child: SfCartesianChart(
                  axes: [
                    NumericAxis(
                      name: 'xAxis',
                      isVisible: false,
                      title: AxisTitle(
                        text: 'test',
                        textStyle: fontVaike,
                      ),
                    ),
                  ],
                  margin: EdgeInsets.all(0),
                  primaryXAxis: CategoryAxis(
                    majorGridLines: const MajorGridLines(width: 0),
                    interval: 1,
                    labelRotation: 270,
                    visibleMinimum: 0,
                    //maximum: 23.5,
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
                        int rowIndex = pointInteractionDetails.pointIndex!;
                        kinnitusNahtav = true;
                        setState(() {
                          lulitus[rowIndex][2] = !lulitus[rowIndex][2];
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
                      dataLabelMapper: (data, _) => data[1].toString(),
                      pointColorMapper: (data, _) => data[2]
                          ? Colors.green
                          : Color.fromARGB(255, 164, 159, 159),
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        labelAlignment: ChartDataLabelAlignment.bottom,
                        textStyle: fontVaike,
                        angle: 270,
                      ),
                    ),
                    LineSeries(
                      xAxisName: "xAxis",
                      dataSource: keskHind.entries.map((entry) {
                        final key = entry.key.toDouble();
                        final value = entry.value;
                        return {
                          'x': key,
                          'y': value
                        }; // Creating a map with 'x' and 'y' keys.
                      }).toList(),
                      xValueMapper: (data, _) =>
                          data['x'], // Access 'x' key from the map.
                      yValueMapper: (data, _) =>
                          data['y'], // Access 'y' key from the map.
                      color: Colors.red,
                      dashArray: [20, 22],
                    ),
                  ],
                ),
              ),
            )),
          ),
        ),
        /*Container(
          decoration: BoxDecoration(color: Colors.white),
          height: 60,
          child: Column(
            children: [
              SizedBox(height: vahe / 2),
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
                          Center(
                              child: hommeNahtav
                                  ? GestureDetector(
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
                                            hindAVG =
                                                keskmineHindArvutaus(lulitus);
                                            keskHind =
                                                keskmineHindMapVaartustamine(
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
                                            borderRadius:
                                                BorderRadius.circular(30.0),
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
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: Text(
                                                      'Homne graafik ei ole hetkel kättesaadav\nProovige uuesti kell 15.00'),
                                                ));
                                      },
                                      child: Container(
                                        width: 100,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 209, 205, 205),
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            border: Border.all(
                                              color: Color.fromARGB(
                                                  255, 12, 12, 12),
                                              width: 3,
                                            )),
                                        child: Center(
                                            child: RichText(
                                          text: TextSpan(
                                              text: 'Homme', style: font),
                                          textAlign: TextAlign.center,
                                        )),
                                      ),
                                    ))
                        ],
                      ),
                    ),
                    Center(
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
                                                  text: '€/MWh',
                                                  style: fontVaike),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
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
                                                  text: 'Min: $hindMin',
                                                  style: fontVaike),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
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
                                          style: fontVaikePunane,
                                          children: [
                                            TextSpan(
                                                text: 'Kesk: $hindAVG',
                                                style: fontVaikePunane),
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
                                                text: 'Max: $hindMax',
                                                style: fontVaike),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /*Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            child: Container(
                              alignment: Alignment.center,

                              //width: sinineKastLaius,
                              //height: sinineKastKorgus,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: fontVaike,
                                    children: [
                                      TextSpan(text: '€/MWh', style: fontVaike),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),*/
                  ],
                ),
              ),
            ],
          ),
        ),
        */
        Visibility(
          visible: kinnitusNahtav,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () async {
                if (tana == green) {
                  genMaaramine(lulitus, 'täna', seadmeNimi);
                } else {
                  genMaaramine(lulitus, 'homme', seadmeNimi);
                }

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
                while (seadmeKinnitus == false) {
                  await Future.delayed(Duration(seconds: 1));
                }
                Navigator.pop(context);
                Kinnitus(context, "Graafik seadmele saadetud");

                HapticFeedback.vibrate();
                Future.delayed(Duration(seconds: 5), () {
                  Navigator.of(context).pop(); // Close the AlertDialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DunaamilineSeadmeLeht(
                        seadmeNimi: seadmeNimi,
                        SeadmeteMap: SeadmeteMap,
                        valitud: 0,
                      ),
                    ),
                  );
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: sinineKast,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(
                        color: Color.fromARGB(41, 0, 0, 0),
                        width: 2,
                      )),
                  width: 200,
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
  print(hindAVG);
  for (int i = 0; i < 25;) {
    keskHind[i] = hindAVG;
    i++;
  }
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
    Map<String, dynamic> SeadmeteMap, String seadmeNimi, lulitus) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  []; //Võtab mälust 'users'-i asukohast väärtused
  var seadmedJSONmap = prefs.getString('seadmed');

  Map<String, dynamic> storedMap = json.decode(seadmedJSONmap!);

  String? storedKey = prefs.getString('key');

  String storedKeyString = jsonDecode(storedKey!);
  var j = 0;
  var authKey = storedKeyString;
  // ignore: unused_local_variable

  var seadeGen = storedMap[seadmeNimi]['Seadme_generatsioon'] as int;

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
      'id': seadmeNimi,
      'auth_key': authKey,
    };

    var url =
        Uri.parse('${seadmeteMap[seadmeNimi]["api_url"]}/device/settings');
    var res = await http.post(url, headers: headers, body: data);
    await Future.delayed(const Duration(seconds: 2));
    //Kui post läheb läbi siis:

    final httpPackageJson = json.decode(res.body) as Map<String, dynamic>;
    var scheduleRules1 = httpPackageJson['data']['device_settings']['relays'][0]
        ['schedule_rules'];
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

    j++;
  }

  return lulitus;
}
