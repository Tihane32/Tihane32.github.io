import 'package:flutter/material.dart';
import 'package:testuus4/funktsioonid/KeskmineHind.dart';
import 'package:testuus4/lehed/Login.dart';
import 'package:testuus4/lehed/abiLeht.dart';
import 'package:testuus4/lehed/kasutajaSeaded.dart';
import 'package:testuus4/lehed/rakenduseSeaded.dart';
import 'kaksTabelit.dart';
import 'hinnaGraafik.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testuus4/funktsioonid/hetketarbimine.dart';
import 'package:testuus4/funktsioonid/tarbimine.dart';
import 'package:testuus4/funktsioonid/maksumus.dart';
import 'hindJoonise.dart';
import '../funktsioonid/hetke_hind.dart';
import 'package:testuus4/main.dart';
import 'minuPakett.dart';

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
  String selectedOption = 'Nädala';
  List<String> dropdownOptions = ['Nädala', 'Kuu', 'Aasta'];
  double vahe = 20;
  double sinineKastLaius = double.infinity;
  double sinineKastKorgus = 45;
  Color boxColor = sinineKast;
  TextStyle font = GoogleFonts.roboto(
      textStyle: const TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 20,
  ));
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

    //TODO: Lisada käibemaks ja võrguteenustasud
    final test = await tarbimine();
    print(test);
    isLoading = false;

    //Võtab data Mapist 'price' väärtuse

    var ajutine = data.entries.toList();

    var ajutine1 = ajutine[1].value;

    double price = ajutine1[0]['price'];
    print('price: $price');
    price = price / 1000.0;

    num n = num.parse(price.toStringAsFixed(4));
    price = n as double;
    print('price: $price');
    setState(() {
      hetkeHind = price.toString();
      //Salvestab pricei hetke hinnaks
      hetkevoismus = hetkeW.toString();
      ajatarbimine = test.toString();
    });
    final temp = await maksumus(selectedOption);
    setState(() {
      kulu = temp.toString(); //Pärast hinna saamist laadimis animatsioon lõppeb
    });
  }

//Määrab kodulehe struktuuri

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backround,
        appBar: AppBar(
          backgroundColor: appbar,
          title: Text(
            'Shelly App',
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(fontSize: 25),
            ),
          ),
          actions: [
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                  padding: EdgeInsets.only(right: 20),
                  icon: Icon(
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
        endDrawer: Drawer(
          width: MediaQuery.of(context).size.width * 0.65,
          child: Container(
            color: const Color.fromARGB(
                255, 115, 162, 195), // Set the desired background color
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Drawer items...
                ListTile(),
                ListTile(
                  leading: Icon(
                    Icons.login,
                    size: 32,
                  ),
                  title: RichText(
                    text: TextSpan(
                      text: 'Shelly Login',
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    // Navigate to the home page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginApp()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.add_circle_outline_outlined,
                    size: 32,
                  ),
                  title: RichText(
                    text: TextSpan(
                      text: 'Lisa seade',
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    // Navigate to the home page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginApp()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.manage_accounts,
                    size: 32,
                  ),
                  title: RichText(
                    text: TextSpan(
                      text: 'Kasutaja seaded',
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    // Navigate to the home page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => KasutajaSeaded()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.phonelink_setup, size: 32),
                  title: RichText(
                    text: TextSpan(
                      text: 'Rakenduse seaded',
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    // Navigate to the home page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RakenduseSeaded()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.help_outline_outlined,
                    size: 32, // Adjust the size as needed
                  ),
                  title: RichText(
                    text: TextSpan(
                      text: 'Abi',
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    // Navigate to the home page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AbiLeht()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        body: Container(
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
                            TextSpan(text: '  Hetke hind: ', style: font),
                            TextSpan(
                                text: '$hetkeHind €/kWh',
                                style: fontLaadimine()),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: vahe), // Add some spacing between the two widgets
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
                            TextSpan(
                                text: 'Seadmete hetke tarbimine: ',
                                style: font),
                            TextSpan(
                                text: '$hetkevoismus W',
                                style: fontLaadimine()),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: vahe), // Add some spacing between the two widgets
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
                            TextSpan(
                                text: '  Seadmete kuu tarbimine: ',
                                style: font),
                            TextSpan(
                                text: '$ajatarbimine kWh',
                                style: fontLaadimine()),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: vahe), // Add some spacing between the two widgets
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DropdownButton<String>(
                            icon: const Icon(Icons.expand_circle_down_outlined,
                                color: Color.fromARGB(255, 0, 0, 0)),
                            value: selectedOption,
                            onChanged: (String? newValue) async {
                              // Use an async function
                              setState(() {
                                selectedOption = newValue!;
                                isLoading = true; // Show the loading animation

                                // Call the async function and wait for the result
                                maksumus(selectedOption).then((result) {
                                  setState(() {
                                    kulu = result.toString();
                                    isLoading =
                                        false; // Hide the loading animation
                                  });
                                });
                              });
                            },
                            items: dropdownOptions
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text('  ' + value + ' maksumus:',
                                    style: font),
                              );
                            }).toList(),
                          ),
                          Text(" $kulu €", style: fontLaadimine()),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: vahe * 2),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MinuPakett()),
                        );
                      },
                      child: // Add some spacing between the two widgets
                          Align(
                        alignment: Alignment.center,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: roheline,
                            borderRadius: borderRadius,
                            border: border,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(3, 3),
                              ),
                            ],
                          ),
                          width: 175,
                          height: sinineKastKorgus,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('  Minu pakett ', style: font),
                              const Icon(
                                Icons.account_circle_rounded,
                                color: Colors.black,
                                size: 30,
                              ),
                              const SizedBox(width: 5),
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.black,
                width: 2.0,
              ),
            ),
          ),
          child: SizedBox(
            height: 70,
            child: BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              backgroundColor: roheline,
              fixedColor: Colors.black,
              unselectedItemColor: Colors.black,
              //selectedIconTheme: const IconThemeData(size: 35),
              //unselectedIconTheme: const IconThemeData(size: 35),
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  label: '',
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .end, // Adjust the spacing between icons
                      children: [
                        Icon(
                          Icons.person_outlined,
                          size: 40,
                        ),
                        SizedBox(
                            width: 30), // Adjust the spacing between the icons
                      ],
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  label: '',
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Adjust the spacing between icons
                      children: [
                        Icon(
                          Icons.home_outlined,
                          size: 40,
                        ),
                        SizedBox(
                            width: 0), // Adjust the spacing between the icons
                      ],
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  label: '',
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .end, // Adjust the spacing between icons
                      children: [
                        Transform.rotate(
                          angle: 90 * 0.0174533, // Convert degrees to radians
                          child: Icon(
                            Icons.leaderboard_outlined,
                            size: 35,
                          ),
                        ),

                        SizedBox(
                            width: 65), // Adjust the spacing between the icons
                      ],
                    ),
                  ),
                ),
              ],

              currentIndex: koduindex,
              onTap: (int kodu) {
                setState(() {
                  koduindex = kodu;

                  if (koduindex == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NordHinnad()),
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
                fontFamily: GoogleFonts.roboto().fontFamily,
              ),
              unselectedLabelStyle: TextStyle(
                fontFamily: GoogleFonts.roboto().fontFamily,
              ),
            ),
          ),
        ));
  }
}
/*
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuButtonTap;

  const MyAppBar({required this.onMenuButtonTap});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 115, 162, 195),
      title: Text(
        'Shelly app',
        style: GoogleFonts.roboto(
          textStyle: const TextStyle(fontSize: 25),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: onMenuButtonTap,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);*/
