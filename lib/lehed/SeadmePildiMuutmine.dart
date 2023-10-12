import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/lehed/AbiLeht.dart';
import 'package:testuus4/lehed/SeadmeGraafikLeht.dart';
import 'package:testuus4/lehed/TarbimisLeht.dart';
import 'package:testuus4/Arhiiv/seadmedKontoltNim.dart';
import 'package:testuus4/main.dart';
import '../Arhiiv/SeadmeTarbimisLeht.dart';

class SeadmePildiMuutmine extends StatefulWidget {
  const SeadmePildiMuutmine(
      {Key? key,
      required this.seadmeNimi,
      required this.SeadmeteMap,
      required this.uusPilt,
      required this.pilt})
      : super(key: key);

  final String seadmeNimi;
  final Map<String, dynamic> SeadmeteMap;
  final String uusPilt;
  final Function pilt;
  @override
  _SeadmePildiMuutmineState createState() => _SeadmePildiMuutmineState(
      seadmeNimi: seadmeNimi,
      SeadmeteMap: SeadmeteMap,
      uusPilt: uusPilt,
      pilt: pilt);
}

class _SeadmePildiMuutmineState extends State<SeadmePildiMuutmine> {
  _SeadmePildiMuutmineState(
      {Key? key,
      required this.seadmeNimi,
      required this.SeadmeteMap,
      required this.uusPilt,
      required this.pilt});
  Function pilt;
  String seadmeNimi;
  String uusPilt;
  Map<String, dynamic> SeadmeteMap;
  late Map<int, dynamic> lulitusMap;
  int selectedRowIndex = -1;

  BorderRadius borderRadius = BorderRadius.circular(5.0);

  Border border = Border.all(
    color: const Color.fromARGB(255, 0, 0, 0),
    width: 2,
  );
//Lehe avamisel toob hetke hinna ja tundide arvu
  List<String> Pildid = [
    'assets/boiler1.jpg',
    'assets/pump1.jpg',
    'assets/verandaLamp1.png',
    'assets/aku1.jpg',
    'assets/MitsubishiIMiEv1.jpg',
    'assets/saun1.jpg',
    'assets/TeslaModel31.jpg',
    'assets/vesinik1.jpg',
  ];
  String algnePilt = '';

  @override
  void initState() {
    super.initState();
    algnePilt = SeadmeteMap[seadmeNimi]["Seadme_pilt"];
    uusPilt = algnePilt;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: Pildid.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AbiLeht()));
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
                        color: Colors.grey[300],
                        child: Center(
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 48,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
              final pilt1 = Pildid.elementAt(index - 1);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    uusPilt = Pildid[index - 1];
                  });
                  pilt(uusPilt);
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
                        border: uusPilt == pilt1
                            ? Border.all(
                                color: Colors.green,
                                width: 8,
                              )
                            : Border.all(
                                color: Colors.grey,
                                width: 8,
                              ),
                      ),
                      child: Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: ClipRRect(
                              child: Image.asset(
                                pilt1,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }));
  }
}
