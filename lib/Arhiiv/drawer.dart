import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testuus4/lehed/P%C3%B5hi_Lehed/Login.dart';
import 'package:testuus4/lehed/P%C3%B5hi_Lehed/hindJoonise.dart';

import '../lehed/Põhi_Lehed/kasutajaseaded.dart';
import '../widgets/AbiLeht.dart';

class drawer extends StatelessWidget {
  const drawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.60,
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
                Icons.add_circle_outline_outlined,
                size: 32,
              ),
              title: RichText(
                text: TextSpan(
                  text: 'Seadme lisamine',
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
                Navigator.pop(context);
              },
            ),
            /*ListTile(
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
            ),*/
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
                Navigator.pop(context);
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
                Navigator.pop(context);
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
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}