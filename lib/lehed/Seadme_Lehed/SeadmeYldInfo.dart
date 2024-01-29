import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testuus4/funktsioonid/lulitamine.dart';
import 'package:testuus4/lehed/P%C3%B5hi_Lehed/dynamicKoduLeht.dart';
import 'package:testuus4/widgets/AbiLeht.dart';
import 'package:testuus4/lehed/Seadme_Lehed/SeadmeGraafikLeht.dart';
import 'package:testuus4/lehed/Seadme_Lehed/SeadmePildiMuutmine.dart';
import 'package:testuus4/lehed/TarbimisLeht.dart';
import 'package:testuus4/Arhiiv/seadmedKontoltNim.dart';
import 'package:testuus4/main.dart';
import '../../Arhiiv/SeadmeTarbimisLeht.dart';
import 'dynamicSeadmeInfo.dart';
import 'package:testuus4/parameters.dart';

class SeadmeYldinfoLeht extends StatefulWidget {
  const SeadmeYldinfoLeht(
      {Key? key, required this.seadmeNimi, required this.SeadmeteMap})
      : super(key: key);

  final String seadmeNimi;
  final Map<String, dynamic> SeadmeteMap;
  @override
  _SeadmeYldinfoLehtState createState() =>
      _SeadmeYldinfoLehtState(seadmeNimi: seadmeNimi, SeadmeteMap: SeadmeteMap);
}

class _SeadmeYldinfoLehtState extends State<SeadmeYldinfoLeht> {
  _SeadmeYldinfoLehtState(
      {Key? key, required this.seadmeNimi, required this.SeadmeteMap});
  String seadmeNimi;
  Map<String, dynamic> SeadmeteMap;
  late Map<int, dynamic> lulitusMap;
  int selectedRowIndex = -1;
  late double hindAVG;

  String uusNimi = '';

  double vahe = 20;
  String mudel = "";
  String id = "";
  Color boxColor = sinineKast;

  BorderRadius borderRadius = BorderRadius.circular(5.0);

  Border border = Border.all(
    color: const Color.fromARGB(255, 0, 0, 0),
    width: 2,
  );
//Lehe avamisel toob hetke hinna ja tundide arvu

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    setState(() {
      mudel = SeadmeteMap[seadmeNimi]["Seadme_pistik"];
      id = seadmeNimi;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255), //TaustavÃ¤rv
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                    color: Color.fromARGB(0, 0, 0, 0),
                    width: 2,
                  ),
                ),
                width: sinineKastLaius,
                height: sinineKastKorgus,
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextField(
                      // Ensure that the style is applied to the TextField
                      style: font, // Apply your TextStyle here
                      // textAlignVertical: TextAlignVertical.center,
                      // cursorWidth: 0,
                      onSubmitted: (value) {
                        setState(() {
                          uusNimi = value;

                          nimeMuutmine(seadmeNimi, uusNimi);
                          seadmeNimi = uusNimi;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: '$seadmeNimi',
                        hintStyle: font,
                        floatingLabelStyle: font,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: vahe),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: boxColor,
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: Color.fromARGB(0, 0, 0, 0),
                      width: 2,
                    )),
                width: sinineKastLaius,
                height: sinineKastKorgus,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: RichText(
                        text: TextSpan(
                          style: font,
                          children: [
                            TextSpan(text: 'Seadme pilt:', style: font),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.all(0.0),
                        iconSize: 30,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DunaamilineSeadmeLeht(
                                seadmeNimi: seadmeNimi,
                                SeadmeteMap: SeadmeteMap,
                                valitud: 3,
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.photo_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: vahe),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: boxColor,
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: Color.fromARGB(0, 0, 0, 0),
                      width: 2,
                    )),
                width: sinineKastLaius,
                height: sinineKastKorgus,
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(text: 'Seadme mudel: ', style: font),
                      TextSpan(text: mudel, style: font),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: vahe), // Add some spacing between the two widgets
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: boxColor,
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: Color.fromARGB(0, 0, 0, 0),
                      width: 2,
                    )),
                width: sinineKastLaius,
                height: sinineKastKorgus,
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(text: 'Seadme ID: ', style: font),
                      TextSpan(text: id, style: font),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: vahe),
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  seadmeteMap.remove(id);
                  gruppiMap.forEach((key, value) async {
                    if (value["Grupi_Seadmed"].contains(id)) {
                      (value["Grupi_Seadmed"] as List).remove(id);
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('gruppid', json.encode(gruppiMap));
                    }
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DynaamilenieKoduLeht(i: 1),
                    ),
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: boxColor,
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                        color: Color.fromARGB(0, 0, 0, 0),
                        width: 2,
                      )),
                  width: sinineKastLaius,
                  height: sinineKastKorgus,
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(text: 'Kustuta seade', style: font),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

loeSeadmeOlek(SeadmeNimi) {
  String deviceInfo = seadmeteMap[SeadmeNimi]["Seadme_olek"];
  if (deviceInfo != null) {
    String pilt = deviceInfo;
    return pilt;
  }
  return null; // Device key not found in the map
}

muudaSeadmeOlek(SeadmeNimi) {
  String deviceInfo = seadmeteMap[SeadmeNimi]["Seadme_olek"];
  if (deviceInfo != null) {
    String status = deviceInfo;

    if (status == 'on') {
      deviceInfo = 'off';
      seadmeteMap[SeadmeNimi]["Seadme_olek"] = deviceInfo;
      lulitamine(SeadmeNimi);
    } else if (status == 'off') {
      deviceInfo = 'on';
      seadmeteMap[SeadmeNimi]["Seadme_olek"] = deviceInfo;
      lulitamine(SeadmeNimi);
    }
    return seadmeteMap;
  }
  return seadmeteMap; // Device key not found in the map
}

nimeMuutmine(String seadmeNimi, String uusNimi) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //await prefs.clear();

  String? storedJsonMap = prefs.getString('seadmed');
  if (storedJsonMap != null) {
    storedJsonMap = prefs.getString('seadmed');
    Map<String, dynamic> storedMap = json.decode(storedJsonMap!);
    var i = 0;

    storedMap[seadmeNimi]['Seadme_nimi'] = uusNimi;

    String keyMap = json.encode(storedMap);
    prefs.setString('seadmed', keyMap);
    seadmeteMap = storedMap;
  }
}

pildiMuutmine(String seadmeNimi, String uusPilt) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //await prefs.clear();

  String? storedJsonMap = prefs.getString('seadmed');
  if (storedJsonMap != null) {
    storedJsonMap = prefs.getString('seadmed');
    Map<String, dynamic> storedMap = json.decode(storedJsonMap!);

    storedMap[seadmeNimi]['Seadme_pilt'] = uusPilt;
    String keyMap = json.encode(storedMap);
    prefs.setString('seadmed', keyMap);
    seadmeteMap = storedMap;
  }
}
