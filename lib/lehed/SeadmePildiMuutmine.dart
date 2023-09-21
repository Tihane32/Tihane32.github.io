import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/lehed/AbiLeht.dart';
import 'package:testuus4/lehed/SeadmeGraafikLeht.dart';
import 'package:testuus4/lehed/TarbimisLeht.dart';
import 'package:testuus4/lehed/seadmedKontoltNim.dart';
import 'package:testuus4/main.dart';
import 'SeadmeTarbimisLeht.dart';

class SeadmePildiMuutmine extends StatefulWidget {
  const SeadmePildiMuutmine(
      {Key? key, required this.seadmeNimi, required this.SeadmeteMap})
      : super(key: key);

  final String seadmeNimi;
  final Map<String, List<String>> SeadmeteMap;
  @override
  _SeadmePildiMuutmineState createState() => _SeadmePildiMuutmineState(
      seadmeNimi: seadmeNimi, SeadmeteMap: SeadmeteMap);
}

class _SeadmePildiMuutmineState extends State<SeadmePildiMuutmine> {
  _SeadmePildiMuutmineState(
      {Key? key, required this.seadmeNimi, required this.SeadmeteMap});
  String seadmeNimi;
  Map<String, List<String>> SeadmeteMap;
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
    'assets/verandaLamp1.jpg',
    'assets/tuulik1.jpg',
    'assets/tuulik.jpg',
    'assets/tuulik2.jpg',
    'assets/tuulik3.jpg',
    'assets/tuulik4.jpg',
  ];
  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    setState(() {});
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
              if (index == SeadmeteMap.length) {
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
              return GestureDetector(OnTap: () {});
            }));
  }
}
