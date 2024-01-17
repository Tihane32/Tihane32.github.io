import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testuus4/funktsioonid/lulitamine.dart';
import 'package:testuus4/funktsioonid/seisukord.dart';
import 'package:testuus4/lehed/Tundide_valimis_Lehed/Graafik_Seadmete_valik/DynaamilineGraafikusseSeadmeteValik.dart';
import 'package:testuus4/lehed/Gruppi_Lehed/dynaamilineGrupiLeht.dart';
import 'package:testuus4/lehed/P%C3%B5hi_Lehed/dynamicKoduLeht.dart';
import '../../Arhiiv/graafikuseSeadmedBody.dart';
import '../../funktsioonid/saaGruppiOlek.dart';
import 'package:testuus4/parameters.dart';
import '../Tundide_valimis_Lehed/Graafik_Seadmete_valik/graafikuseSeadmeteValik_yksikud.dart';

class SeadmeteList_gruppid extends StatefulWidget {
  const SeadmeteList_gruppid({Key? key}) : super(key: key);

  @override
  State<SeadmeteList_gruppid> createState() => _SeadmeteList_gruppidState();
}

class _SeadmeteList_gruppidState extends State<SeadmeteList_gruppid> {
  bool isLoading = false;
  @override
  void initState() {
    seisukord();
    saaGrupiOlek();
    SeadmeGraafikKontrollimineGen1();
    SeadmeGraafikKontrollimineGen2();
    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (ModalRoute.of(context)?.isCurrent == true) {
        setState(() {
          gruppiVoimsus();
          gruppiKeskond();
          saaGrupiOlek();
          gruppiMap = gruppiMap;
        });
      } else {
        timer.cancel();
      }
    });
    super.initState();
  }

  int koduindex = 1;
  Set<String> selectedPictures = Set<String>();
  double xAlign = -1;
  double signInAlign = 1;
  double loginAlign = -1;
  double width = 200;
  double height = 40;

  bool canPressButton = true;

  void _gruppSwitching(grupp) async {
    if (!canPressButton) {
      return;
    }

    setState(() {
      canPressButton = false;
    });

    List seadmed = [];
    String olek = 'on';

    seadmed = gruppiMap[grupp]['Grupi_Seadmed'];

    if (gruppiMap[grupp]["Gruppi_olek"] == 'on') {
      olek = 'off';
    } else {
      olek = 'on';
    }

    setState(() {
      gruppiMap[grupp]["Gruppi_olek"] = olek;
      gruppiMap = gruppiMap;
    });

    for (var item in seadmed) {
      try {
        if (seadmeteMap[item]['Seadme_olek'] != olek) {
          lulitamine(item);
          await Future.delayed(Duration(milliseconds: 100));
        }
      } catch (e) {
        // Handle errors, e.g., log the error or show a message to the user
        print('Error in _gruppSwitching: $e');
      }
    }

    //saaGrupiOlek();

    setState(() {
      canPressButton = true;
    });
    Timer(Duration(seconds: 1), () {
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
                  crossAxisCount: 1,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 3),
                ),
                itemCount: gruppiMap.length + 1,
                itemBuilder: (context, index) {
                  if (index == gruppiMap.length) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DunaamilineGrupiLeht(
                              gruppNimi: 'Uus grupp',
                              valitud: 4,
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

                  final grupp = gruppiMap.keys.elementAt(index);
                  final gruppiPilt = gruppiMap[grupp]["Gruppi_pilt"];
                  final grupiOlek = gruppiMap[grupp]["Gruppi_olek"];
                  final grupiTemp = gruppiMap[grupp]['Grupi_temp'];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DunaamilineGrupiLeht(
                            gruppNimi: gruppiMap.keys.elementAt(index),
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
                          image: DecorationImage(
                            image: AssetImage(gruppiPilt),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(children: [
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: grupiOlek == 'on'
                                    ? Colors.green.withOpacity(0.6)
                                    : grupiOlek == 'off'
                                        ? Colors.red.withOpacity(0.6)
                                        : Colors.grey.withOpacity(0.6),
                                shape: BoxShape.circle,
                              ),
                              child: grupiOlek == 'Offline'
                                  ? Icon(
                                      Icons.wifi_off_outlined,
                                      size: 60,
                                      color: Colors.amber,
                                    )
                                  : IconButton(
                                      iconSize: 60,
                                      icon: Icon(Icons.power_settings_new),
                                      color: Colors.white,
                                      onPressed: () {
                                        _gruppSwitching(grupp);
                                      },
                                    ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            left: MediaQuery.of(context).size.width / 2 - 40,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.6),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                iconSize: 60,
                                icon: Icon(Icons.crop_5_4_outlined),
                                color: Colors.white,
                                onPressed: () {},
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.6),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                iconSize: 60,
                                icon: Icon(Icons.crop_5_4_outlined),
                                color: Colors.white,
                                onPressed: () {},
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                // Temperature (moved to the left side)
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(
                                        0.5), // changed background to black
                                  ),
                                  child: Visibility(
                                    visible: grupp != 'Kõik Seadmed',
                                    child: Center(
                                      child: Text(
                                        '' + grupiTemp.toString() + '° C ',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Seadme Name Container (centered)
                                Expanded(
                                  child: Container(
                                    color: Colors.blue.withOpacity(0.6),
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Center(
                                      child: Text(
                                        grupp.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Power Button (moved to the right side)
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(
                                        0.5), // changed background to black
                                  ),
                                  child: Center(
                                    child: Text(
                                      gruppiMap[grupp]['Gruppi_voimsus']
                                              .toString() +
                                          ' W',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

void gruppiKeskond() {
  gruppiMap.forEach((key, value) async {
    String tempID = '';
    if (gruppiMap[key]['Grupi_temp_andur'].isNotEmpty) {
      tempID = gruppiMap[key]['Grupi_temp_andur'];
      gruppiMap[key]['Grupi_temp'] = anduriteMap[tempID]['temp'];
    }
  });
}

void gruppiVoimsus() async {
  num mod = pow(10.0, 1);
  gruppiMap.forEach((key, value) async {
    double sumVoimsus = 0;

    gruppiMap[key]['Grupi_Seadmed'].forEach((element) {
      if (seadmeteMap[element]['Seadme_olek'] == 'on') {
        sumVoimsus = sumVoimsus + seadmeteMap[element]['Hetke_voimsus'];
      }
    });
    sumVoimsus = ((sumVoimsus * mod).round().toDouble() / mod);
    gruppiMap[key]['Gruppi_voimsus'] = sumVoimsus;
  });
}
