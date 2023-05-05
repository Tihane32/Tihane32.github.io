import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/funktsioonid/Elering.dart';
import 'CurrentPrice.dart';
import 'Graafik.dart';
import 'OnOff.dart';
import 'Login.dart';
import 'kaksTabelit.dart';
import 'graafikuValimine.dart';
import 'hinnaGraafik.dart';

class KoduLeht extends StatefulWidget {
  const KoduLeht({Key? key}) : super(key: key);

  @override
  State<KoduLeht> createState() => _KoduLehtState();
}

class _KoduLehtState extends State<KoduLeht> {
  String onoffNupp = 'Shelly ON';

  int koduindex = 1;

  int onTunnidSisestatud = 0;

  var hetkeHind = '0';

  bool isLoading = false;

//Lehe avamisel toob hetke hinna ja tundide arvu

  @override
  void initState() {
    super.initState();
    _getCurrentPrice();
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

  Future<void> _getCurrentPrice() async {
    setState(() {
      isLoading =
          true; //Enne hinna saamist kuvab ekraanile laadimis animatsiooni
    });

    final data =
        await getCurrentPrice(); //Kutsub esile CurrentPrice funktsiooni

    //Võtab data Mapist 'price' väärtuse

    var ajutine = data.entries.toList();

    var ajutine1 = ajutine[1].value;

    double price = ajutine1[0]['price'];

    setState(() {
      hetkeHind = price.toString(); //Salvestab pricei hetke hinnaks
    });

    setState(() {
      isLoading = false; //Pärast hinna saamist laadimis animatsioon lõppeb
    });
  }

//Määrab kodulehe struktuuri

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[600],
        title: const Text('Shelly pistik'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "https://www.google.com/url?sa=i&url=https%3A%2F%2Fdepositphotos.com%2Fvector-images%2Flightning.html&psig=AOvVaw0ejPIecxjBZkJJI89VuceR&ust=1683181176916000&source=images&cd=vfe&ved=0CBEQjRxqFwoTCPCDqdLA2P4CFQAAAAAdAAAAABAU"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Hetkel hind (€/MWh):',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              isLoading
                  ? CircularProgressIndicator()
                  : Text(
                      '$hetkeHind',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
              Text(
                'Shelly töörežiim:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(
                    () {
                      if (onoffNupp == 'Shelly OFF') {
                        onoffNupp = 'Shelly ON';

                        onoff(
                            "on"); //Kui on "on", siis kutsub esile funktsiooni onoff, mis lülitab seadme sisse
                      } else if (onoffNupp == 'Shelly ON') {
                        onoffNupp = 'Shelly OFF';

                        onoff(
                            "off"); //Kui on "off", siis kutsub esile funktsiooni onoff, mis lülitab seadme välja
                      }
                    },
                  );
                },
                child: Text(onoffNupp),
              ),
            ],
          ),
        ),
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
                  //Kui vajutatakse Hinnagraafiku ikooni peale, siis viiakse Hinnagraafiku lehele

                  context,

                  MaterialPageRoute(builder: (context) => HinnaGraafik()),
                );
              } else if (koduindex == 0) {}
            });
          }),
    );
  }
}
