import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/lehed/P%C3%B5hi_Lehed/dynamicKoduLeht.dart';
//import '/SeadmeSeaded.dart';
import 'package:testuus4/lehed/uuedSeadmed.dart';
import 'package:testuus4/main.dart';
import 'package:testuus4/parameters.dart';
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
    String ajutineParool = parool.text;
    String ajutineKastuajanimi = kasutajanimi.text;
    Map<String, dynamic> seadmed;
    String sha1Hash = sha1.convert(ajutineParool.codeUnits).toString();
    List<String> uuedSeadmedString = [];
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
    String apiUrl = vastusJSON['data']["user_api_url"].toString();
    var headers1 = {
      'Authorization': 'Bearer $token',
    };

    var seadmeteSaamiseUrl =
        Uri.parse('$apiUrl/interface/device/get_all_lists');
    var seadmeteSaamiseVastus =
        await http.post(seadmeteSaamiseUrl, headers: headers1);
    var seadmeteSaamiseVastusJSON =
        json.decode(seadmeteSaamiseVastus.body) as Map<String, dynamic>;
    print(' vastus ============================ \n $seadmeteSaamiseVastusJSON');
    var seadedKasutajalt = seadmeteSaamiseVastusJSON['data']['devices'];
    print("seaded: $seadedKasutajalt");
    var i = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var storedJsonMap = prefs.getString('seadmed');
    var keySaamiseUrl = Uri.parse('$apiUrl/user/get_user_key');
    var keyVastus = await http.post(keySaamiseUrl, headers: headers1);
    var keyVastusJSON = json.decode(keyVastus.body);

    if (storedJsonMap != null) {
      var keySaamiseUrl = Uri.parse('$apiUrl/user/get_user_key');
      var keyVastus = await http.post(keySaamiseUrl, headers: headers1);
      var keyVastusJSON = json.decode(keyVastus.body);
      String keyMap = keyVastusJSON['data']['key'];
      seadmed = new Map<String, dynamic>();
      i = 0;
      for (var device in seadedKasutajalt.values) {
        if (!seadmeteMap.containsKey(device['id'])) {
          var seade = new Map<String, dynamic>();

          if(!device['id'].endsWith("_1")) {
                    seade['Seadme_nimi'] = device['name'];
          seade['Seadme_pistik'] = device['name'];
          seade['Seadme_generatsioon'] = device['gen'];
          seade['Seadme_cat'] = device['category'];
          seade['Seadme_tuup'] = device['type'];
          seade['api_url'] = apiUrl;
          seade['Seadme_pilt'] = "assets/boiler1.jpg";
          seade['Cloud_key'] = keyMap;
          seade['Username'] = ajutineKastuajanimi;
          seade['Password'] = sha1Hash;
          seade['Valitud_Tunnid'] = 12;
          seade['Hinnapiir'] = 50.50;
          seade['Seadistus_lubatud'] = false;
          seade['Max_jarjest_valjas'] = 12.0;
          seade['Kelleatud_tunnid'] = [];
          seade['Lubatud_tunnid'] = [];

          seadmed['${device['id']}'] = seade;
          i++;

          uuedSeadmedString.add(device['name']);
          }
  
        }
      }

      // await prefs.setString('seadmed', seadmedMap);

      await prefs.setString('key', json.encode(keyVastusJSON['data']['key']));
      // seisukord();

      //showCustomAlertDialog(
      //  context, seadmedMap, uuedSeadmed, uuedSeadmedString);
    } else {
      var keySaamiseUrl = Uri.parse('$apiUrl/user/get_user_key');
      var keyVastus = await http.post(keySaamiseUrl, headers: headers1);
      var keyVastusJSON = json.decode(keyVastus.body);
      String keyMap = keyVastusJSON['data']['key'];
      seadmed = new Map<String, dynamic>();
      i = 0;
      for (var device in seadedKasutajalt.values) {
        var seade = new Map<String, dynamic>();
        //seade['Seadme_ID'] = device['id'];
        if(!device['id'].endsWith("_1")) {
                seade['Seadme_nimi'] = device['name'];
        seade['Seadme_pistik'] = device['name'];
        seade['Seadme_generatsioon'] = device['gen'];
        seade['Seadme_cat'] = device['category'];
        seade['Seadme_tuup'] = device['type'];
        seade['api_url'] = apiUrl;
        seade['Seadme_pilt'] = "assets/boiler1.jpg";
        seade['Cloud_key'] = keyMap;
        seade['Username'] = ajutineKastuajanimi;
        seade['Password'] = sha1Hash;
        seade['Valitud_Tunnid'] = 12;
        seade['Hinnapiir'] = 50.50;
        seade['Seadistus_lubatud'] = false;
        seade['Max_jarjest_valjas'] = 1.0;
        seade['Kelleatud_tunnid'] = [];
        seade['Lubatud_tunnid'] = [];
        seadmed['${device['id']}'] = seade;
        i++;

        uuedSeadmedString.add(device['name']);
          }
    
      }

      // await prefs.setString('seadmed', seadmedMap);

      await prefs.setString('key', json.encode(keyVastusJSON['data']['key']));

      //showCustomAlertDialog(
      //  context, seadmedMap, uuedSeadmed, uuedSeadmedString);
    }
    //seisukord();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => uuedSeadmed(uuedSeadmedString: seadmed)),
      );
    });

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
                      child: Text('Login', style: font),
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
                                    DynaamilenieKoduLeht(i: 5)));
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

void showCustomAlertDialog(
    BuildContext context, String test, int i, List<String> uuedSeadmedString) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text('Uusi seadmed: $i \n ${uuedSeadmedString.toString()}'),
      );
    },
  );
}
