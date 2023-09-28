/*
Trevor Uuna, Jaakob Lambot 27.03.2023
TalTech
*/
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<List> getElering(String paevtest) async {
  var entryList;

  DateTime now = new DateTime.now();

  var date = new DateTime(
      now.year, now.month, now.day, now.hour); // tänase päeva leidmine

  if (date.hour < 15 ||
      paevtest ==
          'tana') //Kui kell on vähem, kui 15 või on saadetud String 'täna'
  {
    date = now.add(new Duration(days: -1));
  }
  String kell21 = 'T21'; //See läheb tänase päeva url-i.
  //Me tahame tegelikult kella 00:00, aga Elering on EU keskaja järgi
  String kell20 = 'T20'; //See läheb homse päeva viimaseks tunniks
  var parispaev = date.day;
  var pariskuu = date.month;

  String paev = date.day.toString();
  String kuu = date.month.toString();
  String aasta = date.year.toString();
  String arvnull =
      '0'; //Selle Stringi lisame päevale või kuule, kui nad on väiksemad, kui 10.

  if (parispaev <
      10) //Kui päeva number on väiksem, kui 10, siis lisab päeva ette 0-i. Seda on vaja Url-i koostamiseks
  {
    paev = arvnull + paev;
  }
  if (pariskuu <
      10) //Kui kuu number on väiksem, kui 10, siis lisab päeva ette 0-i. Seda on vaja Url-i koostamiseks
  {
    kuu = arvnull + kuu;
  }

  var homnepaev = now.add(new Duration(days: 1));
  if (date.hour < 15) {
    homnepaev = now.add(new Duration(days: 0));
  }
  var homneparispaev = homnepaev.day;
  var homnepariskuu = homnepaev.month;
  String homnepaev1 = homnepaev.day.toString();
  String homnekuu1 = homnepaev.month.toString();
  String homneaasta1 = homnepaev.year.toString();
  if (homneparispaev <
      10) //Kui päeva number on väiksem, kui 10, siis lisab päeva ette 0-i. Seda on vaja Url-i koostamiseks
  {
    homnepaev1 = arvnull + homnepaev1;
  }
  if (homnepariskuu <
      10) //Kui kuu number on väiksem, kui 10, siis lisab päeva ette 0-i. Seda on vaja Url-i koostamiseks
  {
    homnekuu1 = arvnull + homnekuu1;
  }

  String url =
      'https://dashboard.elering.ee/api/nps/price?start=$aasta-$kuu-$paev$kell21%3A00%3A00Z&end=$homneaasta1-$homnekuu1-$homnepaev1$kell20%3A00%3A00Z';

  final httpPackageUrl = Uri.parse(url);
  final httpPackageInfo = await http.read(httpPackageUrl);
  final httpPackageJson = json.decode(httpPackageInfo) as Map<String, dynamic>;

  entryList = httpPackageJson.entries.toList();

  //Võtab Listist Eesti hinnagraafiku
  var ajutine = entryList[1].value;
  var ajutine2 = ajutine.entries.toList();
  var hinnagraafik = ajutine2[0].value;

  return hinnagraafik;
}

Future<List<double>> getEleringVahemik(String algusPaev, String vahemik) async {
  var entryList;

  DateFormat format = DateFormat("yyyy-MM-dd");
  DateTime dateTime = format.parse(algusPaev);
  dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day - 1);
  String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
  DateTime newDateTime =
      DateTime(dateTime.year, dateTime.month, dateTime.day + 1);
  String formattedDate2 = DateFormat('yyyy-MM-dd').format(newDateTime);
  print(formattedDate);
  String url =
      'https://dashboard.elering.ee/api/nps/price?start=${formattedDate}T21%3A00%3A00Z&end=${formattedDate2}T20%3A00%3A00Z';
  print(url);
  final httpPackageUrl = Uri.parse(url);
  final httpPackageInfo = await http.read(httpPackageUrl);
  final httpPackageJson = json.decode(httpPackageInfo) as Map<String, dynamic>;

  entryList = httpPackageJson.entries.toList();

  //Võtab Listist Eesti hinnagraafiku
  var ajutine = entryList[1].value;
  var ajutine2 = ajutine.entries.toList();
  var hinnagraafik = ajutine2[0].value;
  List<double> prices = [];
  for (int i = 0; i < hinnagraafik.length;) {
    prices.add(hinnagraafik[i]["price"]);
    
    i++;
  }

  return prices;
}
