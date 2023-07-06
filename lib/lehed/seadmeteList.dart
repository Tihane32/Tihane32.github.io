import 'package:flutter/material.dart';

import 'package:testuus4/lehed/Login.dart';
import 'package:testuus4/lehed/abiLeht.dart';
import 'package:testuus4/lehed/kasutajaSeaded.dart';

import 'package:testuus4/lehed/rakenduseSeaded.dart';
import 'kaksTabelit.dart';

import 'package:google_fonts/google_fonts.dart';

import 'hindJoonise.dart';

import 'package:testuus4/main.dart';

void main() {
  runApp(SeadmeteListPage());
}

class SeadmeteListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  String onoffNupp = 'Shelly ON';

  int koduindex = 1;

  final Map<String, String> pictureMap = {
    'Keldri boiler': 'assets/boiler1.jpg',
    'Veranda lamp kase': 'assets/verandaLamp1.png',
    'veranda lamp porgand': 'assets/verandaLamp1.png',
    'Keldri pump': 'assets/pump1.jpg',
    'Garaazi pump': 'assets/pump1.jpg',
    'Main boiler': 'assets/boiler1.jpg',
    'Sauna boiler': 'assets/boiler1.jpg',
  };
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backround,
      appBar: AppBar(
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
      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.65,
        child: Container(
          color: const Color.fromARGB(
              255, 115, 162, 195), // Set the desired background color
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Drawer items...
              ListTile(),
              ListTile(
                leading: Icon(
                  Icons.login,
                  size: 32,
                ),
                title: RichText(
                  text: TextSpan(
                    text: 'Shelly Login',
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.manage_accounts,
                  size: 32,
                ),
                title: RichText(
                  text: TextSpan(
                    text: 'Kasutaja seaded',
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => KasutajaSeaded()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.phonelink_setup, size: 32),
                title: RichText(
                  text: TextSpan(
                    text: 'Rakenduse seaded',
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RakenduseSeaded()),
                  );
                },
              ),
              ListTile(
                leading: Icon(
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AbiLeht()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: pictureMap.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AbiLeht(),
                  ),
                );
              },
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
            );
          }

          final pictureName = pictureMap.keys.elementAt(index - 1);
          final pictureAsset = pictureMap.values.elementAt(index - 1);
          final isSelected = selectedPictures.contains(pictureName);
          return GestureDetector(
            onTap: () {
              toggleSelection(pictureName);
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? Colors.green : Colors.red,
                  width: 6,
                ),
              ),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        pictureAsset,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.blue.withOpacity(0.8),
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Center(
                        child: Text(
                          pictureName,
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
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 115, 162, 195),
        fixedColor: roheline,
        unselectedItemColor: Colors.white,
        selectedIconTheme: const IconThemeData(size: 30),
        unselectedIconTheme: const IconThemeData(size: 26),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: 'Seadmed',
            icon: Icon(Icons.electrical_services_rounded),
          ),
          BottomNavigationBarItem(
            label: 'Kodu',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Hinnagraafik',
            icon: Icon(Icons.table_rows_outlined),
          ),
        ],
        currentIndex: koduindex,
        onTap: (int kodu) {
          setState(() {
            koduindex = kodu;

            if (koduindex == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NordHinnad()),
              );
            } else if (koduindex == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MinuSeadmed()),
              );
            }
          });
        },
        selectedLabelStyle: TextStyle(
          fontFamily: GoogleFonts.roboto().fontFamily,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: GoogleFonts.roboto().fontFamily,
        ),
      ),
    );
  }
}
