import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testuus4/lehed/SeadmeGraafikLeht.dart';
import 'package:testuus4/lehed/TarbimisLeht.dart';
import 'package:testuus4/main.dart';
import 'SeadmeYldInfo.dart';

class DunaamilineSeadmeLeht extends StatefulWidget {
  DunaamilineSeadmeLeht(
      {Key? key,
      required this.seadmeNimi,
      required this.SeadmeteMap,
      required this.valitud})
      : super(key: key);

  final String seadmeNimi;
  final Map<String, List<String>> SeadmeteMap;
  int valitud;
  @override
  _DunaamilineSeadmeLehtState createState() => _DunaamilineSeadmeLehtState(
      seadmeNimi: seadmeNimi, SeadmeteMap: SeadmeteMap, valitud: valitud);
}

class _DunaamilineSeadmeLehtState extends State<DunaamilineSeadmeLeht> {
  _DunaamilineSeadmeLehtState(
      {Key? key,
      required this.seadmeNimi,
      required this.SeadmeteMap,
      required this.valitud});
  String seadmeNimi;
  Map<String, List<String>> SeadmeteMap;
  int valitud;
  String selectedPage = 'Lülitusgraafik';
  Color boxColor = sinineKast;

  late final List<Widget> lehedSeadme;

  @override
  void initState() {
    super.initState();
    lehedSeadme = [
      SeadmeGraafikuLeht(
        SeadmeteMap: SeadmeteMap,
        seadmeNimi: seadmeNimi,
      ),
      TarbimisLeht(
        SeadmeteMap: SeadmeteMap,
        seadmeNimi: seadmeNimi,
      ),
      SeadmeYldinfoLeht(
        SeadmeteMap: SeadmeteMap,
        seadmeNimi: seadmeNimi,
      ),
    ];
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
                value: selectedPage, style: font,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedPage = newValue!;
                  });
                  if (selectedPage == 'Lülitusgraafik') {
                    valitud = 0;
                  } else if (selectedPage == 'Tarbimisgraafik') {
                    valitud = 1;
                  } else if (selectedPage == 'Üldinfo') {
                    valitud = 2;
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
      body: IndexedStack(
        index: valitud,
        children: lehedSeadme,
      ),
    );
  }
}
