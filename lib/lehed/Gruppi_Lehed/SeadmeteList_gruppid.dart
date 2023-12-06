import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testuus4/funktsioonid/seisukord.dart';
import 'package:testuus4/lehed/Tundide_valimis_Lehed/Graafik_Seadmete_valik/DynaamilineGraafikusseSeadmeteValik.dart';
import 'package:testuus4/lehed/Gruppi_Lehed/dynaamilineGrupiLeht.dart';
import 'package:testuus4/lehed/P%C3%B5hi_Lehed/dynamicKoduLeht.dart';
import 'package:testuus4/main.dart';
import '../../funktsioonid/saaGruppiOlek.dart';
import '../../funktsioonid/salvestaGrupp.dart';
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
    SeadmeGraafikKontrollimineGen1();
    SeadmeGraafikKontrollimineGen2();

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

  void _handleButtonPress(seade) {
    if (!canPressButton) return;

    /*
    setState(() {
      canPressButton = false;
      seadmeteMap = muudaSeadmeOlek(seadmeteMap, seade);
    });
    */
    setState(() {
      if (gruppiMap[seade]["Gruppi_olek"] == 'on') {
        gruppiMap[seade]["Gruppi_olek"] = 'off';
      } else {
        gruppiMap[seade]["Gruppi_olek"] = 'on';
      }
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
                  final grupiOlek = saaGrupiOlek(grupp);
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
                                        _handleButtonPress(grupp);
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
                                      ' 50,3 W ',
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
