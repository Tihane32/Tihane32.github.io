import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testuus4/funktsioonid/lulitamine.dart';
import 'dart:async';
import 'package:testuus4/lehed/SeadmeGraafikLeht.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'GraafikusseSeadmeteValik.dart';
import 'SeadmeYldInfo.dart';
import 'dynamicKoduLeht.dart';
import 'dart:convert';
import 'package:testuus4/funktsioonid/seisukord.dart';
import 'package:testuus4/main.dart';

import 'package:get/get.dart';

import 'dynamicSeadmeInfo.dart';

class SeadmeteList_gruppid extends StatefulWidget {
  const SeadmeteList_gruppid({Key? key}) : super(key: key);

  @override
  State<SeadmeteList_gruppid> createState() => _SeadmeteList_gruppidState();
}

class _SeadmeteList_gruppidState extends State<SeadmeteList_gruppid> {
  bool isLoading = false;
  late Map<String, List<String>> minuSeadmedK = {};
  //String onoffNupp = 'Shelly ON';
  @override
  void initState() {
    seisukord();
    SeadmeGraafikKontrollimineGen1();
    SeadmeGraafikKontrollimineGen2();

    super.initState();
    bool isLoading = false;
  }

  int koduindex = 1;
  Set<String> selectedPictures = Set<String>();
  double xAlign = -1;
  double signInAlign = 1;
  double loginAlign = -1;
  double width = 200;
  double height = 40;

  void toggleSelection(String pictureName) {
    setState(() {
      if (selectedPictures.contains(pictureName)) {
        selectedPictures.remove(pictureName);
      } else {
        selectedPictures.add(pictureName);
      }
    });
  }

  bool canPressButton = true;

  void _handleButtonPress(seade) {
    if (!canPressButton) return;

    setState(() {
      canPressButton = false;
      seadmeteMap = muudaSeadmeOlek(seadmeteMap, seade);
    });

    Timer(Duration(seconds: 3), () {
      setState(() {
        canPressButton = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backround,
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          int tundlikus = 8;
          if (details.delta.dx > tundlikus) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DynaamilenieKoduLeht(i: 0)));
            // Right Swipe
          } else if (details.delta.dx < -tundlikus) {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => SeadmeteListValimine()),
            );
            //Left Swipe
          }
        },
        onVerticalDragUpdate: (details) {
          int sensitivity = 8;
          if (details.delta.dy > sensitivity) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DynaamilenieKoduLeht(i: 1)));
            // alla lohistamisel v2rskenda
          }
        },
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : GridView.builder(
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 3),
                ),
                itemCount: seadmeteMap.length + 1,
                itemBuilder: (context, index) {
                  if (index == seadmeteMap.length) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DynaamilenieKoduLeht(i: 2)));
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
                                Icons.add,
                                size: 48,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  final seade = seadmeteMap.keys.elementAt(index);
                  final pilt = seadmeteMap[seade]["Seadme_pilt"];
                  final staatus = seadmeteMap[seade]["Seadme_olek"];
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
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: border,
                          image: DecorationImage(
                            image: AssetImage(pilt),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 10),
                                child: Text(
                                  seadmeteMap[seade]["Seadme_nimi"],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  _buildIconButton(Icons.brightness_1, () {}),
                                  SizedBox(height: 20),
                                  _buildIconButton(Icons.brightness_1, () {}),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  _buildInfoBox('23.5°C'),
                                  SizedBox(height: 20),
                                  _buildInfoBox('50.3W'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

SaaSeadmePilt(Map<String, dynamic> SeadmeteMap, SeadmeNimi) {
  String deviceInfo = seadmeteMap[SeadmeNimi]["Seadme_pilt"];
  print("------");
  print(SeadmeteMap[SeadmeNimi]);
  if (deviceInfo != null) {
    String pilt = deviceInfo;
    return pilt;
  }
  return null; // Device key not found in the map
}

SaaSeadmeolek(Map<String, dynamic> SeadmeteMap, SeadmeNimi) {
  print("seamdetMap $seadmeteMap");
  String deviceInfo = seadmeteMap[SeadmeNimi]["Seadme_olek"];
  if (deviceInfo != null) {
    String pilt = deviceInfo;
    return pilt;
  }
  return null; // Device key not found in the map
}

muudaSeadmeOlek(Map<String, dynamic> SeadmeteMap, SeadmeNimi) {
  lulitamine(SeadmeNimi);

  return seadmeteMap; // Device key not found in the map
}

Widget _buildIconButton(IconData icon, Function onTap) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.blue.withOpacity(0.6),
      borderRadius: BorderRadius.circular(25),
    ),
    width: 50,
    height: 50,
    child: IconButton(
      padding: EdgeInsets.all(0),
      iconSize: 40,
      color: Colors.white,
      icon: Icon(icon),
      onPressed: () {},
    ),
  );
}

Widget _buildInfoBox(String info) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.blue.withOpacity(0.6),
      borderRadius: BorderRadius.circular(10),
    ),
    width: 70,
    height: 50,
    alignment: Alignment.center,
    child: Text(
      info,
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  );
}
