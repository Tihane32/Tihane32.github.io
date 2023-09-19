import 'package:flutter/material.dart';
import 'package:testuus4/funktsioonid/KeskmineHind.dart';
import 'package:testuus4/lehed/drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testuus4/funktsioonid/hetketarbimine.dart';
import 'package:testuus4/funktsioonid/tarbimine.dart';
import 'package:testuus4/funktsioonid/maksumus.dart';
import 'package:testuus4/lehed/tarbimiseGraafik.dart';
import 'package:testuus4/lehed/tarbimiseGraafikSpline.dart';
import '../funktsioonid/hetke_hind.dart';
import 'package:testuus4/main.dart';
import 'dynamicKoduLeht.dart';
import 'minuPakett.dart';
import 'maksumuseGraafik.dart';

import 'navigationBar.dart';

class KoduLeht extends StatefulWidget {
  const KoduLeht({Key? key}) : super(key: key);

  @override
  State<KoduLeht> createState() => _KoduLehtState();
}

class _KoduLehtState extends State<KoduLeht> {
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

//Lehe avamisel toob hetke hinna ja tundide arvu

  @override
  void initState() {
    super.initState();
    _getCurrentPrice();
  }

//Toob tunnid mälust

  //Lisab tundide arvule ühe juurde

  //Võtab Eleringi API-st hetke hinna
  updateTarbimine(tarbimiseMap) {
    setState(() {
      tarbimiseMap = tarbimiseMap;
    });
  }

  Future<void> _getCurrentPrice() async {
    getKeskmineHind(); //testimiseks
    setState(() {
      isLoading =
          true; //Enne hinna saamist kuvab ekraanile laadimis animatsiooni
    });
    final hetkeW = await voimus();
    final data =
        await getCurrentPrice(); //Kutsub esile CurrentPrice funktsiooni


    var test = await tarbimine(tarbimiseMap, updateTarbimine);
    isLoading = false;
    num k = num.parse(test.toStringAsFixed(4));
    //Võtab data Mapist 'price' väärtuse

    var ajutine = data.entries.toList();

    var ajutine1 = ajutine[1].value;

    double price = ajutine1[0]['price'];
    price = price / 1000.0;
    price = price * 1.2;
    num n = num.parse(price.toStringAsFixed(4));
    price = n as double;

    setState(() {
      hetkeHind = price.toString();
      //Salvestab pricei hetke hinnaks
      hetkevoismus = hetkeW.toString();
      ajatarbimine = k.toString();
    });
   // final temp = await maksumus(selectedOption);
    setState(() {
     // kulu = temp.toString(); //Pärast hinna saamist laadimis animatsioon lõppeb
    });
  }

//Määrab kodulehe struktuuri

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
                padding: const EdgeInsets.fromLTRB(0, 14, 0, 8),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Align(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 2.0),
                                    child:
                                        Icon(Icons.expand_circle_down_outlined),
                                  ),
                                  DropdownButton<String>(
                                    underline: Container(
                                      // Replace the default underline
                                      height: 0,

                                      color: Colors
                                          .black, // Customize the underline color
                                    ),
                                    dropdownColor: sinineKast,
                                    borderRadius: borderRadius,
                                    value: selectedOption2,
                                    iconSize: 0,
                                    icon: const Icon(
                                        Icons.expand_circle_down_outlined,
                                        color: Color.fromARGB(0, 0, 0, 0)),
                                    onChanged: (String? newValue) async {
                                      // Use an async function
                                      setState(() {
                                        selectedOption2 = newValue!;
                                        /*isLoading =
                                            true; // Show the loading animation
      
                                        // Call the async function and wait for the result
                                        maksumus(selectedOption).then((result) {
                                          setState(() {
                                            kulu = result.toString();
                                            isLoading =
                                                false; // Hide the loading animation
                                          });
                                        });*/
                                      });
                                    },
                                    items: dropdownOptions2
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value + ' tarbimine',
                                            style: fontSuur),
                                      );
                                    }).toList(),
                                  ),
                                  //Text(" $kulu €", style: fontLaadimine()),
                                ],
                              ),
                            ),
                          ],
                        ),
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
                      Visibility(
                          visible: tarbimineBool,
                          child: TarbimiseGraafik(tarbimiseMap)),
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
                                  Padding(
                                    padding: const EdgeInsets.only(right: 2.0),
                                    child:
                                        Icon(Icons.expand_circle_down_outlined),
                                  ),
                                  DropdownButton<String>(
                                    underline: Container(
                                      // Replace the default underline
                                      height: 0,

                                      color: Colors
                                          .black, // Customize the underline color
                                    ),
                                    dropdownColor: sinineKast,
                                    borderRadius: borderRadius,
                                    value: selectedOption,
                                    iconSize: 0,
                                    icon: const Icon(
                                        Icons.expand_circle_down_outlined,
                                        color: Color.fromARGB(255, 0, 0, 0)),
                                    onChanged: (String? newValue) async {
                                      // Use an async function
                                      setState(() {
                                        selectedOption = newValue!;
                                        isLoading =
                                            true; // Show the loading animation

                                        // Call the async function and wait for the result
                                        maksumus(selectedOption).then((result) {
                                          setState(() {
                                            kulu = result.toString();
                                            isLoading =
                                                false; // Hide the loading animation
                                          });
                                        });
                                      });
                                    },
                                    items: dropdownOptions
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value + ' maksumus',
                                            style: fontSuur),
                                      );
                                    }).toList(),
                                  ),
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
}

/*
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuButtonTap;

  const MyAppBar({required this.onMenuButtonTap});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 115, 162, 195),
      title: Text(
        'Shelly app',
        style: GoogleFonts.roboto(
          textStyle: const TextStyle(fontSize: 25),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: onMenuButtonTap,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);*/
class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
}
