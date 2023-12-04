import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';

Future<Map<String, Map<String, dynamic>>> saaShellyConf() async {
  String csvString = await rootBundle.loadString('assets/ShellyConf.csv');

  List<List<String>> csvTable = CsvToListConverter(
    fieldDelimiter: ';', // Set the field delimiter to semicolon
  ).convert(csvString, shouldParseNumbers: false);

  Map<String, Map<String, dynamic>> confShelly = {};

  for (int i = 1; i < csvTable.length; i++) {
    List<String> rowData = csvTable[i];

    Map<String, dynamic> values = {
      'category': rowData[1],
      'channels': rowData[2],
      'relay': rowData[3],
      'temperature': rowData[4],
      'moisture': rowData[5],
      'ligth': rowData[6],
    };

    confShelly[rowData[0]] = values;
  }
  return confShelly;
}
