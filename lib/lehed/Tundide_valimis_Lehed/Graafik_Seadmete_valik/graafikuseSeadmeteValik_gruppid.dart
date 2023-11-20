import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testuus4/funktsioonid/graafikGen1.dart';
import 'package:testuus4/funktsioonid/graafikGen2.dart';
import 'package:testuus4/lehed/Seadme_Lehed/SeadmeGraafikLeht.dart';
import 'package:testuus4/widgets/hoitatus.dart';
import '../../../funktsioonid/seisukord.dart';
import '../../../funktsioonid/token.dart';
import '../../../widgets/PopUpGraafik.dart';
import '../DynaamilineTundideValimine.dart';
import '../../Põhi_Lehed/dynamicKoduLeht.dart';
import 'package:testuus4/main.dart';
import 'package:http/http.dart' as http;

class SeadmeteListValimine_guruppid extends StatefulWidget {
  final Function saaValitudSeadmed;
  const SeadmeteListValimine_guruppid(
      {Key? key, required this.saaValitudSeadmed})
      : super(key: key);

  @override
  State<SeadmeteListValimine_guruppid> createState() =>
      _SeadmeteListValimine_guruppidState(
        saaValitudSeadmed: saaValitudSeadmed,
      );
}

class _SeadmeteListValimine_guruppidState
    extends State<SeadmeteListValimine_guruppid> {
  _SeadmeteListValimine_guruppidState({
    Key? key,
    required this.saaValitudSeadmed,
  });
  Function saaValitudSeadmed;
  Map<String, bool> ValitudSeadmed = {};
  List valitudGrupp = [];
  bool isLoading = false;

  dynamic seadmeGraafik;
  @override
  int koduindex = 1;

  Set<String> selectedPictures = Set<String>();

  void toggleSelection(String pictureName) {
    setState(() {
      if (selectedPictures.contains(pictureName)) {
        selectedPictures.remove(pictureName);
      } else {
        selectedPictures.add(pictureName);
      }
    });
  }

  _submitForm() async {
    // await SeadmeGraafikKontrollimineGen1();

    //await prefs.clear();

    /* minuSeadmedK.addAll(ajutineMap);
        if (minuSeadmedK[name]![4] == '1') {
          minuSeadmedK[name]![5] = await SeadmeGraafikKontrollimineGen1(id);
        } else if (minuSeadmedK[name]![4] == '2') {
          minuSeadmedK[name]![5] =
              'ei'; //await SeadmeGraafikKontrollimineGen2(id);
        }*/
  }

  @override
  initState() {
    //_submitForm();
    ValitudSeadmed = valitudSeadmeteNullimine();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backround,
      body: GestureDetector(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 5),
                ),
                itemCount: gruppiMap.length,
                itemBuilder: (context, index) {
                  final grupp = gruppiMap.keys.elementAt(index);
                  final gruppiPilt = gruppiMap[grupp]["Gruppi_pilt"];
                  final grupiOlek = gruppiMap[grupp]["Gruppi_olek"];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (valitudGrupp.contains(grupp)) {
                          valitudGrupp.remove(grupp);
                        } else {
                          valitudGrupp.add(grupp);
                        }
                      });
                      ValitudSeadmed =
                          valitudSeadmetevaartustamine(valitudGrupp);
                      saaValitudSeadmed(ValitudSeadmed);
                      print(ValitudSeadmed);
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
                              color: valitudGrupp.contains(grupp)
                                  ? Colors.green
                                  : Colors.grey,
                              width: 8,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                  color: valitudGrupp.contains(grupp)
                                      ? Color.fromARGB(255, 177, 245, 180)
                                      : Color.fromARGB(255, 236, 228, 228)),
                              Center(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: ClipRRect(
                                    child: Image.asset(
                                      gruppiPilt,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child:
                                    true //seadmeteMap[grupp]["Graafik"] == 'ei'
                                        ? IconButton(
                                            iconSize: 60,
                                            icon: Icon(
                                              Icons.warning_amber_rounded,
                                              size: 80,
                                              color: Colors.amber,
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                        title: Text(
                                                            "  $grupp graafik puudub"),
                                                      ));
                                            },
                                          )
                                        : IconButton(
                                            iconSize: 60,
                                            icon: Icon(
                                              Icons.fact_check_outlined,
                                              size: 80,
                                              color: Colors.blue,
                                            ),
                                            onPressed: () async {},
                                          ),
                              ),
                              Positioned(
                                top: 25,
                                left: 8,
                                child: Container(
                                    child: grupiOlek == 'Offline'
                                        ? Icon(
                                            Icons.wifi_off_outlined,
                                            size: 60,
                                            color: Colors.amber,
                                          )
                                        : Icon(
                                            Icons.wifi,
                                            size: 60,
                                            color: Colors.blue,
                                          )),
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
                                      grupp.toString(),
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

Map<String, bool> valitudSeadmetevaartustamine(List valitudGrupp) {
  Map<String, bool> valitudSeadmed = {};

  seadmeteMap.forEach((key, value) async {
    valitudSeadmed[key] = false;
  });

  for (var grupp in valitudGrupp) {
    List seadmed = gruppiMap[grupp]['Grupi_Seadmed'];
    for (var item in seadmed) {
      if (item is String) {
        valitudSeadmed[item] = true;
      }
    }
  }

  return valitudSeadmed;
}
