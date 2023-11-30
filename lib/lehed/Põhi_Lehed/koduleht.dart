import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:testuus4/funktsioonid/tarbimine.dart';
import 'package:testuus4/lehed/tarbimiseGraafik.dart';
import 'package:testuus4/lehed/tarbimiseGraafikSpline.dart';
import 'package:testuus4/main.dart';
import 'dynamicKoduLeht.dart';
import '../maksumuseGraafik.dart';
import 'package:table_calendar/table_calendar.dart';

bool tarbimineBoolChart = true;
bool tarbimineBoolStacked = false;
bool tarbimineBoolSpline = false;
DateTime firstDayOfMonth = DateTime(DateTime.now().year, DateTime.now().month);

// Calculate the last day of the current month
DateTime lastDayOfMonth = DateTime.now();
//DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

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
  DateTime firstDay = DateTime.utc(2021, 1, 1);
  DateTime lastDay = DateTime(DateTime.now().year, DateTime.now().month, 30);
  String onoffNupp = 'Shelly ON';

  bool showCalendar = false;

  int koduindex = 1;

  int onTunnidSisestatud = 0;

  var hetkeHind = '0';

  var hetkevoismus = '0';

  var ajatarbimine = '0';

  var kulu = '0';
  bool isLoading = false;
  String selectedOption = 'Kuu';

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
    setState(() {
      tarbimiseMap = tarbimiseMap1;
    });
  }

  Future<void> _getCurrentPrice() async {
    //getKeskmineHind(); //testimiseks

    var test = await tarbimine(tarbimiseMap, updateTarbimine);

    num k = num.parse(test.toStringAsFixed(4));
    //Võtab data Mapist 'price' väärtuse

    setState(() {
      dataFetched = true;
      ajatarbimine = k.toString();
    });
    // final temp = await maksumus(selectedOption);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          showCalendar = !showCalendar;
                        });
                      },
                      icon: const Icon(
                        Icons.calendar_month,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          tarbimineBoolChart = true;
                          tarbimineBoolSpline = false;
                          tarbimineBoolStacked = false;
                        });
                      },
                      icon: Transform.rotate(
                        angle: pi / 2,
                        child: const Icon(
                          Icons.bar_chart_rounded,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          tarbimineBoolChart = false;
                          tarbimineBoolSpline = true;
                          tarbimineBoolStacked = false;
                        });
                      },
                      icon: const Icon(
                        Icons.show_chart_rounded,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          tarbimineBoolChart = false;
                          tarbimineBoolSpline = false;
                          tarbimineBoolStacked = true;
                        });
                      },
                      icon: const Icon(
                        Icons.stacked_bar_chart_rounded,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${DateFormat('dd.MM.yyyy').format(firstDayOfMonth)} - ${DateFormat('dd.MM.yyyy').format(lastDayOfMonth)}",
                      style: fontVaike,
                    ),
                  ],
                )
              ],
            ),
            toolbarHeight: 60),
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
                    Visibility(
                      visible: showCalendar,
                      child: Column(
                        children: [
                          TableCalendar(
                            //availableCalendarFormats: const {},
                            startingDayOfWeek: StartingDayOfWeek.monday,
                            rowHeight: 35,
                            firstDay: firstDay,
                            lastDay: DateTime.now(),
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
                          SizedBox(height: 8), // Adjust the height as needed
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(boxColor)),
                            onPressed: () {
                              // Handle the confirmation logic here
                              if (_rangeStart != null && _rangeEnd != null) {
                                // Perform the desired action with the selected range
                                setState(() {
                                  firstDayOfMonth = _rangeStart!;
                                  lastDayOfMonth = _rangeEnd!;
                                });
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DynaamilenieKoduLeht(i: 0)),
                                );
                              } else {
                                // Inform the user that a valid range is required
                              }
                            },
                            child: Text(
                              'Kinnita vahemik',
                              style: fontVaike,
                            ),
                          ),
                        ],
                      ),
                    ),
                    //SizedBox(height: vahe / 4),

                    // Add some spacing between the two widgets
                    FutureBuilder<void>(
                      future: Future.value(), // Use an empty future here
                      builder: (context, snapshot) {
                        if (!dataFetched) {
                          return const Center(
                              child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(),
                          ));
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          return TarbimiseGraafik(tarbimiseMap, ajatarbimine);
                        }
                      },
                    ),

                    // Add some spacing between the two widgets

                    //SizedBox(height: vahe / 8),
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
