import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testuus4/funktsioonid/lulitamine.dart';
import 'dart:async';
import 'package:testuus4/lehed/P%C3%B5hi_Lehed/dynamicKoduLeht.dart';
import 'package:testuus4/funktsioonid/seisukord.dart';
import 'package:testuus4/main.dart';
import 'Seadme_Lehed/dynamicSeadmeInfo.dart';
import 'Tundide_valimis_Lehed/Graafik_Seadmete_valik/DynaamilineGraafikusseSeadmeteValik.dart';
import 'Tundide_valimis_Lehed/Graafik_Seadmete_valik/graafikuseSeadmeteValik_yksikud.dart';

class SeadmeteList_andurid extends StatefulWidget {
  const SeadmeteList_andurid({Key? key}) : super(key: key);

  @override
  State<SeadmeteList_andurid> createState() => _SeadmeteList_anduridState();
}

class _SeadmeteList_anduridState extends State<SeadmeteList_andurid> {
  bool isLoading = true;
  late Map<String, List<String>> minuSeadmedK = {};
  //String onoffNupp = 'Shelly ON';
  @override
  void initState() {
    SeadmeGraafikKontrollimineGen1();
    SeadmeGraafikKontrollimineGen2();

    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await seisukord();
    // Add any other data fetching or initialization code here if needed.
    // When done, set isLoading to false to display the content.
    setState(() {
      isLoading = false;
    });
  }

  int koduindex = 1;
  Set<String> selectedPictures = Set<String>();

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
              CupertinoPageRoute(
                  builder: (context) => SeadmeteListValimine_dynaamiline()),
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
                  crossAxisCount: 2,
                ),
                itemCount: seadmeteMap.length + 1,
                itemBuilder: (context, index) {
                  if (index == seadmeteMap.length) {
                    return GestureDetector(
                      onTap: () {
                        print(seadmeteMap);
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
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 8,
                                  ),
                                ),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: ClipRRect(
                                    child: Image.asset(
                                      pilt,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 50,
                                right: 0,
                                child: Container(
                                  width: 70,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.6),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15.0),
                                      bottomLeft: Radius.circular(15.0),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      ' 25° C ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 50,
                                left: 0,
                                child: Container(
                                  width: 70,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.6),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15.0),
                                      bottomRight: Radius.circular(15.0),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      ' 55 % ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left:
                                    MediaQuery.of(context).size.width / 4 - 20,
                                child: Container(
                                  width: 40,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15.0),
                                      bottomRight: Radius.circular(15.0),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.light_mode_rounded,
                                    color: Colors.yellow,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(30.0),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.battery_4_bar_rounded,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(30.0),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.wifi,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 8,
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
                              Positioned(
                                // Gradient from https://learnui.design/tools/gradient-generator.html
                                top: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xff041036),
                                        Color(0xff000000),
                                        Color(0xff150000)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomLeft,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  width: 8,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xff041036),
                                        Color(0xff051850),
                                        Color(0xff0a2c94),
                                        Color(0xff114cff),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomLeft,
                                    ),
                                  ),
                                ),
                              ),
                              // Right Border
                              Positioned(
                                right: 0,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  width: 8,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xff150000),
                                        Color(0xff7b0000),
                                        Color(0xffca0000),
                                        Color(0xffff0000)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomLeft,
                                    ),
                                  ),
                                ),
                              ),
                              // Bottom Border
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xff114cff),
                                        Color(0xffe008ff),
                                        Color(0xffff0000)
                                      ],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.bottomRight,
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
