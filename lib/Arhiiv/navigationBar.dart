import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testuus4/lehed/Tundide_valimis_Lehed/Graafik_Seadmete_valik/DynaamilineGraafikusseSeadmeteValik.dart';
import 'package:testuus4/lehed/P%C3%B5hi_Lehed/koduleht.dart';
import 'package:testuus4/lehed/P%C3%B5hi_Lehed/seadmeteListDynaamiline.dart';
import 'package:testuus4/main.dart';
import '../lehed/Põhi_Lehed/dynamicKoduLeht.dart';
import 'kaksTabelit.dart';
import '../lehed/Põhi_Lehed/hindJoonise.dart';
import 'package:get/get.dart';

class AppNavigationBar extends StatelessWidget {
  final int i;
  const AppNavigationBar({
    Key? key,
    required this.i,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.black,
              width: 0,
            ),
          ),
        ),
        child: SizedBox(
            height: navBarHeight,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: BottomNavigationBar(
                    showSelectedLabels: true,
                    showUnselectedLabels: true,
                    backgroundColor: roheline,
                    selectedFontSize: 12.0,
                    unselectedFontSize: 12.0,
                    fixedColor: Colors.black,
                    unselectedItemColor: Colors.black,
                    selectedIconTheme: const IconThemeData(
                        color: Color.fromARGB(255, 0, 0, 0)),
                    unselectedIconTheme:
                        const IconThemeData(color: Colors.black),
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        label: 'Ülevaade',
                        icon: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => KoduLeht()),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .center, // Adjust the spacing between icons
                            children: [
                              if (i ==
                                  1) // Replace isSelected with your own logic to determine which label is selected
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(40, 41, 137, 205),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.person_outlined,
                                    size: 35,
                                    color: Colors.blue,
                                  ),
                                )
                              else
                                Icon(
                                  Icons.person_outlined,
                                  size: 35,
                                ),

                              // Adjust the spacing between the icons
                            ],
                          ),
                        ),
                      ),
                      BottomNavigationBarItem(
                        label: 'Seadmed',
                        icon: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      DynaamilenieKoduLeht(i: 1)),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Adjust the spacing between icons
                              children: [
                                if (i ==
                                    0) // Replace isSelected with your own logic to determine which label is selected
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(81, 80, 129, 164),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.home_outlined,
                                        size: 35, color: Colors.blue),
                                  )
                                else
                                  Icon(
                                    Icons.home_outlined,
                                    size: 35,
                                  ),
                                // Adjust the spacing between the icons
                              ],
                            ),
                          ),
                        ),
                      ),
                      BottomNavigationBarItem(
                        label: 'Graafiku koostamine',
                        icon: GestureDetector(
                          onTap: () {
                            /*
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => SeadmeteValmisPage(laeb: true)),
                            );
                          */
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Adjust the spacing between icons
                              children: [
                                if (i ==
                                    2) // Replace isSelected with your own logic to determine which label is selected
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(81, 80, 129, 164),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.addchart_outlined,
                                        size: 35, color: Colors.blue),
                                  )
                                else
                                  Icon(
                                    Icons.addchart_outlined,
                                    size: 35,
                                  ),

                                // Adjust the spacing between the icons
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}
