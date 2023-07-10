import 'package:flutter/material.dart';

import 'package:testuus4/lehed/Login.dart';
import 'package:testuus4/lehed/SeadmeGraafikLeht.dart';
import 'package:testuus4/lehed/abiLeht.dart';
import 'package:testuus4/lehed/drawer.dart';
import 'package:testuus4/lehed/kasutajaSeaded.dart';

import 'package:testuus4/lehed/rakenduseSeaded.dart';
import 'kaksTabelit.dart';

import 'package:google_fonts/google_fonts.dart';

import 'hindJoonise.dart';
import 'navigationBar.dart';
import 'package:testuus4/main.dart';



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
      endDrawer: drawer(),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SeadmeGraafikuLeht(
                    seadmeNimi: pictureMap.keys.elementAt(index - 1),
                  ),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? Colors.green : Colors.red,
                  width: 8,
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
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        iconSize: 60,
                        icon: Icon(Icons.power_settings_new),
                        color: Colors.white,
                        onPressed: () {
                          toggleSelection(pictureName);
                          // Handle the IconButton click
                          print('Power clicked for $pictureName');
                        },
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
      bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.black,
                width: 2.0,
              ),
            ),
          ),
          child: SizedBox(
            height: 72,
            child: AppNavigationBar(i: 0),
          ),
        ));
  }
}
