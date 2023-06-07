import 'package:flutter/material.dart';
import 'package:testuus4/funktsioonid/KeskmineHind.dart';
import '../funktsioonid/CurrentPrice.dart';
import 'kaksTabelit.dart';
import 'hinnaGraafik.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testuus4/funktsioonid/hetketarbimine.dart';
import 'package:testuus4/funktsioonid/tarbimine.dart';
import 'package:testuus4/funktsioonid/maksumus.dart';

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

  var hetkevoismus = '0';

  var ajatarbimine = '0';

  var kulu = '0';
  bool isLoading = false;

//Lehe avamisel toob hetke hinna ja tundide arvu

  @override
  void initState() {
    super.initState();
    _getCurrentPrice();
  }

//Toob tunnid mälust

  //Lisab tundide arvule ühe juurde

  //Võtab Eleringi API-st hetke hinna

  Future<void> _getCurrentPrice() async {
    getKeskmineHind(); //testimiseks 
    setState(() {
      isLoading =
          true; //Enne hinna saamist kuvab ekraanile laadimis animatsiooni
    });
    final hetkeW = await voimus();
    final data =
        await getCurrentPrice(); //Kutsub esile CurrentPrice funktsiooni
    final test = await tarbimine();
    print(test);
    final temp = await maksumus();
    //Võtab data Mapist 'price' väärtuse

    var ajutine = data.entries.toList();

    var ajutine1 = ajutine[1].value;

    double price = ajutine1[0]['price'];
    print('price: $price');
    price = price / 1000.0;

    num n = num.parse(price.toStringAsFixed(2));
    price = n as double;
    print('price: $price');
    setState(() {
      hetkeHind = price.toString();
      //Salvestab pricei hetke hinnaks
      hetkevoismus = hetkeW.toString();
      ajatarbimine = test.toString();
      kulu = temp.toString();
    });

    setState(() {
      isLoading = false; //Pärast hinna saamist laadimis animatsioon lõppeb
    });
  }

//Määrab kodulehe struktuuri

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 208, 236, 239),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 115, 162, 195),
        title: Text(
          'Shelly app',
          style: GoogleFonts.openSans(
            textStyle: TextStyle(fontSize: 25),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/tuulik7.jpg'),
            alignment: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 237, 202, 146),
                      borderRadius: BorderRadius.circular(14.0),
                      border: Border.all(
                        color: Color.fromARGB(30, 0, 0, 0),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(3, 3),
                        ),
                      ],
                    ),
                    width: 250,
                    height: 35,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: '  Hetkel hind: ',
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          TextSpan(
                            text: '$hetkeHind €/kWh',
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: isLoading ? Colors.grey : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    height: 10), // Add some spacing between the two widgets
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 237, 202, 146),
                      borderRadius: BorderRadius.circular(14.0),
                      border: Border.all(
                        color: Color.fromARGB(30, 0, 0, 0),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(3, 3),
                        ),
                      ],
                    ),
                    width: 300,
                    height: 35,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: '  Hetkel tarbimine: ',
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          TextSpan(
                            text: '$hetkevoismus W',
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: isLoading ? Colors.grey : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    height: 10), // Add some spacing between the two widgets
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 237, 202, 146),
                      borderRadius: BorderRadius.circular(14.0),
                      border: Border.all(
                        color: Color.fromARGB(30, 0, 0, 0),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(3, 3),
                        ),
                      ],
                    ),
                    width: 250,
                    height: 35,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: '  Kuu tarbimine: ',
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          TextSpan(
                            text: '$ajatarbimine kWh',
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: isLoading ? Colors.grey : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    height: 10), // Add some spacing between the two widgets
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 237, 202, 146),
                      borderRadius: BorderRadius.circular(14.0),
                      border: Border.all(
                        color: Color.fromARGB(30, 0, 0, 0),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(3, 3),
                        ),
                      ],
                    ),
                    width: 300,
                    height: 35,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: '  Kuu maksumus: ',
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          TextSpan(
                            text: '$kulu €',
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: isLoading ? Colors.grey : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HinnaGraafik()),
                      );
                    },
                    child: // Add some spacing between the two widgets
                        Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 157, 214, 171),
                          borderRadius: BorderRadius.circular(14.0),
                          border: Border.all(
                            color: Color.fromARGB(200, 0, 0, 0),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(3, 3),
                            ),
                          ],
                        ),
                        width: 240,
                        height: 35,
                        child: Row(
                          children: [
                            
                            Text(
                              '  Graafiku koostamine ',
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ),Icon(
                              Icons.calendar_month,
                              color: Colors.black,
                            ),
                            SizedBox(width: 5),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 115, 162, 195),
        fixedColor: Color.fromARGB(255, 157, 214, 171),
        unselectedItemColor: Colors.white,
        selectedIconTheme: IconThemeData(size: 30),
        unselectedIconTheme: IconThemeData(size: 26),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: 'Seadmed',
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
            } else if (koduindex == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MinuSeadmed()),
              );
            }
          });
        },
        selectedLabelStyle: TextStyle(
          fontFamily: GoogleFonts.openSans().fontFamily,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: GoogleFonts.openSans().fontFamily,
        ),
      ),
    );
  }
}
