import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/lehed/P%C3%B5hi_Lehed/dynamicKoduLeht.dart';
import 'package:testuus4/lehed/P%C3%B5hi_Lehed/koduleht.dart';
import 'package:testuus4/lehed/P%C3%B5hi_Lehed/minuPakett.dart';
import 'package:testuus4/main.dart';
import 'package:testuus4/parameters.dart';
import 'package:testuus4/widgets/kinnitus.dart';

class KasutajaSeaded extends StatefulWidget {
  @override
  _KasutajaSeadedState createState() => _KasutajaSeadedState();
}

class _KasutajaSeadedState extends State<KasutajaSeaded> {
  double vahe = 20;
  bool value = true;
  bool valueTeavitus = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backround,
      body: Container(
        decoration: const BoxDecoration(
            /*image: DecorationImage(
            image: AssetImage('assets/tuulik7.jpg'),
            alignment: Alignment.bottomCenter,
          ),*/
            ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 20, 8, 8),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DynaamilenieKoduLeht(i: 5)),
                      );
                    },
                    child: // Add some spacing between the two widgets
                        Align(
                      alignment: Alignment.center,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: roheline,
                          borderRadius: borderRadius,
                          border: border,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(3, 3),
                            ),
                          ],
                        ),
                        width: sinineKastLaius,
                        height: sinineKastKorgus,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('  Minu pakett ', style: font),
                            const Icon(
                              Icons.account_circle_rounded,
                              color: Colors.black,
                              size: 30,
                            ),
                            const SizedBox(width: 5),
                          ],
                        ),
                      ),
                    )),
                SizedBox(height: vahe),

                Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      color: sinineKast,
                      borderRadius: borderRadius,
                      border: border,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(3, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 300,
                          height: sinineKastKorgus,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                          ),
                                          children: [
                                            TextSpan(
                                                text:
                                                    'Taustal töötamine lubatud',
                                                style: font),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                            value: value,
                            activeColor: Color.fromARGB(255, 69, 207, 44),
                            onChanged: (bool? newValue) {
                              setState(() {
                                value = !value;
                              });
                            },
                            shape: CircleBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: vahe),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      color: sinineKast,
                      borderRadius: borderRadius,
                      border: border,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(3, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 300,
                          height: sinineKastKorgus,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                          ),
                                          children: [
                                            TextSpan(
                                                text: 'Teavitused lubatud',
                                                style: font),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                            activeColor: Color.fromARGB(255, 69, 207, 44),
                            value: valueTeavitus,
                            onChanged: (bool? newValue) {
                              setState(() {
                                valueTeavitus = !valueTeavitus;
                              });
                            },
                            shape: CircleBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                    height: vahe), // Add some spacing between the two widgets
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => KoduLeht()),
                    );
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: sinineKast,
                        borderRadius: borderRadius,
                        border: border,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(3, 3),
                          ),
                        ],
                      ),
                      width: sinineKastLaius,
                      height: sinineKastKorgus,
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(text: 'Logi', style: font),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    height: vahe), // Add some spacing between the two widgets
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text("Lisada Shelly Cloud key siia"),
                            ));
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: sinineKast,
                        borderRadius: borderRadius,
                        border: border,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(3, 3),
                          ),
                        ],
                      ),
                      width: sinineKastLaius,
                      height: sinineKastKorgus,
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(text: 'Shelly Cloud Key', style: font),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    height: vahe), // Add some spacing between the two widgets
                GestureDetector(
                  onTap: () {
                    Kinnitus(
                      context,
                      'Mälu kustutatud',
                    );
                    maluClear();
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: sinineKast,
                        borderRadius: borderRadius,
                        border: border,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(3, 3),
                          ),
                        ],
                      ),
                      width: sinineKastLaius,
                      height: sinineKastKorgus,
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(text: 'Kustuta mälu', style: font),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    height: vahe), // Add some spacing between the two widgets
              ],
            ),
          ),
        ),
      ),
    );
  }
}

maluClear() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
}
