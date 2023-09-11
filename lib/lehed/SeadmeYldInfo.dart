import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testuus4/lehed/AbiLeht.dart';
import 'package:testuus4/lehed/SeadmeGraafikLeht.dart';
import 'package:testuus4/lehed/TarbimisLeht.dart';
import 'package:testuus4/lehed/seadmedKontoltNim.dart';
import 'package:testuus4/main.dart';
import 'SeadmeTarbimisLeht.dart';

class SeadmeYldinfoLeht extends StatefulWidget {
  const SeadmeYldinfoLeht(
      {Key? key, required this.seadmeNimi, required this.SeadmeteMap})
      : super(key: key);

  final String seadmeNimi;
  final Map<String, List<String>> SeadmeteMap;
  @override
  _SeadmeYldinfoLehtState createState() =>
      _SeadmeYldinfoLehtState(seadmeNimi: seadmeNimi, SeadmeteMap: SeadmeteMap);
}

class _SeadmeYldinfoLehtState extends State<SeadmeYldinfoLeht> {
  _SeadmeYldinfoLehtState(
      {Key? key, required this.seadmeNimi, required this.SeadmeteMap});
  String seadmeNimi;
  Map<String, List<String>> SeadmeteMap;
  late Map<int, dynamic> lulitusMap;
  int selectedRowIndex = -1;
  late double hindAVG;
  String paevNupp = 'Täna';
  String selectedPage = 'Üldinfo';
  String onoffNupp = 'Shelly ON';
  String uusNimi = '';
  var hetkeHind = '0';

  var hetkevoismus = '0';

  var ajatarbimine = '0';

  var kulu = '0';
  bool isLoading = false;
  String selectedOption = 'Nädala';
  List<String> dropdownOptions = ['Nädala', 'Kuu', 'Aasta'];
  double vahe = 20;

  Color boxColor = sinineKast;

  TextStyle fontLaadimine() {
    return GoogleFonts.roboto(
      textStyle: TextStyle(
        fontSize: 20,
        color: isLoading ? Colors.grey : Colors.black,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  BorderRadius borderRadius = BorderRadius.circular(5.0);

  Border border = Border.all(
    color: const Color.fromARGB(255, 0, 0, 0),
    width: 2,
  );
//Lehe avamisel toob hetke hinna ja tundide arvu

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255), //TaustavÃ¤rv

      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 115, 162, 195),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              seadmeNimi,
              style: GoogleFonts.roboto(
                textStyle: const TextStyle(fontSize: 25),
              ),
            ),
            Spacer(),
          ],
        ),
        actions: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: boxColor,
              ),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButton<String>(
                icon: Icon(Icons.menu),
                value: selectedPage,style: font ,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedPage = newValue!;
                  });
                  if (selectedPage == 'Tarbimisgraafik') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TarbimisLeht(
                                seadmeNimi: seadmeNimi,
                                SeadmeteMap: SeadmeteMap,
                              )),
                    );
                  } else if (selectedPage == 'Lülitusgraafik') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SeadmeGraafikuLeht(
                              seadmeNimi: seadmeNimi,
                              SeadmeteMap: SeadmeteMap)),
                    );
                  }
                },
                underline: Container(), // or SizedBox.shrink()
                items: <String>['Lülitusgraafik', 'Tarbimisgraafik', 'Üldinfo']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
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
                      )),
                  width: sinineKastLaius,
                  height: sinineKastKorgus,
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextField(
                        // textAlignVertical: TextAlignVertical.center,
                        //cursorWidth: 0,
                        onSubmitted: (value) {
                          setState(() {
                            uusNimi = value;
                            SeadmeteMap =
                                nimeMuutmine(seadmeNimi, SeadmeteMap, uusNimi);
                            seadmeNimi = uusNimi;
                          });
                        },
                        decoration: InputDecoration(
                            hintText: '$seadmeNimi',
                            hintStyle: font,
                            floatingLabelStyle: font),
                      ),
                    ),
                  )),
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
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        iconSize: 20,
                        onPressed: () {
                          setState(() {
                            SeadmeteMap =
                                muudaSeadmeOlek(SeadmeteMap, seadmeNimi);
                          });
                        },
                        icon: Icon(
                          Icons.camera_alt_outlined,
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
                      TextSpan(text: SeadmeteMap[seadmeNimi]![3], style: font),
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
                      TextSpan(text: SeadmeteMap[seadmeNimi]![1], style: font),
                    ],
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

loeSeadmeOlek(Map<String, List<String>> SeadmeteMap, SeadmeNimi) {
  List<String>? deviceInfo = SeadmeteMap[SeadmeNimi];
  if (deviceInfo != null) {
    String status = deviceInfo[2];
    return status;
  }
  return null; // Device key not found in the map
}

muudaSeadmeOlek(Map<String, List<String>> SeadmeteMap, SeadmeNimi) {
  List<String>? deviceInfo = SeadmeteMap[SeadmeNimi];
  if (deviceInfo != null) {
    String status = deviceInfo[2];

    if (status == 'on') {
      deviceInfo[2] = 'off';
      SeadmeteMap[SeadmeNimi] = deviceInfo;
    } else if (status == 'off') {
      deviceInfo[2] = 'on';
      SeadmeteMap[SeadmeNimi] = deviceInfo;
    }
    return SeadmeteMap;
  }
  return SeadmeteMap; // Device key not found in the map
}

nimeMuutmine(
    String seadmeNimi, Map<String, List<String>> seadmeteMap, String uusNimi) {
  List<String>? info = seadmeteMap[seadmeNimi];
  Map<String, List<String>> newSeadmeteMap = Map.from(seadmeteMap);
  newSeadmeteMap[uusNimi] = info!;
  newSeadmeteMap.remove(seadmeNimi);
  return newSeadmeteMap;
}
