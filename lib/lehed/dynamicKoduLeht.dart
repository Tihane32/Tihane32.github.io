import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testuus4/lehed/GraafikusseSeadmeteValik.dart';
import 'package:testuus4/lehed/koduleht.dart';
import 'package:testuus4/lehed/seadmeteListDynaamiline.dart';
import 'package:testuus4/main.dart';
import 'AbiLeht.dart';
import 'Login.dart';
import 'drawer.dart';
import '../Arhiiv/kaksTabelit.dart';
import 'hindJoonise.dart';
import 'package:get/get.dart';
import 'kasutajaSeaded.dart';
import 'lisaSeade.dart';
import '../Arhiiv/navigationBar.dart';

class DynaamilenieKoduLeht extends StatefulWidget {
  DynaamilenieKoduLeht({Key? key, required this.i}) : super(key: key);

  int i;

  @override
  State<DynaamilenieKoduLeht> createState() => _DynaamilenieKoduLehtState(i: i);
}

class _DynaamilenieKoduLehtState extends State<DynaamilenieKoduLeht> {
  _DynaamilenieKoduLehtState({Key? key, required this.i});
  int i;
  String appBarText = 'Minu seadmed';

  final List<Widget> lehed = [
    KoduLeht(),
    SeadmeteList(),
    LoginPage(),
    KasutajaSeaded(),
    TulpDiagramm(),
    LisaSeade(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backround,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: appbar,
          title: Text(
            appBarText,
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
        endDrawer: Drawer(
          width: MediaQuery.of(context).size.width * 0.60,
          child: Container(
            color: const Color.fromARGB(
                255, 115, 162, 195), // Set the desired background color
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Drawer items...
                const ListTile(),
                ListTile(
                  leading: const Icon(
                    Icons.add_circle_outline_outlined,
                    size: 32,
                  ),
                  title: RichText(
                    text: TextSpan(
                      text: 'Seadme lisamine',
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      i = 2;
                      appBarText = 'Seadme lisamine';
                    });
                  },
                ),
                /*ListTile(
              leading: const Icon(
                Icons.add_circle_outline_outlined,
                size: 32,
              ),
              title: RichText(
                text: TextSpan(
                  text: 'Lisa seade',
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ),
              onTap: () {
                // Navigate to the home page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LisaSeade()),
                );
              },
            ),*/
                ListTile(
                  leading: const Icon(
                    Icons.manage_accounts,
                    size: 32,
                  ),
                  title: RichText(
                    text: TextSpan(
                      text: 'Seaded',
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      i = 3;
                      appBarText = 'Seaded';
                    });
                  },
                ),
                ListTile(
                  leading: Transform.rotate(
                    angle: 0 * 0.0174533,
                    child: const Icon(
                      Icons.bar_chart_rounded,
                      size: 32, // Adjust the size as needed
                    ),
                  ),
                  title: RichText(
                    text: TextSpan(
                      text: 'Elektri börsihind',
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      i = 4;
                      appBarText = 'Elektri börsihind';
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.help_outline_outlined,
                    size: 32, // Adjust the size as needed
                  ),
                  title: RichText(
                    text: TextSpan(
                      text: 'Abi',
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    // Navigate to the home page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AbiLeht()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
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
                                  appBarText = 'Ülevaade';
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
                                  appBarText = 'Minu seadmed';
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
                                          SeadmeteListValimine()),
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
