import 'package:flutter/material.dart';
import 'package:testuus4/funktsioonid/KeskmineHind.dart';
import 'package:testuus4/Arhiiv/drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testuus4/funktsioonid/hetketarbimine.dart';
import 'package:testuus4/funktsioonid/tarbimine.dart';
import 'package:testuus4/funktsioonid/maksumus.dart';
import 'package:testuus4/lehed/tarbimiseGraafik.dart';
import 'package:testuus4/lehed/tarbimiseGraafikSpline.dart';
import '../../funktsioonid/hetke_hind.dart';
import 'package:testuus4/main.dart';
import 'dynamicKoduLeht.dart';
import 'minuPakett.dart';
import '../maksumuseGraafik.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../Arhiiv/navigationBar.dart';

class KoduLeht extends StatefulWidget {
  const KoduLeht({Key? key}) : super(key: key);

  @override
  State<KoduLeht> createState() => _KoduLehtState();
}

class _KoduLehtState extends State<KoduLeht> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .enforced; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime firstDay = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime lastDay = DateTime(DateTime.now().year, DateTime.now().month, 30);
  String onoffNupp = 'Shelly ON';
  bool tarbimineBool = true;
  int koduindex = 1;

  int onTunnidSisestatud = 0;

  var hetkeHind = '0';

  var hetkevoismus = '0';

  var ajatarbimine = '0';

  var kulu = '0';
  bool isLoading = false;
  String selectedOption = 'Kuu';
  List<String> dropdownOptions = ['Nädala', 'Kuu', 'Aasta'];
  String selectedOption2 = 'Kuu';
  List<String> dropdownOptions2 = [
    'Hetke',
    'Nädala',
    'Kuu',
  ];
  Map<String, dynamic> tarbimiseMap = {};
  double vahe = 20;

  Color boxColor = sinineKast;
  /*TextStyle font = GoogleFonts.roboto(
      textStyle: const TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 20,
  ));*/
  TextStyle fontLaadimine() {
    return GoogleFonts.roboto(
      textStyle: TextStyle(
        fontSize: 18,
        color: isLoading ? Colors.grey : Colors.black,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  bool dataFetched = false;
//Lehe avamisel toob hetke hinna ja tundide arvu

  @override
  void initState() {
    super.initState();
    _getCurrentPrice();
  }

//Toob tunnid mälust

  //Lisab tundide arvule ühe juurde

  //Võtab Eleringi API-st hetke hinna
  updateTarbimine(tarbimiseMap1) {
    print("update $tarbimiseMap1");
    setState(() {
      tarbimiseMap = tarbimiseMap1;
    });
    print("Tarbimine siin: $tarbimiseMap");
  }

  Future<void> _getCurrentPrice() async {
    //getKeskmineHind(); //testimiseks

    var test = await tarbimine(tarbimiseMap, updateTarbimine);
    print("test: $test");

    num k = num.parse(test.toStringAsFixed(4));
    //Võtab data Mapist 'price' väärtuse

    setState(() {
      dataFetched = true;
      ajatarbimine = k.toString();
    });
    // final temp = await maksumus(selectedOption);
  }

//Määrab kodulehe struktuuri
/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backround,
        body: GestureDetector(
          onHorizontalDragUpdate: (details) {
            int tundlikus = 8;
            if (details.delta.dx > -tundlikus) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DynaamilenieKoduLeht(i: 1)));
              // Right Swipe
            }
          },
          onVerticalDragUpdate: (details) {},
          child: SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                  /*image: DecorationImage(
                image: AssetImage('assets/tuulik7.jpg'),
                alignment: Alignment.bottomCenter,
              ),*/
                  ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TableCalendar(
                         //availableCalendarFormats: const {},
                        startingDayOfWeek :StartingDayOfWeek.monday,
                        rowHeight: 35,
                        firstDay: firstDay,
                        lastDay: lastDay,
                        focusedDay: _focusedDay,
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),
                        rangeStartDay: _rangeStart,
                        rangeEndDay: _rangeEnd,
                        calendarFormat: _calendarFormat,
                        rangeSelectionMode: _rangeSelectionMode,
                        onDaySelected: (selectedDay, focusedDay) {
                          if (!isSameDay(
                              _selectedDay, selectedDay)) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                              _rangeStart =
                                  null; // Important to clean those
                              _rangeEnd = null;
                              _rangeSelectionMode =
                                  RangeSelectionMode.toggledOff;
                            });
                          }
                        },
                        onRangeSelected: (start, end, focusedDay) {
                          setState(() {
                            _selectedDay = null;
                            _focusedDay = focusedDay;
                            _rangeStart = start;
                            _rangeEnd = end;
                            _rangeSelectionMode =
                                RangeSelectionMode.toggledOn;
                          });
                        },
                        onFormatChanged: (format) {
                          if (_calendarFormat != format) {
                            setState(() {
                              _calendarFormat = format;
                            });
                          }
                        },
                        onPageChanged: (focusedDay) {
                          _focusedDay = focusedDay;
                        },
                      ),
                      //SizedBox(height: vahe / 4),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: Colors.black,
                      ),
                      SizedBox(height: vahe / 4),
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
                                    style: font,
                                    children: [
                                      TextSpan(
                                          text: 'Kokku: $ajatarbimine kWh',
                                          style: fontLaadimine()),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        child: Visibility(
                          visible: tarbimineBool,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                tarbimineBool = !tarbimineBool;
                              });
                            },
                            child: Container(
                              alignment: Alignment.centerRight,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.show_chart_rounded,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        child: Visibility(
                          visible: !tarbimineBool,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                tarbimineBool = !tarbimineBool;
                              });
                            },
                            child: Container(
                              alignment: Alignment.centerRight,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.bar_chart_rounded,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Visibility(
                        visible: tarbimineBool,
                        child: Center(
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
                                      style: font,
                                      children: [
                                        TextSpan(text: 'kWh', style: fontVaike),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Add some spacing between the two widgets
                      FutureBuilder<void>(
                        future: Future.value(), // Use an empty future here
                        builder: (context, snapshot) {
                          if (!dataFetched) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else {
                            return Visibility(
                              visible: tarbimineBool,
                              child: TarbimiseGraafik(tarbimiseMap),
                            );
                          }
                        },
                      ),
                      Visibility(
                          visible: !tarbimineBool,
                          child: TarbimiseGraafikSpline()),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: Colors.black,
                      ),

                      // Add some spacing between the two widgets

                      SizedBox(height: vahe),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Align(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  
                                  //Text(" $kulu €", style: fontLaadimine()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      //SizedBox(height: vahe / 8),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: Colors.black,
                      ),
                      SizedBox(height: vahe / 4),

                      MaksumuseGraafik(),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backround,
        body: GestureDetector(
          onHorizontalDragUpdate: (details) {
            int tundlikus = 8;
            if (details.delta.dx > -tundlikus) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DynaamilenieKoduLeht(i: 1)));
              // Right Swipe
            }
          },
          onVerticalDragUpdate: (details) {},
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TableCalendar(
                      //availableCalendarFormats: const {},
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      rowHeight: 35,
                      firstDay: firstDay,
                      lastDay: lastDay,
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      rangeStartDay: _rangeStart,
                      rangeEndDay: _rangeEnd,
                      calendarFormat: _calendarFormat,
                      rangeSelectionMode: _rangeSelectionMode,
                      onDaySelected: (selectedDay, focusedDay) {
                        if (!isSameDay(_selectedDay, selectedDay)) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                            _rangeStart = null; // Important to clean those
                            _rangeEnd = null;
                            _rangeSelectionMode = RangeSelectionMode.toggledOff;
                          });
                        }
                      },
                      onRangeSelected: (start, end, focusedDay) {
                        setState(() {
                          _selectedDay = null;
                          _focusedDay = focusedDay;
                          _rangeStart = start;
                          _rangeEnd = end;
                          _rangeSelectionMode = RangeSelectionMode.toggledOn;
                        });
                      },
                      onFormatChanged: (format) {
                        if (_calendarFormat != format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        }
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                    ),
                    //SizedBox(height: vahe / 4),
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: Colors.black,
                    ),
                    SizedBox(height: vahe / 4),
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
                                  style: font,
                                  children: [
                                    TextSpan(
                                        text: 'Kokku: $ajatarbimine kWh',
                                        style: fontLaadimine()),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      child: Visibility(
                        visible: tarbimineBool,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              tarbimineBool = !tarbimineBool;
                            });
                          },
                          child: Container(
                            alignment: Alignment.centerRight,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.show_chart_rounded,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      child: Visibility(
                        visible: !tarbimineBool,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              tarbimineBool = !tarbimineBool;
                            });
                          },
                          child: Container(
                            alignment: Alignment.centerRight,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.bar_chart_rounded,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Visibility(
                      visible: tarbimineBool,
                      child: Center(
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
                                    style: font,
                                    children: [
                                      TextSpan(text: 'kWh', style: fontVaike),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Add some spacing between the two widgets
                    FutureBuilder<void>(
                      future: Future.value(), // Use an empty future here
                      builder: (context, snapshot) {
                        if (!dataFetched) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          return Visibility(
                            visible: tarbimineBool,
                            child: TarbimiseGraafik(tarbimiseMap),
                          );
                        }
                      },
                    ),
                    Visibility(
                        visible: !tarbimineBool,
                        child: TarbimiseGraafikSpline()),
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: Colors.black,
                    ),

                    // Add some spacing between the two widgets

                    SizedBox(height: vahe),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Align(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //Text(" $kulu €", style: fontLaadimine()),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    //SizedBox(height: vahe / 8),
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: Colors.black,
                    ),
                    SizedBox(height: vahe / 4),

                    MaksumuseGraafik(),

                    Container(
                      height: 1,
                      width: double.infinity,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
}
