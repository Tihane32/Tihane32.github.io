import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testuus4/funktsioonid/graafikGen1.dart';
import 'package:testuus4/lehed/AbiLeht.dart';
import 'package:testuus4/lehed/SeadmeGraafikLeht.dart';
import 'package:testuus4/lehed/SeadmeTarbimisLeht.dart';
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

class TarbimisLeht extends StatefulWidget {
  const TarbimisLeht(
      {Key? key, required this.seadmeNimi, required this.SeadmeteMap})
      : super(key: key);

  final String seadmeNimi;
  final Map<String, List<String>> SeadmeteMap;
  @override
  _TarbimisLehtState createState() =>
      _TarbimisLehtState(seadmeNimi: seadmeNimi, SeadmeteMap: SeadmeteMap);
}

int koduindex = 2;

class _TarbimisLehtState extends State<TarbimisLeht> {
  _TarbimisLehtState(
      {Key? key, required this.seadmeNimi, required this.SeadmeteMap});
  Map<String, List<String>> SeadmeteMap;
  final String seadmeNimi;
  late Map<int, dynamic> lulitusMap;
  int selectedRowIndex = -1;
  late double hindAVG = 0;

  String selectedPage = 'Tarbimisgraafik';
  double vahe = 10;
  Color boxColor = sinineKast;
  BorderRadius borderRadius = BorderRadius.circular(5.0);
  Border border = Border.all(
    color: const Color.fromARGB(255, 0, 0, 0),
    width: 2,
  );

  @override
  void initState() {
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
                    if (selectedPage == 'Lülitusgraafik') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SeadmeGraafikuLeht(
                                  seadmeNimi: seadmeNimi,
                                  SeadmeteMap: SeadmeteMap,
                                )),
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
        body: Stack(
          children: [
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
                                    text: SeadmeteMap[seadmeNimi]![2],
                                    style: font),
                              ],
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
                    child: EGraafik(value: SeadmeteMap[seadmeNimi]![1]),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
