import 'dart:convert';
import 'package:testuus4/lehed/TarbimisLeht.dart';
import 'package:testuus4/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:testuus4/funktsioonid/maksumusSeadmeKohta.dart';
import 'package:testuus4/main.dart';
import 'koduleht.dart';

class MaksumuseGraafik extends StatefulWidget {
  @override
  State<MaksumuseGraafik> createState() => _MaksumuseGraafikState();
}

class _MaksumuseGraafikState extends State<MaksumuseGraafik> {
  Map<String, List<String>> SeadmeteMap = {};
  List<ChartData> chartData = [];
  num kokku = 0;
  @override
  void initState() {
    super.initState();
    function();
    getSeadmeteMap(SeadmeteMap);
  }

  getSeadmeteMap(Map<String, List<String>> seadmeteMap) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //await prefs.clear();

    String? storedJsonMap = prefs.getString('seadmed');
    print(storedJsonMap);
    if (storedJsonMap != null) {
      storedJsonMap = prefs.getString('seadmed');
      Map<String, dynamic> storedMap = json.decode(storedJsonMap!);
      await Future.delayed(const Duration(seconds: 3));
      var i = 0;
      for (String Seade in storedMap.keys) {
        var id = storedMap['Seade$i']['Seadme_ID'];
        var name = storedMap['Seade$i']['Seadme_nimi'];
        var pistik = storedMap['Seade$i']['Seadme_pistik'];
        var olek = storedMap['Seade$i']['Seadme_olek'];
        var gen = storedMap['Seade$i']['Seadme_generatsioon'];
        print('olek: $olek');
        Map<String, List<String>> ajutineMap = {
          name: ['assets/boiler1.jpg', '$id', '$olek', '$pistik', '$gen'],
        };
        seadmeteMap.addAll(ajutineMap);
        i++;
      }
      print('seadmed');

      print(SeadmeteMap);

      setState(() {
        SeadmeteMap = seadmeteMap;
      });
    }
  }

  function() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> maksumuseMap = {};
    //Võtab mälust 'users'-i asukohast väärtused
    var seadmedJSONmap = prefs.getString('seadmed');

    if (seadmedJSONmap == null) {
      return 0;
    }
    Map<String, dynamic> storedMap = json.decode(seadmedJSONmap);
    int j = 0;
    for (var i in storedMap.values) {
      String asendus = storedMap['Seade$j']['Seadme_ID'] as String;
      String asendus1 = storedMap['Seade$j']['Seadme_nimi'] as String;
      j++;

      print("seadmemaksusmu ${await seadmeMaksumus(asendus)}");
      double calculateSum(Map<DateTime, double> data) {
        double sum = 0.0;
        data.values.forEach((value) {
          sum += value;
        });
        kokku = sum;
        return sum;
      }

// Call seadmeMaksumus to get the map
      Map<DateTime, double> dataMap = await seadmeMaksumus(asendus);

// Calculate the sum of the double values in the map
      double temp = calculateSum(dataMap);
      String abi = temp.toStringAsFixed(2);
      temp = double.parse(abi);
      maksumuseMap["$asendus1"] = temp;
    }
    chartData.clear();

    for (var entry in maksumuseMap.entries) {
      chartData.add(ChartData(entry.key, entry.value));
    }
    print("lõpp");
    print(chartData);
    print(maksumuseMap);
    setState(() {
      chartData = chartData;
      kokku = kokku;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Align(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  //width: sinineKastLaius,
                  //height: sinineKastKorgus,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: font,
                      children: [
                        TextSpan(
                            text: 'Kokku: ${kokku.toStringAsFixed(2)} €',
                            style: font),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: vahe / 2),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Align(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  //width: sinineKastLaius,
                  //height: sinineKastKorgus,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: font,
                      children: [
                        TextSpan(text: '€', style: fontVaike),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * chartData.length * 0.06,
          //width: double.infinity,
          child: RotatedBox(
            quarterTurns: 1,
            child: Container(
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                    labelRotation: 270, interval: 1, labelStyle: fontVaike),
                primaryYAxis: NumericAxis(labelRotation: 270, isVisible: false),
                series: <ChartSeries>[
                  // Renders spline chart
                  ColumnSeries<ChartData, String>(
                    onPointTap: (pointInteractionDetails) {
                      int? rowIndex = pointInteractionDetails.pointIndex;
                      print("rowindex $rowIndex");
                      print(SeadmeteMap.keys.elementAt(rowIndex!));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TarbimisLeht(
                            seadmeNimi: SeadmeteMap.keys.elementAt(rowIndex!),
                            SeadmeteMap: SeadmeteMap,
                          ),
                        ),
                      );
                    },
                    width: 1,
                    spacing: 0.3,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      labelAlignment: ChartDataLabelAlignment.bottom,
                      textStyle: fontValgeVaike,
                      angle: 270,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
}
