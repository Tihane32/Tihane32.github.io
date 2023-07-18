import 'package:flutter/material.dart';
import 'package:testuus4/main.dart';
import 'package:testuus4/lehed/drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testuus4/funktsioonid/maksumus.dart';

import 'navigationBar.dart';

class MinuPakett extends StatefulWidget {
  @override
  _MinuPakettState createState() => _MinuPakettState();
}

class _MinuPakettState extends State<MinuPakett> {
  double hind = 45;
  TextEditingController textController = TextEditingController();
  double vahe = 20;
  bool edastaminePakett = false;
  bool value = true;
  bool valueTeavitus = true;
  bool edastamineKuu = false;
  bool edastamine3 = false;
  bool edastamine2 = false;
  bool edastamine1 = false;
  String selectedOption = 'Võrgupakett:';
  List<String> dropdownOptions = [
    'Võrgupakett:',
    'Võrgupakett 1',
    'Võrgupakett 2',
    'Võrgupakett 3',
    'Võrgupakett 4',
    'Võrgupakett 5'
  ];
  String selectedOptionElektrimuuja = 'Elektrimüüja:';
  List<String> dropdownOptionsElektrimuuja = [
    'Elektrimüüja:',
    'Eesti Energia',
    '220 Energia',
    'Elektrum Eesti',
    'Eesti Gaas',
    'VKG',
    'Alexela'
  ];
  String selectedOptionElektriPakett = 'Elektrimüüja pakett:';
  List<String> dropdownOptionsElektriPakett = [
    'Elektrimüüja pakett:',
    'Valige enne elektrimüüja'
  ];
  String selectedOptionElektriPakettAlgne = 'Elektrimüüja pakett:';
  List<String> dropdownOptionsElektriPakettAlgne = [
    'Elektrimüüja pakett:',
    'Valige enne elektrimüüja'
  ];

