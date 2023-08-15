import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/lehed/kaksTabelit.dart';
import 'package:testuus4/lehed/lisaSeade.dart';
//import '/SeadmeSeaded.dart';
import 'package:testuus4/lehed/seadmeSeaded.dart';
import 'package:testuus4/main.dart';
import 'energiaGraafik.dart';
import 'package:testuus4/funktsioonid/seisukord.dart';
import 'package:testuus4/lehed/koduleht.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController kasutajanimi = TextEditingController();
  final TextEditingController parool = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  Future<void> _submitForm() async {
    String ajutineParool = parool.text as String;
    String ajutineKastuajanimi = kasutajanimi.text as String;

    String sha1Hash = sha1.convert(ajutineParool.codeUnits).toString();

    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    var kasutajaAndmed = {
      'email': ajutineKastuajanimi,
      'password': sha1Hash,
      'var': '2',
    };
    var sisselogimiseUrl = Uri.parse('https://api.shelly.cloud/auth/login');
    var sisselogimiseVastus = await http.post(sisselogimiseUrl,
        headers: headers, body: kasutajaAndmed);
    if (sisselogimiseVastus.statusCode == 200) {
      _scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text('Sisselogimine õnnestus'),
          duration: Duration(seconds: 3),
        ),
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('Kasutajanimi', ajutineKastuajanimi);
      await prefs.setString('Kasutajaparool', sha1Hash);

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
          content: Text('Sisselogimine ebaõnnestus'),
          duration: Duration(seconds: 5),
        ),
      );
      return;
    }
    var vastusJSON =
        json.decode(sisselogimiseVastus.body) as Map<String, dynamic>;
    var token = vastusJSON['data']['token'];

    var headers1 = {
      'Authorization': 'Bearer $token',
    };

    var seadmeteSaamiseUrl = Uri.parse(
        'https://shelly-64-eu.shelly.cloud/interface/device/get_all_lists');
    var seadmeteSaamiseVastus =
        await http.post(seadmeteSaamiseUrl, headers: headers1);
    var seadmeteSaamiseVastusJSON =
        json.decode(seadmeteSaamiseVastus.body) as Map<String, dynamic>;
    var seadmeteMap = seadmeteSaamiseVastusJSON['data']['devices'];

    var i = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var storedJsonMap = prefs.getString('seadmed');

    if (storedJsonMap != null) {
      print('korras');

      Map<String, dynamic> seadmed = json.decode(storedJsonMap);

      var j = 0;

      for (var device in seadmeteMap.values) {
        var seade = new Map<String, dynamic>();
        seade['Seadme_ID'] = device['id'];
        print('alg');
        print(seade['Seadme_ID']);
        print(seadmed['Seade$i']['Seadme_ID']);
        print('lõpp');
        for (var test = seadmed.keys.length; j < test; j++) {
          print('pikkus');
          print(seadmed['Seade$i']['Seadme_ID']);
          print(seadmed['Seade$j']['Seadme_ID']);
          print('pikkus');

          print(j);
          print(seadmed);

          if (seade['Seadme_ID'] == seadmed['Seade$j']['Seadme_ID']) {
            print('break');
            j++;
            break;
          }
          print('no break $j');

          seade['Seadme_nimi'] = device['name'];
          seade['Seadme_pistik'] = device['name'];
          seade['Seadme_generatsioon'] = device['gen'];
          seadmed['Seade$i'] = seade;
        }

        i++;
      }
      var keySaamiseUrl =
          Uri.parse('https://shelly-64-eu.shelly.cloud/user/get_user_key');
      var keyVastus = await http.post(keySaamiseUrl, headers: headers1);
      var keyVastusJSON = json.decode(keyVastus.body);

      String seadmedMap = json.encode(seadmed);
      await prefs.setString('seadmed', seadmedMap);
      String keyMap = json.encode(keyVastusJSON['data']['key']);
      await prefs.setString('key', keyMap);
    } else {
      var seadmed = new Map<String, dynamic>();
      i = 0;
      for (var device in seadmeteMap.values) {
        print('uus device: $device');
        var seade = new Map<String, dynamic>();
        seade['Seadme_ID'] = device['id'];
        seade['Seadme_nimi'] = device['name'];
        seade['Seadme_pistik'] = device['name'];
        seade['Seadme_generatsioon'] = device['gen'];
        print(seade['Seadme_generatsioon']);
        seadmed['Seade$i'] = seade;
        i++;
      }
      var keySaamiseUrl =
          Uri.parse('https://shelly-64-eu.shelly.cloud/user/get_user_key');
      var keyVastus = await http.post(keySaamiseUrl, headers: headers1);
      var keyVastusJSON = json.decode(keyVastus.body);

      String seadmedMap = json.encode(seadmed);
      await prefs.setString('seadmed', seadmedMap);
      String keyMap = json.encode(keyVastusJSON['data']['key']);
      await prefs.setString('key', keyMap);
      print(seadmedMap);
    }

    /* Näide kuidas võtta mälust seadmete map
    String? storedJsonMap = prefs.getString('seadmed');
    if (storedJsonMap != null) {
      Map<String, dynamic> storedMap = json.decode(storedJsonMap);
      /*
      Näide, kuidas saada kätte kindla seadme id.
      var testmap;
      testmap = storedMap['Seade0'];
      testmap = storedMap['Seade0']['Seadme_ID'];
      */
    }
    */

    /*Näide kuidas võtta mälust auth key
    
    String? storedKey = prefs.getString('key');
    if (storedKey != null) {
      String storedKeyString = jsonDecode(storedKey);
      print(storedKeyString);
    }
    */
    seisukord();
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
                    decoration:
                        InputDecoration(labelText: 'Shelly kasutajanimi'),
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Kasutajanime on vaja!';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    style: font,
                    controller: parool,
                    decoration: InputDecoration(labelText: 'Shelly salasõna'),
                    obscureText: true,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Salasõna on vaja!';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          color: const Color.fromARGB(255, 0, 0, 0),
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
                      child: Text('Login', style: font),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          color: const Color.fromARGB(255, 0, 0, 0),
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
                                builder: (context) => LisaSeade()));
                      },
                      child: Text('Lisa seade manuaalselt', style: font),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
