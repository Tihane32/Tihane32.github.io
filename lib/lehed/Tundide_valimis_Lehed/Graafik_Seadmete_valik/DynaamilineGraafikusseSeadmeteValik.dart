import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testuus4/widgets/AbiLeht.dart';
import 'package:testuus4/widgets/hoitatus.dart';
import '../DynaamilineTundideValimine.dart';
import '../../Põhi_Lehed/dynamicKoduLeht.dart';
import 'package:testuus4/main.dart';
import 'graafikuseSeadmeteValik_gruppid.dart';
import 'graafikuseSeadmeteValik_yksikud.dart';
import 'package:testuus4/parameters.dart';

class SeadmeteListValimine_dynaamiline extends StatefulWidget {
  const SeadmeteListValimine_dynaamiline({Key? key}) : super(key: key);

  @override
  State<SeadmeteListValimine_dynaamiline> createState() =>
      _SeadmeteListValimine_dynaamilineState();
}

class _SeadmeteListValimine_dynaamilineState
    extends State<SeadmeteListValimine_dynaamiline> {
  int item = 0;
  double xAlign = -1;
  double signInAlign = 1;
  double loginAlign = -1;
  double width = 200;
  double height = 40;
  Map<String, bool> ValitudSeadmed = {};
  bool isLoading = false;
  int koduindex = 1;
  late List<Widget> menu;

  saaValitudSeadmed(Map<String, bool> seadmed) {
    setState(() {
      ValitudSeadmed = seadmed;
    });
  }

  @override
  void initState() {
    menu = [
      SeadmeteListValimine_yksikud(saaValitudSeadmed: saaValitudSeadmed),
      SeadmeteListValimine_guruppid(saaValitudSeadmed: saaValitudSeadmed),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backround,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: appbar,
        title: Text(
          'Seadmete valimine',
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(fontSize: 25),
          ),
        ),
      ),
      body: Scaffold(
        backgroundColor: backround,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          title: Center(
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(
                  Radius.circular(50.0),
                ),
              ),
              child: Stack(
                children: [
                  AnimatedAlign(
                    alignment: Alignment(xAlign, 0),
                    duration: Duration(milliseconds: 300),
                    child: Container(
                      width: width * 0.5,
                      height: height,
                      decoration: BoxDecoration(
                        color: Colors.lightGreen,
                        borderRadius: BorderRadius.all(
                          Radius.circular(50.0),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        xAlign = loginAlign;
                        item = 0;
                      });
                    },
                    child: Align(
                      alignment: Alignment(-1, 0),
                      child: Container(
                          width: width * 0.5,
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          child: Icon(Icons.grid_view)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        xAlign = signInAlign;
                        item = 1;
                      });
                    },
                    child: Align(
                      alignment: Alignment(1, 0),
                      child: Container(
                          width: width * 0.5,
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          child: Icon(Icons.view_agenda_outlined)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: IndexedStack(
          index: item,
          children: menu,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color.fromARGB(255, 115, 162, 195),
          fixedColor: Color.fromARGB(255, 157, 214, 171),
          unselectedItemColor: Colors.white,
          selectedIconTheme: IconThemeData(size: 40),
          unselectedIconTheme: IconThemeData(size: 30),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: 'Tühista',
              icon: Icon(Icons.cancel),
            ),
            BottomNavigationBarItem(
              label: 'Tundide Valimine',
              icon: Icon(Icons.arrow_forward),
            ),
          ],
          currentIndex: koduindex,
          onTap: (int kodu) {
            setState(() {
              koduindex = kodu;
              if (koduindex == 0) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DynaamilenieKoduLeht(i: 1)));
              } else if (koduindex == 1) {
                if (ValitudSeadmed.values.any((value) => value == true)) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DynamilineTundideValimine(
                              valitudSeadmed: ValitudSeadmed,
                              i: 0,
                              luba: '',
                              eelmineleht: 0,
                            )),
                  );
                } else {
                  Hoiatus(
                    context,
                    'Enne graafiku koostamist valige kaasatavad seadmed!',
                  );
                }
              }
            });
          }),
    );
  }
}
