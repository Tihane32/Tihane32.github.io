/*
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/lehed/P%C3%B5hi_Lehed/Login.dart';
import 'package:testuus4/lehed/P%C3%B5hi_Lehed/dynamicKoduLeht.dart';
import 'package:testuus4/Arhiiv/kaksTabelit.dart';
//import '/SeadmeSeaded.dart';
import 'package:testuus4/Arhiiv/seadmeSeaded.dart';
import 'package:testuus4/main.dart';
import 'energiaGraafik.dart';
import 'package:testuus4/funktsioonid/seisukord.dart';
import 'package:testuus4/lehed/P%C3%B5hi_Lehed/koduleht.dart';
import 'package:google_fonts/google_fonts.dart';

class LisaSeade extends StatefulWidget {
  @override
  _LisaSeadeState createState() => _LisaSeadeState();
}

class _LisaSeadeState extends State<LisaSeade> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController kasutajanimi = TextEditingController();
  final TextEditingController parool = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  Future<void> _submitForm() async {
    String ajutineParool = parool.text;
    String ajutineKastuajanimi = kasutajanimi.text;

    var entryList;
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    var data3 = {
      'channel': '0',
      'id': ajutineKastuajanimi,
      'auth_key': ajutineParool,
    };

    var url3 = Uri.parse('https://shelly-64-eu.shelly.cloud/device/settings');
    var res = await http.post(url3, headers: headers, body: data3);
    final httpPackageJson3 = json.decode(res.body) as Map<String, dynamic>;
    entryList = httpPackageJson3.entries.toList();
    if (res.statusCode == 200) {
      _scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text('Lisamine õnnestus'),
          duration: Duration(seconds: 3),
        ),
      );

      // Navigate to another page after 5 seconds.
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MinuSeadmed()),
        );
      });
    } else {
      _scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Lisamine ebaõnnestus'),
          duration: Duration(seconds: 5),
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
        key: _scaffoldMessengerKey,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    style: font,
                    controller: kasutajanimi,
                    decoration: InputDecoration(labelText: 'Shelly seadme ID'),
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Seadme ID on vajalik!';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    style: font,
                    controller: parool,
                    decoration: InputDecoration(labelText: 'Shelly cloud key'),
                    obscureText: true,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Cloud key on vajalik!';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          color: Color.fromARGB(0, 0, 0, 0),
                          width: 2,
                        )),
                    width: sinineKastLaius,
                    height: sinineKastKorgus,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: roheline,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _submitForm();
                        }
                      },
                      child: Text('Lisa seade', style: font),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          color: Color.fromARGB(0, 0, 0, 0),
                          width: 2,
                        )),
                    width: sinineKastLaius,
                    height: sinineKastKorgus,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: sinineKast,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DynaamilenieKoduLeht(i: 2)));
                      },
                      child: Text('Lisa seade Shelly kontoga', style: font),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
*/