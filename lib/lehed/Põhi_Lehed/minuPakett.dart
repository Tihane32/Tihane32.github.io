import 'package:flutter/material.dart';
import 'package:testuus4/main.dart';
import 'package:testuus4/Arhiiv/drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testuus4/funktsioonid/maksumus.dart';

import '../../Arhiiv/navigationBar.dart';

class MinuPakett extends StatefulWidget {
  @override
  _MinuPakettState createState() => _MinuPakettState();
}

class _MinuPakettState extends State<MinuPakett> {
  double hind = 45;
  TextEditingController textController = TextEditingController();
  double vahe = 20;
  bool edastaminePakett = false;
  bool value = true;
  bool valueTeavitus = true;

  @override
  void initState() {
    super.initState();
    textController.text =
        hind.toString(); // Set the initial value for the TextField
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backround,
        appBar: AppBar(
          backgroundColor: appbar,
          title: Text(
            'Minu pakett',
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(fontSize: 25),
            ),
          ),
        ),
        body: Container(),
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
            height: navBarHeight,
            child: AppNavigationBar(i: 3),
          ),
        ));
  }
}
