/*
Trevor Uuna, Jaakob Lambot 27.03.2023
TalTech
*/
//Kit test
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Elering.dart';
import 'CurrentPrice.dart';
import 'Graafik.dart';
import 'OnOff.dart';
import 'Login.dart';
import 'kaksTabelit.dart';

//Maini käivitamine, home on koduleht.

void main() {
  runApp(const MaterialApp(
    home: KoduLeht(),
  ));
}

//Defineerime kodulehe

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
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text(
            'Hetkel hind (€/MWh):',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          isLoading
              ? CircularProgressIndicator()
              : Text(
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
        ]),
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
              } else if (koduindex == 0) {
                Navigator.push(
                  //Kui vajutatakse Teie seade ikooni peale, siis viiakse Seadmetelisamine lehele

                  context,

                  MaterialPageRoute(builder: (context) => MinuSeadmed()),
                );
              }
            });
          }),
    );
  }
}

//Defineerime hinnagraafiku lehe

class HinnaGraafik extends StatefulWidget {
  @override
  _HinnaGraafikState createState() => _HinnaGraafikState();
}

class _HinnaGraafikState extends State<HinnaGraafik> {
  List<dynamic> data = [];

  int koduindex =
      2; //Määrab bottom navigatsion baris sinise märgiga hetke asukoha

  String hetkepaev = '';

  List<dynamic> kiri = [];

  @override
  void initState() {
    super.initState();

    _getData();
  }

  Future<void> _getData() async {
    //Määrame mis päeva näitame

    String paev1 = 'homme';

    DateTime now = new DateTime.now();

    var date = new DateTime(now.year, now.month, now.day, now.hour);

    //Kui kell on vähem, kui 15 siis kuvab tänast päeva

    if (date.hour < 15) {
      date = now.add(new Duration(days: -1));

      paev1 = 'täna';
    }

    setState(() {
      hetkepaev = paev1; //Ütleb, mis tekst lehele tuleb. Kas homme või täna.
    });

    //saame Elergini API kaudu hinnagraafiku

    var temp = await getElering(
        paev1); //Kutsume Eleringi funktsiooni ja ütleme, mis päeva hinda me tahame

    setState(() {
      data = temp; //Annab datale hinnagraafiku
    });

    //Siit algab esimese seadme lülitusgraafiku otsimine

    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> users = prefs.getStringList('users') ??
        []; //Kutsub mälust "users" kohal olevad väärtused

    List<String> kasutajaTunnus = users[0].split(
        ','); //Teeb esimesel kohal oleva väärtuse koma juures pooleks. Sest id ja key on eraldatud komaga.

    //Küsib seadmelt lülitusgraafikut

    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    var data3 = {
      'channel': '0',
      'id': kasutajaTunnus[0].toString(),
      'auth_key': kasutajaTunnus[1].toString(),
    };

    var url3 = Uri.parse('https://shelly-64-eu.shelly.cloud/device/settings');

    var res = await http.post(url3, headers: headers, body: data3);

    //Kui post läheb läbi siis:

    if (res.statusCode == 200) {
      final httpPackageJson3 = json.decode(res.body) as Map<String, dynamic>;

      final scheduleRules1 = httpPackageJson3['data']['device_settings']
          ['relays'][0]['schedule_rules']; //Lülitusgraafiku asukoht Mapis

      var onoff = [];

      onoff.length = 24;

      for (var i = 0; i < 24; i++) {
        onoff[i] = ''; //Algväärtusab on/off kohad hinnagraafikul
      }

      List<String> newList = [];

      for (String item
          in scheduleRules1) //Iga lülituskäsu kohta teeb ühe loopi.

      {
        List<String> parts = item.split(
            '-'); //Eraldab lülituskäsu - juures lahti. Nt 2000-1-on muutub 2000 1 on, kus parts[0] on "2000", parts[1] on "1" ja parts[2] on "on".

        if (parts[1].length >
            1) //Kui parts[1] on suurem, kui ühekohaline arv, siis läheb edasi
        {
          for (int i = 0;
              i < parts[1].length;
              i++) //Iga parts[1] arvu kohta teeb ühe loopi.
          {
            String newItem = '${parts[0]}-${parts[1][i]}-${parts[2]}';

            newList.add(newItem);
          }
        } else {
          newList.add(item);
        }
      }

      var homnepaev = now.add(new Duration(days: 1));

      if (date.hour < 15) {
        homnepaev = now.add(new Duration(days: 0));
      }

      List<String> filteredRules = [];

      int paevasendus = homnepaev.weekday;

      paevasendus = paevasendus - 1;

      RegExp regExp = RegExp("-$paevasendus-");

      for (var rule in newList) {
        if (regExp.hasMatch(
            rule)) //Kui lülituskäsus on nõutud päev lisatakse see uuele stringile. Nt kui on teisipäev, ehk päev 1,
        //ja lülitusgraafikus on "2000-2-on, 2000-3-on", siis järgi ainult 2000-2-on.
        {
          filteredRules.add(rule);
        }
      }

      //Siit hakkab vaatama mis kellaajal on "on" ja millal "off"
      for (String item
          in filteredRules) //iga lülituskäsu kohta, mis on lülitusgraafikus teeb ühe loopi
      {
        List<String> parts = item.split(
            '-'); //eraldab lülituskäsu - juurtes, ehk teeb lülituskäsu kolmeks osaks

        for (var i = 0; i < 24; i++) {
          String j = i.toString();

          if (i < 10) //see on kellaaja koostamine
          {
            j = '0' + j + '00';
          } else {
            j = j + '00';
          }

          if (parts[0] ==
              j) //Kui lülituskäsu esimene osa, ehk parts[0], on võrdne hetke loopi j-ga(kellaajaga), läheb edasi
          {
            //Kui lülitukäsu kolmas osa, ehk parts[2], on "on" või "off", määrab samale kohale sõna on või off
            if (parts[2] == 'on') {
              onoff[i] = 'on';
            }

            if (parts[2] == 'off') {
              onoff[i] = 'off';
            }
          }

          if (onoff[i] == null) {
            onoff[i] = '';
          }
        }
      }

      setState(() {
        kiri = onoff; // on/off väärtused lähevad Hinnagraafiku lehele.
      });
    }
  }

