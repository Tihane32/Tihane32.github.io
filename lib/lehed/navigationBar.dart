import 'package:flutter/material.dart';
import 'package:testuus4/lehed/koduleht.dart';
import 'package:testuus4/main.dart';
import 'kaksTabelit.dart';
import 'hindJoonise.dart';

class AppNavigationBar extends StatelessWidget {
  final int i;
  const AppNavigationBar({
    Key? key,
    required this.i,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: roheline,
      fixedColor: Colors.black,
      unselectedItemColor: Colors.black,
      selectedIconTheme: const IconThemeData(color: Color.fromARGB(255, 0, 0, 0)),
      unselectedIconTheme: const IconThemeData(color: Colors.black),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          label: '',
          icon: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => KoduLeht()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .center, // Adjust the spacing between icons
                children: [
                 
                  if (i==1) // Replace isSelected with your own logic to determine which label is selected
                    Container(
                     
                      decoration: BoxDecoration(
                        color: Color.fromARGB(81, 80, 129, 164),
                        shape: BoxShape.circle,
                      ),
                       child: Icon(
                    Icons.person_outlined,
                    size: 40,
                    color: Colors.blue,
                  ),
                    )else Icon(
                    Icons.person_outlined,
                    size: 40,
                  ),
                  
                  // Adjust the spacing between the icons
                ],
              ),
            ),
          ),
        ),
        BottomNavigationBarItem(
          label: '',
          icon: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MinuSeadmed()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .center, // Adjust the spacing between icons
                children: [
                if (i==0) // Replace isSelected with your own logic to determine which label is selected
                    Container(
                      
                      decoration: BoxDecoration(
                        color: Color.fromARGB(81, 80, 129, 164),
                        shape: BoxShape.circle,
                      ),
                       child: Icon(
                    Icons.home_outlined,
                    size: 40,
                    color: Colors.blue
                  ),
                    )else Icon(
                    Icons.home_outlined,
                    size: 40,
                  ),
                  // Adjust the spacing between the icons
                ],
              ),
            ),
          ),
        ),
        BottomNavigationBarItem(
          label: '',
          icon: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NordHinnad()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .center, // Adjust the spacing between icons
                children: [
                  Transform.rotate(
                    angle: 90 * 0.0174533, // Convert degrees to radians
                    
                  ),
                  if (i==2) // Replace isSelected with your own logic to determine which label is selected
                    Container(
                      
                      decoration: BoxDecoration(
                        color: Color.fromARGB(81, 80, 129, 164),
                        shape: BoxShape.circle,
                        
                      ),
                       child: Icon(
                    Icons.leaderboard_outlined,
                    size: 35,
                    color: Colors.blue
                  ),
                    )else Icon(
                    Icons.leaderboard_outlined,
                    size: 35,
                  ),

                  // Adjust the spacing between the icons
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
