import 'dart:convert';
import 'package:http/http.dart' as http;

/// The function `getCurrentPrice` is used with Elering API to get the current electricity price in Estonia.
/// Without tax, and in €/MWh.
///
/// Example:
///```dart
///double currentPrice = await getCurrentPrice();
///print(currentPrice); //99.0
///
///
///```

Future<double> getCurrentPrice() async {
  final response = await http
      .get(Uri.parse('https://dashboard.elering.ee/api/nps/price/EE/current'));
  final hetkeHind = json.decode(response.body) as Map<String, dynamic>;
  double CurrentPrice = hetkeHind["data"][0]["price"];
  return CurrentPrice;
}
