import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testuus4/funktsioonid/lulitamine.dart';
import 'dart:async';
import '../../funktsioonid/salvestaGrupp.dart';
import '../Tundide_valimis_Lehed/Graafik_Seadmete_valik/DynaamilineGraafikusseSeadmeteValik.dart';
import '../Põhi_Lehed/dynamicKoduLeht.dart';
import 'package:testuus4/funktsioonid/seisukord.dart';
import 'package:testuus4/main.dart';
import '../Seadme_Lehed/dynamicSeadmeInfo.dart';

class GruppiKoostamine extends StatefulWidget {
  const GruppiKoostamine({Key? key}) : super(key: key);

  @override
  State<GruppiKoostamine> createState() => _GruppiKoostamineState();
}

class _GruppiKoostamineState extends State<GruppiKoostamine> {
  Map<String, bool> ValitudSeadmed = {};
  int koduindex = 1;
  double xAlign = -1;
  double signInAlign = 1;
  double loginAlign = -1;
  double width = 200;
  double height = 40;
  String tempAndur = 'Lisa temperatuuri Andur';
  String niiskusAndur = 'Lisa niiskus Andur';
  String valgusAndur = 'Lisa valgus Andur';
  String gruppiNimi = '';
  List<String> listTemp = <String>['Lisa temperatuuri Andur'];
  List<String> listNiis = <String>['Lisa niiskus Andur'];
  List<String> listValg = <String>['Lisa valgus Andur'];

  @override
  void initState() {
    super.initState();
    ValitudSeadmed = valitudSeadmeteNullimine();
    listTemp = andurListiKoostamine(listTemp, 'Temp_andurid');
    listNiis = andurListiKoostamine(listNiis, 'Niiskus_andurid');
    //listValg = andurListiKoostamine(listValg, 'valgus_andurid');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backround,
      appBar: AppBar(
        toolbarHeight: 250,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        title: Container(
          height: 240,
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Container(
                  width: 250,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Center(
                      child: TextField(
                    onSubmitted: (value) {
                      setState(() {
                        gruppiNimi = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      hintText: 'Gruppi nimi',
                      alignLabelWithHint: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
                    ),
                    style: font,
                  )),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              ListTile(
                title: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 255, 116, 106),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      style: font,
                      dropdownColor: Color.fromARGB(255, 243, 145, 132),
                      borderRadius: borderRadius,
                      value: tempAndur,
                      onChanged: (andur) {
                        setState(() {
                          tempAndur = andur!;
                        });
                      },
                      items: listTemp
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              ListTile(
                title: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 76, 153, 167),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      style: font,
                      dropdownColor: Color.fromARGB(255, 231, 246, 248),
                      borderRadius: borderRadius,
                      value: niiskusAndur,
                      onChanged: (andur) {
                        setState(() {
                          niiskusAndur = andur!;
                        });
                      },
                      items: listNiis
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              ListTile(
                title: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 66, 66, 66),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      style: font,
                      dropdownColor: Color.fromARGB(255, 172, 172, 172),
                      borderRadius: borderRadius,
                      value: valgusAndur,
                      onChanged: (andur) {
                        setState(() {
                          valgusAndur = andur!;
                        });
                      },
                      items: listValg
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: GridView.builder(
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: seadmeteMap.length,
        itemBuilder: (context, index) {
          final seade = seadmeteMap.keys.elementAt(index);
          final pilt = seadmeteMap[seade]["Seadme_pilt"];
          final staatus = seadmeteMap[seade]["Seadme_olek"];
          print('Staatus: $staatus');
          return GestureDetector(
            onTap: () {
              setState(() {
                if (ValitudSeadmed[seade] == false) {
                  ValitudSeadmed[seade] = true;
                } else {
                  ValitudSeadmed[seade] = false;
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(1),
              child: Container(
                decoration: BoxDecoration(
                  border: border,
                ),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ValitudSeadmed[seade] == true
                          ? Colors.green
                          : Colors.grey,
                      width: 8,
                    ),
                  ),
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: ClipRRect(
                          child: Image.asset(
                            pilt,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Colors.blue.withOpacity(0.6),
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Center(
                            child: Text(
                              seadmeteMap[seade]["Seadme_nimi"],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Visibility(
        visible: ValitudSeadmed.values.any((value) => value == true) &&
            gruppiNimi != '',
        child: SizedBox(
          height: navBarHeight,
          child: Stack(
            children: [
              Positioned(
                  top: -5,
                  left: 0,
                  right: 0,
                  child: BottomNavigationBar(
                      backgroundColor: Color.fromARGB(255, 115, 162, 195),
                      fixedColor: Color.fromARGB(255, 157, 214, 171),
                      unselectedLabelStyle: TextStyle(
                        color: Color.fromARGB(255, 157, 214, 171),
                      ),
                      selectedLabelStyle: TextStyle(
                        color: Color.fromARGB(255, 157, 214, 171),
                      ),
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          label: '',
                          icon: Icon(
                            Icons.check_circle_outlined,
                            size: 0,
                          ),
                        ),
                        BottomNavigationBarItem(
                          label: 'Kinnita',
                          icon: Icon(
                            Icons.check_circle_outlined,
                            size: 30,
                            color: Color.fromARGB(255, 157, 214, 171),
                          ),
                        ),
                        BottomNavigationBarItem(
                          label: '',
                          icon: Icon(
                            Icons.check_circle_outlined,
                            size: 0,
                          ),
                        ),
                      ],
                      onTap: (int kodu) {
                        SalvestaUusGrupp(gruppiNimi, ValitudSeadmed);
                      })),
            ],
          ),
        ),
      ),
    );
  }
}

Map<String, bool> valitudSeadmeteNullimine() {
  Map<String, bool> ValitudSeadmed = {};
  seadmeteMap.forEach((key, value) async {
    ValitudSeadmed[key] = false;
  });
  return ValitudSeadmed;
}

andurListiKoostamine(List<String> list, String tuup) {
  anduriteMap[tuup].forEach((id, value) {
    var anduriNimi = value['Anduri_nimi'];
    if (anduriNimi != null && anduriNimi.isNotEmpty) {
      list.add(anduriNimi);
    }
  });
  return list;
}
