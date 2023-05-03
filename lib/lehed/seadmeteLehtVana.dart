import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'Elering.dart';
import 'package:testuus4/funktsioonid/Elering.dart';
import 'CurrentPrice.dart';
import 'Graafik.dart';
import 'OnOff.dart';
import 'Login.dart';
import 'kaksTabelit.dart';
import 'koduleht.dart';
import 'graafikuValimine.dart';
import 'hinnaGraafik.dart';

//defineerime kasutaja info

class kasutaja {
  String id;

  String key;

  kasutaja({required this.id, required this.key});

  String toString() {
    return "$id,$key";
  }

  static kasutaja fromString(String userString) {
    List<String> userData = userString.split(',');

    return kasutaja(id: userData[0], key: userData[1]);
  }
}

//defineerime seadmete lisamis lehe

class Seadmetelisamine extends StatefulWidget {
  @override
  _SeadmetelisamineState createState() => _SeadmetelisamineState();
}

class _SeadmetelisamineState extends State<Seadmetelisamine> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _idController = TextEditingController();

  final TextEditingController _keyController = TextEditingController();

  int koduindex = 0;

  List<kasutaja> _users = [];

//Lehe käivitamisel võtab mälust seadmete info ja kuvab seda lehel
  @override
  void initState() {
    super.initState();

    _TooKasutajaInfo();
  }

//toome seadmemalust kasutaja info

  @override
  void _TooKasutajaInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> users = prefs.getStringList('users') ??
        []; //Võtab mälust kohal "users" väärtused

    List<kasutaja> loadedUsers =
        users.map((user) => kasutaja.fromString(user)).toList();

    setState(() {
      _users.addAll(loadedUsers);
    });
  }

//lisame mäluse kasutaja info

  void _LisaKasutajaInfo() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      List<String> users = prefs.getStringList('users') ?? [];

      kasutaja newUser = kasutaja(
        id: _idController.text,
        key: _keyController.text,
      );

      users.add(newUser.toString());

      prefs.setStringList('users', users);

      setState(() {
        _users.add(newUser);

        _idController.clear();

        _keyController.clear();
      });
    }
  }

//Eemaldame mälust kasutja info

  void _EemaldaKasutajaInfo(kasutaja userToRemove) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> users = prefs.getStringList('users') ?? [];

    users.remove(userToRemove.toString());

    prefs.setStringList('users', users);

    setState(() {
      _users.remove(userToRemove);
    });
  }

//Määrame kasutaja lisamise lehe

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[600],
        title: const Text('Shelly pistik'),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginApp()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _idController,
                    decoration: InputDecoration(
                      labelText: 'ID',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Palun sisesta ID';
                      }

                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _keyController,
                    decoration: InputDecoration(
                      labelText: 'Key',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Palun sisesta key';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _LisaKasutajaInfo,
                    child: Text('Lisa'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (BuildContext context, int index) {
                final user = _users[index];

                return Dismissible(
                    key: ValueKey(user),
                    onDismissed: (direction) => _EemaldaKasutajaInfo(user),
                    child: ListTile(
                      title: Text('ID: ${user.id}'),
                      subtitle: Text('Key: ${user.key}'),
                    ));
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.red[600],
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: 'Teie seade',
              icon: Icon(Icons.electrical_services_rounded),
            ),
            BottomNavigationBarItem(
              label: 'Kodu',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: 'Hinnagraafik',
              icon: Icon(Icons.table_rows_outlined),
            ),
          ],
          currentIndex: koduindex,
          onTap: (int kodu) {
            setState(() {
              koduindex = kodu;

              if (koduindex == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HinnaGraafik()),
                );
              } else if (koduindex == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const KoduLeht()),
                );
              }
            });
          }),
    );
  }
}