  //Hinnagraafiku lehe ülesehitus

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[600],
          title: const Text('Shelly pistik'),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: DataTable(
              columns: [
                DataColumn(
                  label: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 9),
                        child: Text(
                          '$hetkepaev kuupäev',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      Text(
                        'Aasta/kuu/päev tund',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                DataColumn(
                  label: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 9),
                        child: Text(
                          'On/Off',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                ),
                DataColumn(
                  label: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 9),
                        child: Text(
                          'Hind',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      Text(
                        '€/MWh',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              rows: data.map((row) {
                var timestamp = DateTime.fromMillisecondsSinceEpoch(
                    row['timestamp'] * 1000);

                String timestamp1 =
                    DateFormat('yyyy/MM/dd HH').format(timestamp);

                final value = row['price'];

                final index = data.indexOf(row);

                final asendus = kiri.length > index ? kiri[index] : '';

                return DataRow(cells: [
                  DataCell(Text(
                    "$timestamp1:00",
                    style: TextStyle(fontSize: 17),
                  )),
                  DataCell(Text(
                    '$asendus',
                    style: TextStyle(fontSize: 17),
                  )),
                  DataCell(Text(
                    '$value',
                    style: TextStyle(fontSize: 17),
                  )),
                ]);
              }).toList(),
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
          onTap: (int index) {
            if (index == 1) {
              Navigator.push(
                //Kui vajutatakse kodu ikooni peale, siis viiakse KoduLeht lehele
                context,
                MaterialPageRoute(builder: (context) => const KoduLeht()),
              );
            } else if (index == 0) {
              Navigator.push(
                //Kui vajutatakse Teie seadmed ikooni peale, siis viiakse Seadmetelisamine lehele
                context,
                MaterialPageRoute(builder: (context) => MinuSeadmed()),
              );
            }
          },
        ));
  }
}

//Defineerime tanaste tundide valimise lehe

class TundideValimineTana extends StatelessWidget {
  TundideValimineTana({Key? key, required this.soovitudTunnid})
      : super(key: key);

  final int soovitudTunnid;

  final String valitudPaev = 'täna';

  final List<bool> selected = List<bool>.generate(
      24,
      (int index) =>
          false); //Lehe peal olevad kastid ja alguses teeb nad false-ks, ehk tühjaks

  //Määrame tänaste tundide valimise lehe struktuuri

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kinnitus',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sisselüliltus tabel'),
          actions: [
            IconButton(
              icon: Icon(Icons.navigate_next),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Graafik(
                            selected: selected,
                            valitudPaev: valitudPaev,
                          )),
                );
              },
            ),
          ],
        ),
        body: MyStatefulWidget(
          soovitudTunnid: soovitudTunnid,
          selected: selected,
        ),
      ),
    );
  }
}

