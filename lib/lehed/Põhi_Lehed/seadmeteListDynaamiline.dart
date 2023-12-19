import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testuus4/funktsioonid/keskonnaMoodis.dart';
import 'package:testuus4/funktsioonid/lulitamine.dart';
import 'package:testuus4/funktsioonid/voimsusMoodis.dart';
import 'dart:async';
import 'package:testuus4/lehed/Seadme_Lehed/SeadmeGraafikLeht.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/lehed/SeadmeteList_andurid.dart';
import 'package:testuus4/parameters.dart';
import '../Tundide_valimis_Lehed/Graafik_Seadmete_valik/DynaamilineGraafikusseSeadmeteValik.dart';
import '../Seadme_Lehed/SeadmeYldInfo.dart';

import '../Gruppi_Lehed/SeadmeteList_gruppid.dart';
import '../Seadme_Lehed/SeadmeteList_yksikud.dart';
import 'package:testuus4/main.dart';

class SeadmeteList extends StatefulWidget {
  const SeadmeteList({Key? key}) : super(key: key);

  @override
  State<SeadmeteList> createState() => _SeadmeteListState();
}

class _SeadmeteListState extends State<SeadmeteList> {
  List<Widget> lehedMenu = [
    SeadmeteList_yksikud(),
    SeadmeteList_gruppid(),
    SeadmeteList_andurid(),
  ];
  double xAlign = -1;
  double signInAlign = 1;
  double loginAlign = -1;
  double width = 200;
  double height = 40;
  void initState() {
    super.initState();
    if (seadmeteListIndex == 0) {
      xAlign = loginAlign;
    } else if (seadmeteListIndex == 1) {
      xAlign = 0;
    } else if (seadmeteListIndex == 2) {
      xAlign = signInAlign;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backround,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        title: Center(
          child: Container(
            width: width * 1.3333,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(
                Radius.circular(50.0),
              ),
            ),
            child: Stack(
              children: [
                AnimatedAlign(
                  alignment: Alignment(xAlign, 0),
                  duration: Duration(milliseconds: 300),
                  child: Container(
                    width: width * 0.5,
                    height: height,
                    decoration: BoxDecoration(
                      color: Colors.lightGreen,
                      borderRadius: BorderRadius.all(
                        Radius.circular(50.0),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      xAlign = loginAlign;
                      seadmeteListIndex = 0;
                    });
                  },
                  child: Align(
                    alignment: Alignment(-1, 0),
                    child: Container(
                      width: width * 0.5,
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      child: Icon(Icons.grid_view),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      xAlign = 0;
                      seadmeteListIndex = 1;
                    });
                  },
                  child: Align(
                    alignment: Alignment(0, 0),
                    child: Container(
                      width: width * 0.5,
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      child: Icon(Icons.view_agenda_outlined),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      xAlign = signInAlign;
                      seadmeteListIndex = 2;
                    });
                  },
                  child: Align(
                    alignment: Alignment(1, 0),
                    child: Container(
                      width: width * 0.5,
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      child: Icon(Icons.sensors),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: seadmeteListIndex,
        children: lehedMenu,
      ),
    );
  }
}
