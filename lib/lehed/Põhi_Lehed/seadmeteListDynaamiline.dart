import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testuus4/funktsioonid/lulitamine.dart';
import 'dart:async';
import 'package:testuus4/lehed/Seadme_Lehed/SeadmeGraafikLeht.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../GraafikusseSeadmeteValik.dart';
import '../Seadme_Lehed/SeadmeYldInfo.dart';
import '../Gruppi_Lehed/SeadmeteList_gruppid.dart';
import '../Seadme_Lehed/SeadmeteList_yksikud.dart';
import 'dynamicKoduLeht.dart';
import 'dart:convert';
import 'package:testuus4/funktsioonid/seisukord.dart';
import 'package:testuus4/main.dart';

import 'package:get/get.dart';

import '../Seadme_Lehed/dynamicSeadmeInfo.dart';

class SeadmeteListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: SeadmeteList(),
    );
  }
}

class SeadmeteList extends StatefulWidget {
  const SeadmeteList({Key? key}) : super(key: key);

  @override
  State<SeadmeteList> createState() => _SeadmeteListState();
}

class _SeadmeteListState extends State<SeadmeteList> {
  List<Widget> lehedMenu = [
    SeadmeteList_yksikud(),
    SeadmeteList_gruppid(),
  ];
  int leht = 0;
  double xAlign = -1;
  double signInAlign = 1;
  double loginAlign = -1;
  double width = 200;
  double height = 40;

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
            width: width,
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
                      leht = 0;
                    });
                  },
                  child: Align(
                    alignment: Alignment(-1, 0),
                    child: Container(
                        width: width * 0.5,
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        child: Icon(Icons.grid_view)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      xAlign = signInAlign;
                      leht = 1;
                    });
                  },
                  child: Align(
                    alignment: Alignment(1, 0),
                    child: Container(
                        width: width * 0.5,
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        child: Icon(Icons.view_agenda_outlined)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: leht,
        children: lehedMenu,
      ),
    );
  }
}
