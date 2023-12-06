import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/widgets/AbiLeht.dart';
import 'package:testuus4/lehed/Seadme_Lehed/SeadmeGraafikLeht.dart';
import 'package:testuus4/lehed/TarbimisLeht.dart';
import 'package:testuus4/lehed/P%C3%B5hi_Lehed/dynamicKoduLeht.dart';
import 'package:testuus4/main.dart';
import 'GrupiSeadmed.dart';import 'package:testuus4/parameters.dart';
import '../Seadme_Lehed/SeadmePildiMuutmine.dart';
import '../Seadme_Lehed/SeadmeYldInfo.dart';
import 'gruppiKoostamine.dart';

class DunaamilineGrupiLeht extends StatefulWidget {
  DunaamilineGrupiLeht(
      {Key? key, required this.gruppNimi, required this.valitud})
      : super(key: key);

  final String gruppNimi;
  int valitud;
  @override
  _DunaamilineGrupiLehtState createState() =>
      _DunaamilineGrupiLehtState(gruppNimi: gruppNimi, valitud: valitud);
}

class _DunaamilineGrupiLehtState extends State<DunaamilineGrupiLeht> {
  _DunaamilineGrupiLehtState(
      {Key? key, required this.gruppNimi, required this.valitud});
  String gruppNimi;
  int valitud;
  String selectedPage = 'Lülitusgraafik';

  Color boxColor = sinineKast;
  int koduindex = 1;
  String uusPilt = "";
  late final List<Widget> lehedSeadme;

  pilt(pilt) {
    setState(() {
      uusPilt = pilt;
    });
  }

  @override
  void initState() {
    super.initState();
    if (valitud == 3) {
      selectedPage = "Seaded";
    }
    lehedSeadme = [
      AbiLeht(),
      AbiLeht(),
      GruppiSeadmed(gruppNimi: gruppNimi),
      AbiLeht(),
      GruppiKoostamine(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255), //TaustavÃ¤rv

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 115, 162, 195),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DynaamilenieKoduLeht(
                        i: 1,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_back)),
            Text(
              gruppNimi,
              style: GoogleFonts.roboto(
                textStyle: const TextStyle(fontSize: 25),
              ),
            ),
            const Spacer(),
          ],
        ),
        actions: valitud == 4
            ? []
            : [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: boxColor,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: DropdownButton<String>(
                      icon: const Icon(Icons.menu),
                      value: selectedPage,
                      style: font,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedPage = newValue!;
                        });
                        if (selectedPage == 'Lülitusgraafik') {
                          valitud = 0;
                        } else if (selectedPage == 'Tarbimisgraafik') {
                          valitud = 1;
                        } else if (selectedPage == 'Seadmed') {
                          valitud = 2;
                          print(gruppiMap);
                          print(seadmeteMap);
                        } else if (selectedPage == 'Sätted') {
                          valitud = 3;
                        }
                      },
                      underline: Container(),
                      items: <String>[
                        'Lülitusgraafik',
                        'Tarbimisgraafik',
                        'Seadmed',
                        'Sätted'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
      ),
      body: IndexedStack(
        index: valitud,
        children: lehedSeadme,
      ),
      bottomNavigationBar: Visibility(
        visible: valitud == 3,
        child: BottomNavigationBar(
            backgroundColor: const Color.fromARGB(255, 115, 162, 195),
            fixedColor: const Color.fromARGB(255, 157, 214, 171),
            unselectedItemColor: Colors.white,
            selectedIconTheme: const IconThemeData(size: 40),
            unselectedIconTheme: const IconThemeData(size: 30),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                label: 'Tagasi',
                icon: Icon(
                  Icons.arrow_back,
                  size: 30,
                ),
              ),
              BottomNavigationBarItem(
                label: 'Kinnita',
                icon: Icon(
                  Icons.check_circle_outlined,
                  size: 30,
                ),
              ),
            ],
            currentIndex: koduindex,
            onTap: (int kodu) {
              setState(() {
                koduindex = kodu;
                if (koduindex == 0) {
                } else if (koduindex == 1) {
                  //pildiMuutmine(seadmeNimi, uusPilt);
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Add some spacing between icon and text
                                    Text("Kinnitatud", style: fontSuur),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.check_circle_outline_outlined,
                                      size: 35,
                                    ),
                                  ],
                                ),
                                // Add other content of the dialog if needed
                              ],
                            ),
                          ));
                  HapticFeedback.vibrate();
                  Future.delayed(const Duration(seconds: 5), () {});
                }
              });
            }),
      ),
    );
  }
}
