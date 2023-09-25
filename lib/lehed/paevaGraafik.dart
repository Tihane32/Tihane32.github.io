import 'package:flutter/material.dart';

class PaevaTarbimine extends StatelessWidget {
  final String date;
  final String value;

  PaevaTarbimine({required this.date, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Date: $date'),
        Text('Value: $value'),
        // Add more widgets as needed
      ],
    );
  }
}