  String selectedOptionAlexela = 'Alexela pakett:';
  List<String> dropdownOptionsAlexela = [
    'Alexela pakett:',
    'Pingevaba',
    'Tähtajaline kindel hind',
    'Kodupakett börsihinnaga',
    'Universaalteenus',
  ];
  String selectedOptionKuu = 'Korter';
  List<String> dropdownOptionsKuu = [
    'Korter',
    'kuni 16 A',
    '20 A',
    '25 A',
    '32 A',
    '40 A',
    '50 A',
    '63 A',
  ];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    textController.text =
        hind.toString(); // Set the initial value for the TextField
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backround,
        appBar: AppBar(
          backgroundColor: appbar,
          title: Text(
            'Minu pakett',
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(fontSize: 25),
            ),
          ),
          actions: [
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                  padding: const EdgeInsets.only(right: 20),
                  icon: const Icon(
                    Icons.menu,
                    size: 30,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              },
            ),
          ],
        ),
        endDrawer: drawer(),
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
                /*image: DecorationImage(
              image: AssetImage('assets/tuulik7.jpg'),
              alignment: Alignment.bottomCenter,
            ),*/
                ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 20, 8, 8),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: sinineKast,
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
                              //width: 100,
                              height: sinineKastKorgus,
                              child: Center(
                                child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  text: TextSpan(
                                    style: font,
                                    text: 'Elektrilevi pakett',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Center(child: SizedBox(width: vahe)),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                color: roheline,
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
                              height: sinineKastKorgus,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      underline: Container(
                                        // Replace the default underline
                                        height: 0,
        
                                        color: Colors
                                            .black, // Customize the underline color
                                      ),
                                      dropdownColor: roheline,
                                      borderRadius: borderRadius,
                                      value: selectedOption,
                                      icon: Visibility(
                                          visible: false,
                                          child: Icon(Icons.arrow_downward)),
                                      onChanged: (String? newValue) async {
                                        // Use an async function
                                        setState(() {
                                          selectedOption = newValue!;
                                          // Show the loading animation
                                          if (selectedOption == 'Võrgupakett 2') {
                                            edastamine3 = false;
                                            edastamine2 = true;
                                            edastamine1 = false;
                                          }
                                          if (selectedOption == 'Võrgupakett 1') {
                                            edastamine3 = false;
                                            edastamine1 = true;
                                            edastamine2 = false;
                                          }
                                          if (selectedOption == 'Võrgupakett 5') {
                                            edastamine3 = true;
                                            edastamine2 = true;
                                            edastamine1 = false;
                                          }
        
                                          if (selectedOption != 'Võrgupakett:') {
                                            edastamineKuu = true;
                                          }
                                          if (selectedOption == 'Võrgupakett:') {
                                            edastamine3 = false;
                                            edastamine2 = false;
                                            edastamine1 = false;
                                            edastamineKuu = false;
                                          }
                                          // Call the async function and wait for the result
                                          maksumus(selectedOption).then((result) {
                                            setState(() {
                                              // Hide the loading animation
                                            });
                                          });
                                        });
                                      },
                                      items: dropdownOptions
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 8.0),
                                            child: Text(value, style: font),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: vahe),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: sinineKast,
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
                              //width: 100,
                              height: sinineKastKorgus,
                              child: Center(
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: font,
                                    text: 'Elektrimüüja',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: vahe),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                color: roheline,
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
                              height: sinineKastKorgus,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  DropdownButton<String>(
                                    underline: Container(
                                      // Replace the default underline
                                      height: 0,
        
                                      color: Colors
                                          .black, // Customize the underline color
                                    ),
                                    dropdownColor: roheline,
                                    borderRadius: borderRadius,
                                    value: selectedOptionElektrimuuja,
                                    icon: Visibility(
                                        visible: false,
                                        child: Icon(Icons.arrow_downward)),
                                    onChanged: (String? newValue) async {
                                      // Use an async function
                                      setState(() {
                                        selectedOptionElektrimuuja = newValue!;
        
                                        if (selectedOptionElektrimuuja ==
                                            'Alexela') {
                                          selectedOptionElektriPakett =
                                              selectedOptionAlexela;
                                          dropdownOptionsElektriPakett =
                                              dropdownOptionsAlexela;
                                        }
                                        if (selectedOptionElektrimuuja ==
                                            'Elektrimüüja:') {
                                          edastaminePakett = false;
                                          selectedOptionElektriPakett =
                                              selectedOptionElektriPakettAlgne;
                                          dropdownOptionsElektriPakett =
                                              dropdownOptionsElektriPakettAlgne;
                                        }
                                        // Show the loading animation
        
                                        // Call the async function and wait for the result
                                        maksumus(selectedOptionElektrimuuja)
                                            .then((result) {
                                          setState(() {
                                            // Hide the loading animation
                                          });
                                        });
                                      });
                                    },
                                    items: dropdownOptionsElektrimuuja
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text('  ' + value, style: font),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: vahe),
                    Visibility(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: sinineKast,
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
                                //width: 100,
                                height: sinineKastKorgus,
                                child: Center(
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: font,
                                      text: 'Elektrimüüja pakett',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: vahe),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  color: roheline,
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
                                height: sinineKastKorgus,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        underline: Container(
                                          // Replace the default underline
                                          height: 0,
        
                                          color: Colors
                                              .black, // Customize the underline color
                                        ),
                                        dropdownColor: roheline,
                                        borderRadius: borderRadius,
                                        value: selectedOptionElektriPakett,
                                        icon: Visibility(
                                            visible: false,
                                            child: Icon(Icons.arrow_downward)),
                                        onChanged: (String? newValue) async {
                                          // Use an async function
                                          setState(() {
                                            selectedOptionElektriPakett =
                                                newValue!;
                                            // Show the loading animation
                                            if (selectedOptionElektriPakett ==
                                                'Pingevaba') {
                                              edastaminePakett = true;
                                            }
        
                                            // Call the async function and wait for the result
                                            maksumus(selectedOptionElektriPakett)
                                                .then((result) {
                                              setState(() {
                                                isLoading =
                                                    false; // Hide the loading animation
                                              });
                                            });
                                          });
                                        },
                                        items: dropdownOptionsElektriPakett
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(value, style: font),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: vahe * 3),
                    Visibility(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: roheline,
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
                        height: sinineKastKorgus,
                        child: Row(
                          children: [
                            Expanded(
                                child: Center(
                                    child: Text('Elektri edastamine päev',
                                        style: font))),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: TextField(
                                    //textAlignVertical: TextAlignVertical.top,
        
                                    style: font,
                                    controller: textController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      isDense: true,
                                      suffixText: 'senti / kWh',
                                    ),
                                    keyboardType: TextInputType.number,
                                    onSubmitted: (value) {
                                     
                                      // Handle the value change here
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      visible: edastamine2,
                      /* maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,*/
                    ),
                    Visibility(
                      child: SizedBox(height: vahe),
                      visible: edastamine2,
                    ),
                    Visibility(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: roheline,
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
                        height: sinineKastKorgus,
                        child: Row(
                          children: [
                            Expanded(
                                child: Center(
                                    child: Text('Elektri edastamine päev tipuaeg',
                                        style: font))),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: TextField(
                                    //textAlignVertical: TextAlignVertical.top,
        
                                    style: font,
                                    controller: textController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      isDense: true,
                                      suffixText: 'senti / kWh',
                                    ),
                                    keyboardType: TextInputType.number,
                                    onSubmitted: (value) {
                                      if (value == '67') {
                                        print('yeeeee');
                                      }
                                      // Handle the value change here
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      visible: edastamine3,
                      /* maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,*/
                    ),
                    Visibility(
                      child: SizedBox(height: vahe),
                      visible: edastamine3,
                    ),
        
                    Visibility(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: roheline,
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
                        height: sinineKastKorgus,
                        child: Row(
                          children: [
                            Expanded(
                                child: Center(
                                    child: Text('Elektri edastamine öö',
                                        style: font))),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: TextField(
                                    //textAlignVertical: TextAlignVertical.top,
        
                                    style: font,
                                    controller: textController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      isDense: true,
                                      suffixText: 'senti / kWh',
                                    ),
                                    keyboardType: TextInputType.number,
                                    onSubmitted: (value) {
                                      if (value == '67') {
                                        print('yeeeee');
                                      }
                                      // Handle the value change here
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      visible: edastamine2,
                    ),
                    Visibility(
                      child: SizedBox(height: vahe),
                      visible: edastamine2,
                    ),
                    Visibility(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: roheline,
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
                        height: sinineKastKorgus,
                        child: Row(
                          children: [
                            Expanded(
                                child: Center(
                                    child: Text(
                                        'Elektri edastamine puhkepäeva tipuaeg',
                                        style: font))),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: TextField(
                                    //textAlignVertical: TextAlignVertical.top,
        
                                    style: font,
                                    controller: textController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      isDense: true,
                                      suffixText: 'senti / kWh',
                                    ),
                                    keyboardType: TextInputType.number,
                                    onSubmitted: (value) {
                                      if (value == '67') {
                                        print('yeeeee');
                                      }
                                      // Handle the value change here
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      visible: edastamine3,
                      /* maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,*/
                    ),
                    Visibility(
                      child: SizedBox(height: vahe),
                      visible: edastamine3,
                    ),
        
                    Visibility(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: roheline,
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
                        height: sinineKastKorgus,
                        child: Row(
                          children: [
                            Expanded(
                                child: Center(
                                    child:
                                        Text('Elektri edastamine', style: font))),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: TextField(
                                    //textAlignVertical: TextAlignVertical.top,
        
                                    style: font,
                                    controller: textController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      isDense: true,
                                      suffixText: 'senti / kWh',
                                    ),
                                    keyboardType: TextInputType.number,
                                    onSubmitted: (value) {
                                      if (value == '67') {
                                        print('yeeeee');
                                      }
                                      // Handle the value change here
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      visible: edastamine1,
                    ),
                    Visibility(
                      child: SizedBox(height: vahe),
                      visible: edastamine1,
                    ),
        
                    Visibility(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: roheline,
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
                        height: sinineKastKorgus,
                        child: Row(
                          children: [
                            Expanded(
                                child:
                                    Center(child: Text('Kuutasu', style: font))),
                            DropdownButton<String>(
                              underline: Container(
                                // Replace the default underline
                                height: 0,
        
                                color:
                                    Colors.black, // Customize the underline color
                              ),
                              dropdownColor: roheline,
                              borderRadius: borderRadius,
                              value: selectedOptionKuu,
                              icon: Visibility(
                                  visible: false,
                                  child: Icon(Icons.arrow_downward)),
                              onChanged: (String? newValue) async {
                                // Use an async function
                                setState(() {
                                  selectedOptionKuu = newValue!;
                                  // Show the loading animation
        
                                  // Call the async function and wait for the result
                                  maksumus(selectedOptionKuu).then((result) {
                                    setState(() {
                                      // Hide the loading animation
                                    });
                                  });
                                });
                              },
                              items: dropdownOptionsKuu
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(value, style: font),
                                  ),
                                );
                              }).toList(),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: TextField(
                                    //textAlignVertical: TextAlignVertical.top,
        
                                    style: font,
                                    controller: textController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      isDense: true,
                                      suffixText: '€ / kuu',
                                    ),
                                    keyboardType: TextInputType.number,
                                    onSubmitted: (value) {
                                      if (value == '67') {
                                        print('yeeeee');
                                      }
                                      // Handle the value change here
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      visible: edastamineKuu,
                    ),
                    Visibility(
                      child: SizedBox(height: vahe),
                      visible: edastaminePakett,
                    ),
                    Visibility(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: sinineKast,
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
                        height: sinineKastKorgus,
                        child: Row(
                          children: [
                            Expanded(
                                child:
                                    Center(child: Text('Baashind', style: font))),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: TextField(
                                    //textAlignVertical: TextAlignVertical.top,
        
                                    style: font,
                                    controller: textController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      isDense: true,
                                      suffixText: 'senti / kWh',
                                    ),
                                    keyboardType: TextInputType.number,
                                    onSubmitted: (value) {
                                      if (value == '67') {
                                        print('yeeeee');
                                      }
                                      // Handle the value change here
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      visible: edastaminePakett,
                    ),
                    Visibility(
                      child: SizedBox(height: vahe),
                      visible: edastaminePakett,
                    ),
        
                    Visibility(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: sinineKast,
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
                        height: sinineKastKorgus,
                        child: Row(
                          children: [
                            Expanded(
                                child: Center(
                                    child: Text('Marginaal', style: font))),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: TextField(
                                    //textAlignVertical: TextAlignVertical.top,
        
                                    style: font,
                                    controller: textController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      isDense: true,
                                      suffixText: 'senti / kWh',
                                    ),
                                    keyboardType: TextInputType.number,
                                    onSubmitted: (value) {
                                      if (value == '67') {
                                        print('yeeeee');
                                      }
                                      // Handle the value change here
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      visible: edastaminePakett,
                    ),
                    Visibility(
                      child: SizedBox(height: vahe),
                      visible: edastaminePakett,
                    ),
                    Visibility(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: sinineKast,
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
                        height: sinineKastKorgus,
                        child: Row(
                          children: [
                            Expanded(
                                child:
                                    Center(child: Text('Kuutasu', style: font))),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: TextField(
                                    //textAlignVertical: TextAlignVertical.top,
        
                                    style: font,
                                    controller: textController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      isDense: true,
                                      suffixText: '€ / kuu',
                                    ),
                                    keyboardType: TextInputType.number,
                                    onSubmitted: (value) {
                                      if (value == '67') {
                                        print('yeeeee');
                                      }
                                      // Handle the value change here
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      visible: edastaminePakett,
                    ),
                    // Add some spacing between the two widgets
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.black,
                width: 2.0,
              ),
            ),
          ),
          child: SizedBox(
            height: navBarHeight,
            child: AppNavigationBar(i: 3),
          ),
        ));
  }
}