//Täiendame tänaste tundide valimise lehe sisu

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({
    Key? key,
    required this.soovitudTunnid,
    required this.selected,
  }) : super(key: key);

  final int soovitudTunnid;

  final List<bool> selected;

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  static const int numItems = 24;

  late Map<dynamic, dynamic> hindMap = {};

  late int timestampMap;

//Käivitamisel toob Eleringi API-st hinna graafiku ja sorteerib selle kasvavas järjekorras

  @override
  void initState() {
    super.initState();

    _getElering();
  }

  Future<void> _getElering() async {
    String paev = 'täna';

    final data = await getElering(
        paev); //Kutsume Eleringi funktsioonist soovitud paeva hinnagraafiku

    final priceMap = new Map();

    for (var i = 0; i <= 23; i++) {
      priceMap[i] = data[i]['price'];
    }

    timestampMap = data[0]['timestamp'];

    var priceList = List.from(priceMap.values);

//Sorteerib kõige odavamad hinnad kasvavas järjekorras
    for (var i = 0; i < 24 - 1; i++) {
      for (var j = 0; j < 24 - i - 1; j++) {
        if (priceList[j] > priceList[j + 1]) {
          var temp = priceList[j];

          priceList[j] = priceList[j + 1];

          priceList[j + 1] = temp;
        }
      }
    }

    for (var i = 0; i < 24; i++) {
      widget.selected[i] = false;
    }

    //valib kõige soodsamad tunnid

    for (var i = 0; i < widget.soovitudTunnid; i++) {
      for (var j = 0; j < 24; j++) {
        if (priceList[i] ==
            priceMap[
                j]) //Hakkab võrdlema sorteerimata hinnagraafikut ja sorteeritud hinnagraafikut.
        //Kui leiab endaga sama väärtuse siis läheb edasi.

        {
          if (widget.selected[j] ==
              false) //Kui antud kast ei ole valitud, siis määrab ta valituks.
          //Kontrolli põhjus on see, et kui hind on kahel tunnil sama, siis ta määraks mõlemad kastid õigeks, aga peaks määrama ainut ühe.
          {
            widget.selected[j] = true;

            break;
          }
        }
      }
    }

    setState(() {
      hindMap = priceMap;
    });
  }

  //Täiendab tänaste tundide valimise lehe struktuuri

  @override
  Widget build(BuildContext context) {
    int koduindex = 0;

    if (hindMap.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: DataTable(
                columns: [
                  DataColumn(
                    label: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            'Kõik tunnid täna',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          '${DateFormat("yyyy/MM/dd").format(DateTime.fromMillisecondsSinceEpoch(timestampMap * 1000).toLocal())}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DataColumn(
                    label: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            'Hind',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          '€/MWh',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                rows: List<DataRow>.generate(
                  numItems,
                  (int index) => DataRow(
                    color: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.08);
                        }

                        return null;
                      },
                    ),
                    cells: <DataCell>[
                      DataCell(Text(
                        '$index:00',
                        style: TextStyle(fontSize: 20),
                      )),
                      DataCell(Text(
                        '${hindMap[index]}',
                        style: TextStyle(fontSize: 20),
                      )),
                    ],
                    selected: widget.selected[index],
                    onSelectChanged: (bool? value) {
                      setState(() {
                        widget.selected[index] = value!;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.blue[300],
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  label: 'Täna',
                  icon: Icon(Icons.schedule),
                ),
                BottomNavigationBarItem(
                  label: 'Homme',
                  icon: Icon(Icons.schedule),
                ),
              ],
              currentIndex: koduindex,
              onTap: (int kodu) {
                if (kodu == 0) {
                } else if (kodu == 1) {
                  Navigator.push(
                    //Kui vajutatakse "Homme" nuppu, siis viiakse homse graafiku koostamise lehele
                    context,
                    MaterialPageRoute(
                        builder: (context) => tundideValimineHomme(
                              soovitudTunnid: widget.soovitudTunnid,
                            )),
                  );
                }
              }));
    }
  }
}

//Defineerime homsete tundide valimise lehe

class tundideValimineHomme extends StatelessWidget {
  tundideValimineHomme({Key? key, required this.soovitudTunnid})
      : super(key: key);

  final int soovitudTunnid;

  final String valitudPaev = 'homme';

