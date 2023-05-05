import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/funktsioonid/Elering.dart';
import '../funktsioonid/CurrentPrice.dart';
import 'Graafik.dart';
import 'OnOff.dart';
import 'Login.dart';
import 'kaksTabelit.dart';
import 'graafikuValimine.dart';
import 'hinnaGraafik.dart';

class GraafikLeht extends StatefulWidget {
  const GraafikLeht({Key? key}) : super(key: key);

  @override
  State<GraafikLeht> createState() => _GraafikLehtState();
}

class _GraafikLehtState extends State<GraafikLeht> {
  String onoffNupp = 'Shelly ON';

  int koduindex = 1;

  int onTunnidSisestatud = 0;

  var hetkeHind = '0';

  

//Lehe avamisel toob hetke hinna ja tundide arvu

  @override
  void initState() {
    super.initState();
    
    _tooTund();
  }

//Toob tunnid mälust

  Future<void> _tooTund() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      onTunnidSisestatud = (prefs.getInt('counter') ?? 0);
    });
  }

  //Lisab tundide arvule ühe juurde

  Future<void> _tundLisa() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      if (onTunnidSisestatud < 24) {
        onTunnidSisestatud = (prefs.getInt('counter') ?? 0) +
            1; //Pluss märgile vajutades lisab tundide arvule ühe juurde

        prefs.setInt('counter', onTunnidSisestatud);
      }
    });
  }

  //Eemaldab tundide arvust ühe

  Future<void> _tundEemalda() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      if (onTunnidSisestatud > 0) {
        onTunnidSisestatud = (prefs.getInt('counter') ?? 0) -
            1; //Miinus märgile vajutades vähendab tundide arvu ühe võrra

        prefs.setInt('counter', onTunnidSisestatud);
      }
    });
  }

  //Võtab Eleringi API-st hetke hinna

  

//Määrab kodulehe struktuuri

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[600],
        title: const Text('Shelly pistik'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          
          
              Text(
                  '$hetkeHind',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
          const Text(
            'Sisselülitatud tundide arv:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          Text(
            '$onTunnidSisestatud',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: _tundEemalda,
                child: const Icon(Icons.remove),
              ),
              ElevatedButton(
                onPressed: () {
                  //Võtab soovitud tundide arvu ja saadab selle TundideValimineTana lehele

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TundideValimineTana(
                            soovitudTunnid: onTunnidSisestatud)),
                  );
                },
                child: const Icon(Icons.check_circle_outline_rounded),
              ),
              ElevatedButton(
                onPressed: _tundLisa,
                child: const Icon(Icons.add),
              ),
            ],
          ),
          
        ]),
      ),
      
    );
  }
}
