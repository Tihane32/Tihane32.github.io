import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/funktsioonid/lulitamine.dart';
import 'package:testuus4/lehed/P%C3%B5hi_Lehed/dynamicKoduLeht.dart';
import 'package:testuus4/widgets/AbiLeht.dart';
import 'package:testuus4/lehed/Seadme_Lehed/SeadmeGraafikLeht.dart';
import 'package:testuus4/lehed/Seadme_Lehed/SeadmePildiMuutmine.dart';
import 'package:testuus4/lehed/TarbimisLeht.dart';
import 'package:testuus4/Arhiiv/seadmedKontoltNim.dart';
import 'package:testuus4/main.dart';
import '../../Arhiiv/SeadmeTarbimisLeht.dart';
import 'package:testuus4/parameters.dart';

class GruppiYldinfoLeht extends StatefulWidget {
  const GruppiYldinfoLeht({Key? key, required this.gruppNimi})
      : super(key: key);

  final String gruppNimi;
  @override
  _GruppiYldinfoLehtState createState() =>
      _GruppiYldinfoLehtState(gruppNimi: gruppNimi);
}

class _GruppiYldinfoLehtState extends State<GruppiYldinfoLeht> {
  _GruppiYldinfoLehtState({Key? key, required this.gruppNimi});
  String gruppNimi;
  late Map<int, dynamic> lulitusMap;
  int selectedRowIndex = -1;
  late double hindAVG;

  double vahe = 20;
  String gruppinimi = "";
  Color boxColor = sinineKast;

  BorderRadius borderRadius = BorderRadius.circular(5.0);

  Border border = Border.all(
    color: const Color.fromARGB(255, 0, 0, 0),
    width: 2,
  );
//Lehe avamisel toob hetke hinna ja tundide arvu

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    setState(() {
      gruppinimi = gruppNimi;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255), //TaustavÃ¤rv
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                    color: Color.fromARGB(0, 0, 0, 0),
                    width: 2,
                  ),
                ),
                width: sinineKastLaius,
                height: sinineKastKorgus,
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextField(
                      // Ensure that the style is applied to the TextField
                      style: font, // Apply your TextStyle here
                      // textAlignVertical: TextAlignVertical.center,
                      // cursorWidth: 0,
                      onSubmitted: (value) {
                        /*
                        setState(() {
                          uusNimi = value;

                          nimeMuutmine(seadmeNimi, uusNimi);
                          seadmeNimi = uusNimi;
                        });*/
                      },
                      decoration: InputDecoration(
                        hintText: '$gruppNimi',
                        hintStyle: font,
                        floatingLabelStyle: font,
                      ),
                    ),
                  ),
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
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: Color.fromARGB(0, 0, 0, 0),
                      width: 2,
                    )),
                width: sinineKastLaius,
                height: sinineKastKorgus,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: RichText(
                        text: TextSpan(
                          style: font,
                          children: [
                            TextSpan(text: 'Gruppi pilt:', style: font),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.all(0.0),
                        iconSize: 30,
                        onPressed: () {
                          /*
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DunaamilineSeadmeLeht(
                                seadmeNimi: seadmeNimi,
                                SeadmeteMap: SeadmeteMap,
                                valitud: 3,
                              ),
                            ),
                          );*/
                        },
                        icon: Icon(
                          Icons.photo_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: vahe), // Add some spacing between the two widgets
            Visibility(
              visible: gruppNimi != 'Kõik Seadmed',
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: boxColor,
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                        color: Color.fromARGB(0, 0, 0, 0),
                        width: 2,
                      )),
                  width: sinineKastLaius,
                  height: sinineKastKorgus,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: RichText(
                          text: TextSpan(
                            style: font,
                            children: [
                              TextSpan(text: 'Kustuta grupp', style: font),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          padding: EdgeInsets.all(0.0),
                          iconSize: 30,
                          onPressed: () {
                            gruppiMap.remove(gruppNimi);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DynaamilenieKoduLeht(i: 1),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.photo_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
