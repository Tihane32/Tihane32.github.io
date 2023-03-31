/*
Trevor Uuna, Jaakob Lambot 27.03.2023
TalTech
*/
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Kontroll lehe loomine
class Kontroll extends StatefulWidget {
  @override
  _KontrollState createState() => _KontrollState();
}

class _KontrollState extends State<Kontroll> {
  List<String> _stringList = [];
  String? aeg = '';

  @override
  void initState() {
    super.initState();
    _loadStringList();
  }

  Future<void> _loadStringList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> stringList = prefs.getStringList('vastus') ??
        []; //Võtab mälust 'vastus' asukohast väärtused, siin on Shelly responsid graafiku koostamisele
    final String? asendus = prefs.getString(
        'Aeg'); //Võtab mälust 'Aeg' asukohast väärtused, siin on Ajahetk, kui Shelly responsid loodi

    setState(() {
      _stringList = stringList;
      aeg = asendus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kontroll'),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => KoduLeht()),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '$aeg',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _stringList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_stringList[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
