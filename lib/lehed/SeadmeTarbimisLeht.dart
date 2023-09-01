import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testuus4/lehed/AbiLeht.dart';
import 'package:testuus4/lehed/SeadmeGraafikLeht.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:testuus4/funktsioonid/KeskmineHind.dart';
import 'package:testuus4/funktsioonid/hetketarbimine.dart';
import 'package:testuus4/funktsioonid/tarbimine.dart';
import 'package:testuus4/funktsioonid/maksumus.dart';
import 'package:testuus4/lehed/koduleht.dart';
import '../funktsioonid/hetke_hind.dart';
import 'package:testuus4/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:testuus4/main.dart';
import 'SeadmeYldInfo.dart';

class SeadmeTarbimineLeht extends StatefulWidget {
  const SeadmeTarbimineLeht({Key? key, required this.seadmeNimi})
      : super(key: key);

  final String seadmeNimi;

  @override
  _SeadmeTarbimineLehtState createState() =>
      _SeadmeTarbimineLehtState(seadmeNimi: seadmeNimi);
}

class _SeadmeTarbimineLehtState extends State<SeadmeTarbimineLeht> {
  _SeadmeTarbimineLehtState({Key? key, required this.seadmeNimi});
  final String seadmeNimi;
  late Map<int, dynamic> lulitusMap;
  int selectedRowIndex = -1;
  late double hindAVG;
  String paevNupp = 'Täna';
  String selectedPage = 'Tarbimisgraafik';

  String onoffNupp = 'Shelly ON';

  int koduindex = 1;

  int onTunnidSisestatud = 0;

  var hetkeHind = '0';

  var hetkevoismus = '0';

  var ajatarbimine = '0';

  var kulu = '0';
  bool isLoading = false;
  String selectedOption = 'Nädala';
  List<String> dropdownOptions = ['Nädala', 'Kuu', 'Aasta'];
  double vahe = 20;

  Color boxColor = sinineKast;

