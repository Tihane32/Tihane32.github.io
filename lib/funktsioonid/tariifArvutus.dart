import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:testuus4/funktsioonid/parameters.dart';

import '../main.dart';

List<double> tariifArvutus(List<double> perioodiHinnad) {
  //Kontroll, kas on tarfiif ja seejärel tariifiga elektrihinna arvutamine

  if (tariif.isNotEmpty) {
    for (int i = 0; i < perioodiHinnad.length; i++) {
      //Vaatab, kas on ühetariifne või kahetariifne

      //Ühetariifne:
      if (tariif.length == 1) {
        double newPrice =
            (perioodiHinnad[i] * kaibemaks + tariif[0] * kaibemaks * 10);
        perioodiHinnad[i] = double.parse(newPrice.toStringAsFixed(2));
      }

      //Kahetariifne:
      else {
        if (DateTime.now().weekday < 6) {
          if (i < 8 || i > 21) {
            double newPrice =
                (perioodiHinnad[i] * kaibemaks + tariif[1] * kaibemaks * 10);
            perioodiHinnad[i] = double.parse(newPrice.toStringAsFixed(2));
          } else {
            double newPrice =
                (perioodiHinnad[i] * kaibemaks + tariif[0] * kaibemaks * 10);
            perioodiHinnad[i] = double.parse(newPrice.toStringAsFixed(2));
          }
        } else {
          double newPrice =
              (perioodiHinnad[i] * kaibemaks + tariif[1] * kaibemaks * 10);
          perioodiHinnad[i] = double.parse(newPrice.toStringAsFixed(2));
        }
      }
    }
  } 
  
  //Juhul kui tariife ei ole, siis tehakse ainult käibemaksu arvutus
  else {
    for (int i = 0; i < perioodiHinnad.length; i++) {
      double newPrice = (perioodiHinnad[i] * kaibemaks);
      perioodiHinnad[i] = double.parse(newPrice.toStringAsFixed(2));
    }
  }

  return perioodiHinnad;
}
