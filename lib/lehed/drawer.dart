import 'package:flutter/material.dart';
import 'package:testuus4/lehed/Login.dart';
import 'package:testuus4/lehed/abiLeht.dart';
import 'package:testuus4/lehed/hindJoonise.dart';
import 'package:testuus4/lehed/kasutajaSeaded.dart';
import 'package:testuus4/lehed/lisaSeade.dart';
import 'package:testuus4/lehed/rakenduseSeaded.dart';
import 'package:google_fonts/google_fonts.dart';



class drawer extends StatelessWidget {
  const drawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.55,
      child: Container(
        color: const Color.fromARGB(
            255, 115, 162, 195), // Set the desired background color
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer items...
            const ListTile(),
            ListTile(
              leading: const Icon(
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
                // Navigate to the login page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LisaSeade()),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.manage_accounts,
                size: 32,
              ),
              title: RichText(
                text: TextSpan(
                  text: 'Seaded',
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => KasutajaSeaded()),
                );
              },
            ),
            ListTile(
              leading: Transform.rotate(
                angle: 0 * 0.0174533,
                child: const Icon(
                  Icons.bar_chart_rounded,
                  size: 32, // Adjust the size as needed
                ),
              ),
              title: RichText(
                text: TextSpan(
                  text: 'Elektri börsihind',
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TulpDiagramm()),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.help_outline_outlined,
                size: 32, // Adjust the size as needed
              ),
              title: RichText(
                text: TextSpan(
                  text: 'Abi',
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AbiLeht()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