  TextStyle fontLaadimine() {
    return GoogleFonts.roboto(
      textStyle: TextStyle(
        fontSize: 20,
        color: isLoading ? Colors.grey : Colors.black,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  BorderRadius borderRadius = BorderRadius.circular(5.0);

  Border border = Border.all(
    color: const Color.fromARGB(255, 0, 0, 0),
    width: 2,
  );
//Lehe avamisel toob hetke hinna ja tundide arvu

  @override
  void initState() {
    super.initState();
    _getCurrentPrice();
  }

//Toob tunnid mälust

  //Lisab tundide arvule ühe juurde

  //Võtab Eleringi API-st hetke hinna

  Future<void> _getCurrentPrice() async {
    getKeskmineHind(); //testimiseks
    setState(() {
      isLoading =
          true; //Enne hinna saamist kuvab ekraanile laadimis animatsiooni
    });
    final hetkeW = await voimus();
    final data =
        await getCurrentPrice(); //Kutsub esile CurrentPrice funktsiooni

    //TODO: Lisada käibemaks ja võrguteenustasud
    final test = await tarbimine();
    print(test);
    isLoading = false;

    //Võtab data Mapist 'price' väärtuse

    var ajutine = data.entries.toList();

    var ajutine1 = ajutine[1].value;

    double price = ajutine1[0]['price'];
    print('price: $price');
    price = price / 1000.0;

    num n = num.parse(price.toStringAsFixed(4));
    price = n as double;
    print('price: $price');
    setState(() {
      hetkeHind = price.toString();
      //Salvestab pricei hetke hinnaks
      hetkevoismus = hetkeW.toString();
      ajatarbimine = test.toString();
    });
    final temp = await maksumus(selectedOption);
    setState(() {
      kulu = temp.toString(); //Pärast hinna saamist laadimis animatsioon lõppeb
    });
  }

  Map<String, List<String>> SeadmeteMap = {
    'Keldri boiler': [
      'assets/boiler1.jpg',
      '123456',
      'off',
      'Shelly plug S',
    ],
    'Veranda lamp': [
      'assets/verandaLamp1.png',
      '123456',
      'offline',
      'Shelly plug S',
    ],
    'veranda lamp': [
      'assets/verandaLamp1.png',
      '123456',
      'on',
      'Shelly plug S',
    ],
    'Keldri pump': [
      'assets/pump1.jpg',
      '123456',
      'on',
      'Shelly plug S',
    ],
    'Garaazi pump': [
      'assets/pump1.jpg',
      '123456',
      'offline',
      'Shelly plug S',
    ],
    'Main boiler': [
      'assets/boiler1.jpg',
      '123456',
      'on',
      'Shelly plug S',
    ],
    'Sauna boiler': [
      'assets/boiler1.jpg',
      '123456',
      'off',
      'Shelly plug S',
    ],
  };

  Future norm() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 189, 216, 225), //TaustavÃ¤rv

        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 115, 162, 195),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(seadmeNimi),
              Spacer(),
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
                                SeadmeTarbimineLeht(seadmeNimi: seadmeNimi)),
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
                  items: <String>[
                    'Lülitusgraafik',
                    'Tarbimisgraafik',
                    'Üldinfo'
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
        body: Column(
          children: [
            SizedBox(height: vahe),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: borderRadius,
                  border: border,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(3, 3),
                    ),
                  ],
                ),
                width: sinineKastLaius,
                height: sinineKastKorgus + 20,
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(text: '  Seadme olek:    ', style: font),
                          TextSpan(
                            text: SeadmeteMap[seadmeNimi]![2],
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
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
                        icon:
                            loeSeadmeOlek(SeadmeteMap, seadmeNimi) == 'offline'
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
            SizedBox(height: vahe),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: borderRadius,
                  border: border,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(3, 3),
                    ),
                  ],
                ),
                width: sinineKastLaius,
                height: sinineKastKorgus,
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(text: '  Hetke hind: ', style: font),
                      TextSpan(
                          text: '$hetkeHind €/kWh', style: fontLaadimine()),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: vahe), // Add some spacing between the two widgets
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: borderRadius,
                  border: border,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(3, 3),
                    ),
                  ],
                ),
                width: sinineKastLaius,
                height: sinineKastKorgus,
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(text: 'Seadme hetke tarbimine: ', style: font),
                      TextSpan(text: '$hetkevoismus W', style: fontLaadimine()),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: vahe), // Add some spacing between the two widgets
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: borderRadius,
                  border: border,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(3, 3),
                    ),
                  ],
                ),
                width: sinineKastLaius,
                height: sinineKastKorgus,
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(text: '  Seadme kuu tarbimine: ', style: font),
                      TextSpan(
                          text: '$ajatarbimine kWh', style: fontLaadimine()),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: vahe), // Add some spacing between the two widgets
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: borderRadius,
                  border: border,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(3, 3),
                    ),
                  ],
                ),
                width: sinineKastLaius,
                height: sinineKastKorgus,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton<String>(
                      underline: Container(
                        // Replace the default underline
                        height: 0,

                        color: Colors.black, // Customize the underline color
                      ),
                      dropdownColor: sinineKast,
                      borderRadius: borderRadius,
                      value: selectedOption,
                      icon: const Icon(Icons.expand_circle_down_outlined,
                          color: Color.fromARGB(255, 0, 0, 0)),
                      onChanged: (String? newValue) async {
                        // Use an async function
                        setState(() {
                          selectedOption = newValue!;
                          isLoading = true; // Show the loading animation

                          // Call the async function and wait for the result
                          maksumus(selectedOption).then((result) {
                            setState(() {
                              kulu = result.toString();
                              isLoading = false; // Hide the loading animation
                            });
                          });
                        });
                      },
                      items: dropdownOptions
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text('  ' + value + ' maksumus:', style: font),
                        );
                      }).toList(),
                    ),
                    Text(" $kulu €", style: fontLaadimine()),
                  ],
                ),
              ),
            ),
            SizedBox(height: vahe),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: borderRadius,
                  border: border,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(3, 3),
                    ),
                  ],
                ),
                width: sinineKastLaius,
                height: sinineKastKorgus,
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(text: '  Tarbimise Graafik ', style: font),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: EGraafik(value: '80646f81ad9a'),
            ),
          ],
        ),
      ),
    );
  }
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
    } else if (status == 'off') {
      deviceInfo[2] = 'on';
      SeadmeteMap[SeadmeNimi] = deviceInfo;
    }
    return SeadmeteMap;
  }
  return SeadmeteMap; // Device key not found in the map
}

class EGraafik extends StatefulWidget {
  final String value;

  EGraafik({required this.value});
  @override
  _EGraafikState createState() => _EGraafikState();
}