  final List<bool> selected1 = List<bool>.generate(
      24,
      (int index) =>
          false); //Lehe peal olevad kastid ja alguses teeb nad false-ks, ehk tühjaks

//Määrame homsete tundide valimise lehe struktuuri

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kinnitus',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sisselüliltus tabel'),
          actions: [
            IconButton(
              icon: Icon(Icons.navigate_next),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Graafik(
                            selected: selected1,
                            valitudPaev: valitudPaev,
                          )),
                );
              },
            ),
          ],
        ),
        body: MyStatefulWidgethomme(
          soovitudTunnid: soovitudTunnid,
          selected1: selected1,
        ),
      ),
    );
  }
}

//Täiendame homsete tundide valimise lehe sisu

class MyStatefulWidgethomme extends StatefulWidget {
  const MyStatefulWidgethomme({
    Key? key,
    required this.soovitudTunnid,
    required this.selected1,
  }) : super(key: key);

  final int soovitudTunnid;

  final List<bool> selected1;

  @override
  State<MyStatefulWidgethomme> createState() => _MyStatefulWidgetStatehomme();
}

class _MyStatefulWidgetStatehomme extends State<MyStatefulWidgethomme> {
  static const int numItems = 24;

  late Map<dynamic, dynamic> hindMap = {};

  late int timestampMap;
//Käivitamisel toob Eleringi API-st hinna graafiku ja sorteerib selle kasvavas järjekorras
  @override
  void initState() {
    super.initState();

    _getElering();
  }

  Future<void> _getElering() async {
    String paev = 'homme';

    final data = await getElering(
        paev); //Kutsume Eleringi funktsioonist soovitud paeva hinnagraafiku

    final priceMap = new Map();

    for (var i = 0; i <= 23; i++) {
      priceMap[i] = data[i]['price'];
    }

    timestampMap = data[0]['timestamp'];

    var priceList = List.from(priceMap.values);

    //Sorteerime kõige odavamad hinnad kasvavas järjekorras

    for (var i = 0; i < 24 - 1; i++) {
      for (var j = 0; j < 24 - i - 1; j++) {
        if (priceList[j] > priceList[j + 1]) {
          var temp = priceList[j];

          priceList[j] = priceList[j + 1];

          priceList[j + 1] = temp;
        }
      }
    }

    for (var i = 0; i < 24; i++) {
      widget.selected1[i] = false;
    }

    //valib kõige soodsamad tunnid

    for (var i = 0; i < widget.soovitudTunnid; i++) {
      for (var j = 0; j < 24; j++) {
        if (priceList[i] ==
            priceMap[
                j]) //Hakkab võrdlema sorteerimata hinnagraafikut ja sorteeritud hinnagraafikut.
        //Kui leiab endaga sama väärtuse siis läheb edasi.

        {
          if (widget.selected1[j] ==
              false) //Kui antud kast ei ole valitud, siis määrab ta valituks.
          //Kontrolli põhjus on see, et kui hind on kahel tunnil sama, siis ta määraks mõlemad kastid õigeks, aga peaks määrama ainut ühe.
          {
            widget.selected1[j] = true;

            break;
          }
        }
      }
    }

    setState(() {
      hindMap = priceMap;
    });
  }

//Täiendab homsete tundide valimise lehe struktuuri

  @override
  Widget build(BuildContext context) {
    int koduindex = 1;

    if (hindMap.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: DataTable(
                columns: [
                  DataColumn(
                    label: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            'Kõik tunnid homme',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          '${DateFormat("yyyy/MM/dd").format(DateTime.fromMillisecondsSinceEpoch(timestampMap * 1000).toLocal())}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DataColumn(
                    label: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            'Hind',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          '€/MWh',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                rows: List<DataRow>.generate(
                  numItems,
                  (int index) => DataRow(
                    color: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.08);
                        }

                        return null;
                      },
                    ),
                    cells: <DataCell>[
                      DataCell(Text(
                        '$index:00',
                        style: TextStyle(fontSize: 20),
                      )),
                      DataCell(Text(
                        '${hindMap[index]}',
                        style: TextStyle(fontSize: 20),
                      )),
                    ],
                    selected: widget.selected1[index],
                    onSelectChanged: (bool? value) {
                      setState(() {
                        widget.selected1[index] = value!;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.blue[300],
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  label: 'Täna',
                  icon: Icon(Icons.schedule),
                ),
                BottomNavigationBarItem(
                  label: 'Homme',
                  icon: Icon(Icons.schedule),
                ),
              ],
              currentIndex: koduindex,
              onTap: (int kodu) {
                if (kodu == 1) {
                } else if (kodu == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TundideValimineTana(
                              soovitudTunnid: widget.soovitudTunnid,
                            )),
                  );
                }
              }));
    }
  }
}

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
