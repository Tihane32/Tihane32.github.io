import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testuus4/lehed/GraafikusseSeadmeteValik.dart';
import 'package:testuus4/lehed/koduleht.dart';
import 'package:testuus4/lehed/seadmeteList.dart';
import 'package:testuus4/main.dart';
import 'drawer.dart';
import 'kaksTabelit.dart';
import 'hindJoonise.dart';
import 'package:get/get.dart';
import 'navigationBar.dart';

class DynaamilenieKoduLeht extends StatefulWidget {
  @override
  State<DynaamilenieKoduLeht> createState() => _DynaamilenieKoduLehtState();
}

class _DynaamilenieKoduLehtState extends State<DynaamilenieKoduLeht> {
  int i = 1;

  final List<Widget> lehed = [
    KoduLeht(),
    SeadmeteList(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backround,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: appbar,
          title: Text(
            'Shelly App',
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(fontSize: 25),
            ),
          ),
          actions: [
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                  padding: EdgeInsets.only(right: 20),
                  icon: Icon(
                    Icons.menu,
                    size: 30,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              },
            ),
          ],
        ),
        endDrawer: drawer(),
        body: IndexedStack(
          index: i,
          children: lehed,
        ),
        bottomNavigationBar: Container(
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
                                setState(() {
                                  i = 0;
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Adjust the spacing between icons
                                children: [
                                  if (i ==
                                      0) // Replace isSelected with your own logic to determine which label is selected
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
                                setState(() {
                                  i = 1;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 0.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .center, // Adjust the spacing between icons
                                  children: [
                                    if (i ==
                                        1) // Replace isSelected with your own logic to determine which label is selected
                                      Container(
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(81, 80, 129, 164),
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
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          SeadmeteValmisPage()),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 0.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .center, // Adjust the spacing between icons
                                  children: [
                                    Icon(
                                      Icons.addchart_outlined,
                                      size: 35,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ))));
  }
}