class _EGraafikState extends State<EGraafik> {
  List<_ChartData> chartData = [];
  bool graafik = false;
  String total = '';
  Future<void> fetchData(value) async {
    DateTime currentDateTime = DateTime.now();

    // Calculate the first day of the current month
    DateTime firstDayOfMonth =
        DateTime(currentDateTime.year, currentDateTime.month);

    // Calculate the last day of the current month
    DateTime lastDayOfMonth =
        DateTime(currentDateTime.year, currentDateTime.month + 1, 0);

    // Create the list of _ChartData objects with dates and initial consumption values of 0
    setState(() {
      total = '';
      for (DateTime date = firstDayOfMonth;
          date.isBefore(lastDayOfMonth);
          date = date.add(Duration(days: 1))) {
        chartData.add(_ChartData(date, 0.0));
      }
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ajutineKasutajanimi = prefs.getString('Kasutajanimi');
    String? sha1Hash = prefs.getString('Kasutajaparool');

    var headers1 = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    var kasutajaAndmed = {
      'email': ajutineKasutajanimi,
      'password': sha1Hash,
      'var': '2',
    };
    var sisselogimiseUrl = Uri.parse('https://api.shelly.cloud/auth/login');
    var sisselogimiseVastus = await http.post(sisselogimiseUrl,
        headers: headers1, body: kasutajaAndmed);
    var vastusJSON =
        json.decode(sisselogimiseVastus.body) as Map<String, dynamic>;
    var token = vastusJSON['data']['token'];
    //Todo peab lisama beareri saamise
    var headers = {
      'Authorization': 'Bearer $token',
    };
    var data = {
      'id': value,
      'channel': '0',
      'date_range': 'custom',
      'date_from': '2023-08-01 00:00:00',
      'date_to': '2023-08-31 23:59:59',
    };

    var url = Uri.parse(
        'https://shelly-64-eu.shelly.cloud/statistics/relay/consumption');
    var res = await http.post(url, headers: headers, body: data);
    if (res.statusCode != 200)
      throw Exception('http.post error: statusCode= ${res.statusCode}');
    final jsonData = json.decode(res.body);
    final historyData = jsonData['data']['history'] as List<dynamic>;
    print(historyData);
    setState(() {
      chartData = historyData
          .map((history) => _ChartData(DateTime.parse(history['datetime']),
              history['consumption'].toDouble()))
          .toList();
      total = jsonData['data']['total'].toString();
    });

    print(chartData);
    print('total');
    print(jsonData['data']['history'][1]['consumption']);
    print(jsonData['data']['total']);
    String dataString = jsonEncode(jsonData['data']['history']);
    prefs.setString('consumption', dataString);
    prefs.setString('total', total);

    print('$total ososo');
    print(prefs.getString('consumption'));
    
  }

  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, header: 'Tarbitud:');

    fetchData(widget.value);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Align(
        child: Container(
          alignment: Alignment.center,
    
          //width: sinineKastLaius,
          //height: sinineKastKorgus,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: font,
              children: [
                TextSpan(text: 'Seadme tarbimine', style: fontSuur),
              ],
            ),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [],
        ),
      ),
      Align(
        child: Visibility(
            visible: graafik,
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    graafik = !graafik;
                  });
                },
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.show_chart_rounded,
                      size: 30,
                    ),
                  ),
                ))),
      ),
      Align(
        child: Visibility(
            visible: !graafik,
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    graafik = !graafik;
                  });
                },
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.bar_chart,
                      size: 30,
                    ),
                  ),
                ))),
      ),
      Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Center(
            child: Column(children: [
              Align(
                child: Container(
                  alignment: Alignment.center,
    
                  //width: sinineKastLaius,
                  //height: sinineKastKorgus,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: font,
                      children: [
                        TextSpan(text: 'Kokku: $total Wh', style: font),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !graafik,
                child: Container(
                  height: MediaQuery.of(context).size.height *
                      chartData.length *
                      0.0115,
                  child: SfCartesianChart(
                    primaryXAxis: DateTimeAxis(
                      minimum: chartData.first.date,
                      maximum: chartData.last.date,
                      labelStyle: fontVaike,
                      dateFormat: DateFormat('dd.MM'),
                    ),
                    primaryYAxis: NumericAxis(
                      title: AxisTitle(
                        text: 'Wh',
                        textStyle: fontVaike,
                      ),
                      labelStyle: fontVaike,
                      /*labelFormat: 'Wh',
                              labelRotation: 90,*/
                    ),
                    tooltipBehavior: _tooltipBehavior,
                    series: <ChartSeries<_ChartData, DateTime>>[
                      SplineSeries<_ChartData, DateTime>(
                        splineType: SplineType.cardinal,
                        dataSource: chartData,
                        xValueMapper: (_ChartData data, _) => data.date,
                        yValueMapper: (_ChartData data, _) => data.consumption,
                        enableTooltip: true,
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: graafik,
                child: Container(
                  height: MediaQuery.of(context).size.height *
                      chartData.length *
                      0.0115,
                  child: SfCartesianChart(
                    primaryXAxis: DateTimeAxis(
                        labelStyle: fontVaike,
                        /*title: AxisTitle(
                                  text: 'Kuupäev',
                                  textStyle: fontVaike,
                                ),*/
                        dateFormat: DateFormat('dd.MM'),
                        //interval: 5,
    
                        //maximumLabels: 5,
                        maximum: chartData.last.date,
                        minimum: chartData.first.date),
                    primaryYAxis: NumericAxis(
                      title: AxisTitle(
                        text: 'Wh',
                        textStyle: fontVaike,
                      ),
                      labelStyle: fontVaike,
                      isVisible: true,
                    ),
                    tooltipBehavior: _tooltipBehavior,
                    series: <ChartSeries<_ChartData, DateTime>>[
                      ColumnSeries<_ChartData, DateTime>(
                        dataSource: chartData,
                        xValueMapper: (_ChartData data, _) => data.date,
                        yValueMapper: (_ChartData data, _) => data.consumption,
                        enableTooltip: true,
                        dataLabelSettings: DataLabelSettings(
                          offset: Offset(0, 5),
                          isVisible: true,
                          labelAlignment: ChartDataLabelAlignment.outer,
                          textStyle: fontVaike,
                          angle: 270,
                        ),
                        dataLabelMapper: (_ChartData data, _) {
                          // Display the data label only if the consumption is not 0
                          if (data.consumption == 0) {
                            return ''; // Customize this as needed
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ))
    ]);
  }
}

class _ChartData {
  _ChartData(this.date, this.consumption);

  final DateTime date;
  final double consumption;
}
