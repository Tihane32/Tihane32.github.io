import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testuus4/lehed/GraafikusseSeadmeteValik.dart';
import 'package:testuus4/lehed/dynamicKoduLeht.dart';
import '../funktsioonid/genMaaramine.dart';
import '../main.dart';
import 'AbiLeht.dart';
import 'keskimiseHinnaAluselTundideValimine.dart';
import 'hinnaPiiriAluselTunideValimine.dart';
import 'kopeeeriGraafikTundideValimine.dart';

class LylitusValimisLehtBoss extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DynamilineTundideValimine(),
    );
  }
}

class DynamilineTundideValimine extends StatefulWidget {
  const DynamilineTundideValimine({Key? key}) : super(key: key);

  @override
  _DynamilineTundideValimineState createState() =>
      _DynamilineTundideValimineState();
}

int koduindex = 1;

class _DynamilineTundideValimineState extends State<DynamilineTundideValimine> {
  String selectedPage = 'Keskmine hind';
  double vahe = 10;
  int valitudTunnid = 10;
  Color boxColor = sinineKast;
  int leht = 0;
  final List<Widget> lehedMenu = [
    LylitusValimisLeht1(),
    LylitusValimisLeht2(),
    LylitusValimisLeht3(),
    AbiLeht(),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 115, 162, 195),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tundide valimine'),
            ],
          ),
          actions: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButton<String>(
                  value: selectedPage,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPage = newValue!;
                    });
                    if (selectedPage == 'Keskmine hind') {
                      leht = 0;
                    } else if (selectedPage == 'Hinnapiir') {
                      leht = 1;
                    } else if (selectedPage == 'Kopeeri graafik') {
                      leht = 2;
                    } else if (selectedPage == 'Minu eelistused') {
                      leht = 3;
                    }
                  },
                  underline: Container(), // or SizedBox.shrink()
                  items: <String>[
                    'Keskmine hind',
                    'Hinnapiir',
                    'Kopeeri graafik',
                    'Minu eelistused',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        body: IndexedStack(
          index: leht,
          children: lehedMenu,
        ),
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Color.fromARGB(255, 115, 162, 195),
            fixedColor: Color.fromARGB(255, 157, 214, 171),
            unselectedItemColor: Colors.white,
            selectedIconTheme: IconThemeData(size: 40),
            unselectedIconTheme: IconThemeData(size: 30),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                label: 'Seadmed',
                icon: Icon(
                  Icons.list_outlined,
                  size: 40,
                ),
              ),
              BottomNavigationBarItem(
                label: 'Kinnita',
                icon: Icon(
                  Icons.check_circle_outlined,
                  size: 40,
                ),
              ),
            ],
            currentIndex: koduindex,
            onTap: (int kodu) {
              setState(() {
                koduindex = kodu;
                if (koduindex == 0) {
                  Navigator.push(
                    //Kui vajutatakse Hinnagraafiku ikooni peale, siis viiakse Hinnagraafiku lehele
                    context,
                    MaterialPageRoute(
                        builder: (context) => SeadmeteListValimine()),
                  );
                } else if (koduindex == 1) {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Add some spacing between icon and text
                                    Text("Kinnitatud", style: fontSuur),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.check_circle_outline_outlined,
                                      size: 35,
                                    ),
                                  ],
                                ),
                                // Add other content of the dialog if needed
                              ],
                            ),
                          ));
                  HapticFeedback.vibrate();
                  Future.delayed(Duration(seconds: 5), () {
                    Navigator.of(context).pop(); // Close the AlertDialog
                    Navigator.push(
                      //Kui vajutatakse Teie seade ikooni peale, siis viiakse Seadmetelisamine lehele
                      context,
                      MaterialPageRoute(
                          builder: (context) => DynaamilenieKoduLeht(
                                i: 1,
                              )),
                    );
                  });
                }
              });
            }),
      ),
    );
  }
}
