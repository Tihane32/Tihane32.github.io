import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testuus4/funktsioonid/lulitamine.dart';
import 'dart:async';
import '../GraafikusseSeadmeteValik.dart';
import '../Põhi_Lehed/dynamicKoduLeht.dart';
import 'package:testuus4/funktsioonid/seisukord.dart';
import 'package:testuus4/main.dart';
import '../Seadme_Lehed/dynamicSeadmeInfo.dart';

class GruppiSeadmed extends StatefulWidget {
  const GruppiSeadmed({Key? key, required this.gruppNimi}) : super(key: key);
  final String gruppNimi;

  @override
  State<GruppiSeadmed> createState() =>
      _GruppiSeadmedState(gruppNimi: gruppNimi);
}

class _GruppiSeadmedState extends State<GruppiSeadmed> {
  _GruppiSeadmedState({Key? key, required this.gruppNimi});
  String gruppNimi;
  bool isLoading = true;
  //String onoffNupp = 'Shelly ON';
  Map<String, dynamic> filteredDevices = {};
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await seisukord();
    filteredDevices = gruppiSeadmedtoMap(gruppNimi);
    // Add any other data fetching or initialization code here if needed.
    // When done, set isLoading to false to display the content.
    setState(() {
      isLoading = false;
    });
  }

  int koduindex = 1;
  Set<String> selectedPictures = Set<String>();
  double xAlign = -1;
  double signInAlign = 1;
  double loginAlign = -1;
  double width = 200;
  double height = 40;

  void toggleSelection(String pictureName) {
    setState(() {
      if (selectedPictures.contains(pictureName)) {
        selectedPictures.remove(pictureName);
      } else {
        selectedPictures.add(pictureName);
      }
    });
  }

  bool canPressButton = true;

  void _handleButtonPress(seade) {
    if (!canPressButton) return;

    setState(() {
      canPressButton = false;
      filteredDevices = muudaSeadmeOlek(filteredDevices, seade);
    });

    Timer(Duration(seconds: 3), () {
      setState(() {
        canPressButton = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backround,
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          int tundlikus = 8;
          if (details.delta.dx > tundlikus) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DynaamilenieKoduLeht(i: 0)));
            // Right Swipe
          } else if (details.delta.dx < -tundlikus) {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => SeadmeteListValimine()),
            );
            //Left Swipe
          }
        },
        onVerticalDragUpdate: (details) {
          int sensitivity = 8;
          if (details.delta.dy > sensitivity) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DynaamilenieKoduLeht(i: 1)));
            // alla lohistamisel v2rskenda
          }
        },
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : GridView.builder(
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: filteredDevices.length + 1,
                itemBuilder: (context, index) {
                  if (index == filteredDevices.length) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DynaamilenieKoduLeht(i: 2)));
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
                            color: Colors.grey[300],
                            child: Center(
                              child: Icon(
                                Icons.add,
                                size: 48,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  final seade = filteredDevices.keys.elementAt(index);
                  final pilt = filteredDevices[seade]["Seadme_pilt"];
                  final staatus = filteredDevices[seade]["Seadme_olek"];
                  print('Staatus: $staatus');
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DunaamilineSeadmeLeht(
                            seadmeNimi: filteredDevices.keys.elementAt(index),
                            SeadmeteMap: filteredDevices,
                            valitud: 0,
                          ),
                        ),
                      );
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
                              color: staatus == 'on'
                                  ? Colors.green
                                  : staatus == 'off'
                                      ? Colors.red
                                      : Colors.grey,
                              width: 8,
                            ),
                          ),
                          child: Stack(
                            children: [
                              AspectRatio(
                                aspectRatio: 1,
                                child: ClipRRect(
                                  child: Image.asset(
                                    pilt,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: staatus == 'on'
                                        ? Colors.green.withOpacity(0.6)
                                        : staatus == 'off'
                                            ? Colors.red.withOpacity(0.6)
                                            : Colors.grey.withOpacity(0.6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: staatus == 'Offline'
                                      ? Icon(
                                          Icons.wifi_off_outlined,
                                          size: 60,
                                          color: Colors.amber,
                                        )
                                      : IconButton(
                                          iconSize: 60,
                                          icon: Icon(Icons.power_settings_new),
                                          color: Colors.white,
                                          onPressed: () {
                                            _handleButtonPress(seade);
                                          },
                                        ),
                                ),
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
                                      filteredDevices[seade]["Seadme_nimi"],
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

muudaSeadmeOlek(Map<String, dynamic> filteredDevices, SeadmeNimi) {
  lulitamine(SeadmeNimi);

  return seadmeteMap; // Device key not found in the map
}

Map<String, dynamic> gruppiSeadmedtoMap(String gruppNimi) {
  print('siin');
  Map<String, dynamic> filteredDevices = {};

  seadmeteMap.forEach((device, deviceData) {
    if (gruppiMap[gruppNimi]['Grupi_Seadmed'].contains(device)) {
      filteredDevices[device] = deviceData;
    }
  });
  print(filteredDevices);
  return filteredDevices;
}
