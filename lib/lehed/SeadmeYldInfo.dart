import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testuus4/lehed/AbiLeht.dart';
import 'package:testuus4/lehed/seadmedKontoltNim.dart';
import 'package:testuus4/main.dart';
import 'SeadmeTarbimisLeht.dart';

class SeadmeYldinfoLeht extends StatefulWidget {
  const SeadmeYldinfoLeht({Key? key, required this.seadmeNimi})
      : super(key: key);

  final String seadmeNimi;

  @override
  _SeadmeYldinfoLehtState createState() =>
      _SeadmeYldinfoLehtState(seadmeNimi: seadmeNimi);
}

class _SeadmeYldinfoLehtState extends State<SeadmeYldinfoLeht> {
  _SeadmeYldinfoLehtState({Key? key, required this.seadmeNimi});
  final String seadmeNimi;
  late Map<int, dynamic> lulitusMap;
  int selectedRowIndex = -1;
  late double hindAVG;
  String paevNupp = 'Täna';
  String selectedPage = 'Üldinfo';

  String onoffNupp = 'Shelly ON';

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

  Map<String, List<String>> SeadmeteMap = {
    'Keldri boiler': [
      'assets/boiler1.jpg',
      '80646f81ad9a',
      'off',
      'Shelly plug S',
    ],
    'Veranda lamp': [
      'assets/verandaLamp1.png',
      '80646f81ad9a',
      'offline',
      'Shelly plug S',
    ],
    'veranda lamp': [
      'assets/verandaLamp1.png',
      '80646f81ad9a',
      'on',
      'Shelly plug S',
    ],
    'Keldri pump': [
      'assets/pump1.jpg',
      '80646f81ad9a',
      'on',
      'Shelly plug S',
    ],
    'Garaazi pump': [
      'assets/pump1.jpg',
      '80646f81ad9a',
      'offline',
      'Shelly plug S',
    ],
    'Main boiler': [
      'assets/boiler1.jpg',
      '80646f81ad9a',
      'on',
      'Shelly plug S',
    ],
    'Sauna boiler': [
      'assets/boiler1.jpg',
      '80646f81ad9a',
      'off',
      'Shelly plug S',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 189, 216, 225), //TaustavÃ¤rv

        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 115, 162, 195),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(seadmeNimi),
              Spacer(),
            ],
          ),
          actions: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButton<String>(
                  value: selectedPage,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPage = newValue!;
                    });
                    if (selectedPage == 'Tarbimis graafik') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SeadmeTarbimineLeht(seadmeNimi: seadmeNimi)),
                      );
                    } else if (selectedPage == 'Üldinfo') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AbiLeht()),
                      );
                    }
                  },
                  underline: Container(), // or SizedBox.shrink()
                  items: <String>[
                    'Lülitus graafik',
                    'Tarbimis graafik',
                    'Üldinfo'
                  ].map((String value) {
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
        body: Column(
          children: [
            SizedBox(height: vahe),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: borderRadius,
                  border: border,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(3, 3),
                    ),
                  ],
                ),
                width: sinineKastLaius,
                height: sinineKastKorgus + 20,
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(text: '  Seadme staatus:    ', style: font),
                          TextSpan(
                            text: SeadmeteMap[seadmeNimi]![2],
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        iconSize: 40,
                        onPressed: () {
                          setState(() {
                            SeadmeteMap =
                                muudaSeadmeOlek(SeadmeteMap, seadmeNimi);
                          });
                        },
                        icon:
                            loeSeadmeOlek(SeadmeteMap, seadmeNimi) == 'offline'
                                ? Icon(Icons.wifi_off_outlined)
                                : loeSeadmeOlek(SeadmeteMap, seadmeNimi) == 'on'
                                    ? Icon(
                                        Icons.power_settings_new_rounded,
                                        color: Color.fromARGB(255, 77, 152, 81),
                                      )
                                    : Icon(
                                        Icons.power_settings_new_rounded,
                                        color: Colors.red,
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
                  borderRadius: borderRadius,
                  border: border,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(3, 3),
                    ),
                  ],
                ),
                width: sinineKastLaius,
                height: sinineKastKorgus,
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(text: '  Seadme nimi: ', style: font),
                          TextSpan(text: seadmeNimi, style: fontLaadimine()),
                        ],
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SeadmeNimi(
                                      value: '',
                                    )),
                          );
                        },
                        icon: Icon(
                          Icons.edit,
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
                  borderRadius: borderRadius,
                  border: border,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(3, 3),
                    ),
                  ],
                ),
                width: sinineKastLaius,
                height: sinineKastKorgus,
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(text: '  Seadme pilt: ', style: font),
                        ],
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
                  borderRadius: borderRadius,
                  border: border,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(3, 3),
                    ),
                  ],
                ),
                width: sinineKastLaius,
                height: sinineKastKorgus,
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(text: '  Seadme mudel: ', style: font),
                      TextSpan(
                          text: SeadmeteMap[seadmeNimi]![3],
                          style: fontLaadimine()),
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
                  borderRadius: borderRadius,
                  border: border,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(3, 3),
                    ),
                  ],
                ),
                width: sinineKastLaius,
                height: sinineKastKorgus,
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(text: '  Seadme ID: ', style: font),
                      TextSpan(
                          text: SeadmeteMap[seadmeNimi]![1],
                          style: fontLaadimine()),
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
