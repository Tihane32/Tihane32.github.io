import 'package:flutter/material.dart';
import 'package:testuus4/lehed/koduleht.dart';
import 'package:testuus4/main.dart';
import 'package:flutter/material.dart';
import 'package:testuus4/funktsioonid/KeskmineHind.dart';
import 'package:testuus4/lehed/Login.dart';
import 'package:testuus4/lehed/abiLeht.dart';
import 'package:testuus4/lehed/drawer.dart';
import 'package:testuus4/lehed/MinuPakett.dart';
import 'package:testuus4/lehed/lisaSeade.dart';
import 'package:testuus4/lehed/rakenduseSeaded.dart';
import 'kaksTabelit.dart';
import 'hinnaGraafik.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testuus4/funktsioonid/hetketarbimine.dart';
import 'package:testuus4/funktsioonid/tarbimine.dart';
import 'package:testuus4/funktsioonid/maksumus.dart';
import 'hindJoonise.dart';
import '../funktsioonid/hetke_hind.dart';
import 'package:testuus4/main.dart';
import 'minuPakett.dart';

import 'navigationBar.dart';

class MinuPakett extends StatefulWidget {
  @override
  _MinuPakettState createState() => _MinuPakettState();
}

class _MinuPakettState extends State<MinuPakett> {
  double vahe = 20;
  bool value = true;
  bool valueTeavitus = true;
  String selectedOption = 'Valige oma pakett';
  List<String> dropdownOptions = [
    'Valige oma pakett',
    'Võrgupakett 1',
    'Võrgupakett 2',
    'Võrgupakett 2 kuutasuga',
    'Võrgupakett 3',
    'Võrgupakett 4',
    'Võrgupakett 5'
  ];
  bool isLoading = false;
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
                  padding: const EdgeInsets.only(right: 20),
                  icon: const Icon(
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      alignment: Alignment.centerLeft,
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          DropdownButton<String>(
                            underline: Container(
                              // Replace the default underline
                              height: 0,

                              color:
                                  Colors.black, // Customize the underline color
                            ),
                            dropdownColor: sinineKast,
                            borderRadius: borderRadius,
                            value: selectedOption,
                            icon: const Icon(Icons.expand_circle_down_outlined,
                                color: Color.fromARGB(0, 0, 0, 0)),
                            onChanged: (String? newValue) async {
                              // Use an async function
                              setState(() {
                                selectedOption = newValue!;
                                isLoading = true; // Show the loading animation

                                // Call the async function and wait for the result
                                maksumus(selectedOption).then((result) {
                                  setState(() {
                                    isLoading =
                                        false; // Hide the loading animation
                                  });
                                });
                              });
                            },
                            items: dropdownOptions
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text('  ' + value, style: font),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ), // Add some spacing between the two widgets
                ],
              ),
            ),
          ),
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
            child: AppNavigationBar(i: 3),
          ),
        ));
  }
}
