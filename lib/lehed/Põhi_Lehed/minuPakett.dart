import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testuus4/widgets/hoitatus.dart';
import 'package:testuus4/widgets/kinnitus.dart';

import '../../Arhiiv/navigationBar.dart';

import 'package:flutter/material.dart';

class MinuPakett extends StatefulWidget {
  @override
  _MinuPakettState createState() => _MinuPakettState();
}

class _MinuPakettState extends State<MinuPakett> {
  TextEditingController _numberController = TextEditingController();
  TextEditingController _numberController1 = TextEditingController();
  TextEditingController _numberController2 =
      TextEditingController(); // Controller for the TextField
  bool visible = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backround,
      
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        visible = true;
                        _numberController1.clear();
                        _numberController2.clear();
                      });
                    },
                    child: Text(
                      "Ühetariifne",
                      style: font,
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(sinineKast)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        visible = false;
                        _numberController.clear();
                      });
                    },
                    child: Text(
                      "Kahetariifne",
                      style: font,
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(sinineKast)),
                  ),
                ],
              ),
              Visibility(
                visible: visible,
                child: TextField(
                  controller: _numberController,
                  keyboardType:
                      TextInputType.number, // Allow only numeric input
                  decoration: InputDecoration(
                    labelText: 'Sisestage tariif:',
                    labelStyle: font
                  ),
                ),
              ),
              Visibility(
                visible: !visible,
                child: TextField(
                  controller: _numberController1,
                  keyboardType:
                      TextInputType.number, // Allow only numeric input
                  decoration: InputDecoration(
                    labelText: 'Sisestage päevatariif:',
                    labelStyle: font
                  ),
                ),
              ),
              Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: !visible,
                child: TextField(
                  controller: _numberController2,
                  keyboardType:
                      TextInputType.number, // Allow only numeric input
                  decoration: InputDecoration(
                    labelText: 'Sisestage öötariif:',
                    labelStyle: font
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                    onPressed: () {
                      // Save the number to SharedPreferences when the button is pressed
                      double enteredNumber =
                          double.tryParse(_numberController.text) ?? 0;
                      double enteredNumber1 =
                          double.tryParse(_numberController1.text) ?? 0;
                      double enteredNumber2 =
                          double.tryParse(_numberController2.text) ?? 0;
                      saveNumber(enteredNumber, enteredNumber1, enteredNumber2);
                    
                        Kinnitus(context, "Salvestatud");
                      
                        Hoiatus(context, "Sisestage tariif");
                      
                      // Reload the saved number
                    },
                    child: Text(
                      'Salvesta',
                      style: font,
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(roheline))),
              ),
            ],
          ),
        ),
      ),
      
    );
  }

  @override
  void dispose() {
    // Dispose the controller when it's no longer needed to prevent memory leaks
    _numberController.dispose();
    super.dispose();
  }
}

Future<void> saveNumber(enteredNumber, enteredNumber1, enteredNumber2) async {
  print("numbrid: $enteredNumber $enteredNumber1 $enteredNumber2");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<dynamic> numbrid = [];
  if (enteredNumber != 0) {
    numbrid.add(enteredNumber);
  } else {
    numbrid.add(enteredNumber1);
    numbrid.add(enteredNumber2);
  }

  print("lisatud $numbrid");
  tariif = numbrid;
  prefs.setString("tariif", "$numbrid");
}
