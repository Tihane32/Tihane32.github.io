import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testuus4/funktsioonid/lulitamine.dart';
import 'dart:async';
import '../GraafikusseSeadmeteValik.dart';
import '../Põhi_Lehed/dynamicKoduLeht.dart';
import 'package:testuus4/funktsioonid/seisukord.dart';
import 'package:testuus4/main.dart';
import '../Seadme_Lehed/dynamicSeadmeInfo.dart';

class GruppiKoostamine extends StatefulWidget {
  const GruppiKoostamine({Key? key}) : super(key: key);

  @override
  State<GruppiKoostamine> createState() => _GruppiKoostamineState();
}

class _GruppiKoostamineState extends State<GruppiKoostamine> {
  @override
  void initState() {
    super.initState();
  }

  int koduindex = 1;
  Set<String> selectedPictures = Set<String>();
  double xAlign = -1;
  double signInAlign = 1;
  double loginAlign = -1;
  double width = 200;
  double height = 40;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backround,
      body: GridView.builder(
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: seadmeteMap.length,
        itemBuilder: (context, index) {
          final seade = seadmeteMap.keys.elementAt(index);
          final pilt = seadmeteMap[seade]["Seadme_pilt"];
          final staatus = seadmeteMap[seade]["Seadme_olek"];
          print('Staatus: $staatus');
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DunaamilineSeadmeLeht(
                    seadmeNimi: seadmeteMap.keys.elementAt(index),
                    SeadmeteMap: seadmeteMap,
                    valitud: 0,
                  ),
                ),
              );
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
                    border: Border.all(
                      color: staatus == 'on' ? Colors.green : Colors.grey,
                      width: 8,
                    ),
                  ),
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: ClipRRect(
                          child: Image.asset(
                            pilt,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Colors.blue.withOpacity(0.6),
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Center(
                            child: Text(
                              seadmeteMap[seade]["Seadme_nimi"],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
