import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/lehed/kaksTabelit.dart';
//import '/SeadmeSeaded.dart';
import 'package:testuus4/lehed/seadmeSeaded.dart';
import 'energiaGraafik.dart';

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}

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
          content: Text('Login successful'),
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
          content: Text('Login unsuccessful'),
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
    var seadmed = new Map<String, dynamic>();

    for (var device in seadmeteMap.values) {
      var seade = new Map<String, dynamic>();
      seade['Seadme_ID'] = device['id'];
      seade['Seadme_nimi'] = device['name'];
      seade['Seadme_pistik']=device['name'];
      seade['Seadme_generatsioon'] = device['gen'];
      seadmed['Seade$i'] = seade;
      i++;
    }

    var keySaamiseUrl =
        Uri.parse('https://shelly-64-eu.shelly.cloud/user/get_user_key');
    var keyVastus = await http.post(keySaamiseUrl, headers: headers1);
    var keyVastusJSON = json.decode(keyVastus.body);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String seadmedMap = json.encode(seadmed);
    await prefs.setString('seadmed', seadmedMap);
    String keyMap = json.encode(keyVastusJSON['data']['key']);
    await prefs.setString('key', keyMap);
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
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
        key: _scaffoldMessengerKey,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Login'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: kasutajanimi,
                    decoration: InputDecoration(labelText: 'Username'),
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Username is required';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: parool,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _submitForm();
                      }
                    },
                    child: Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
