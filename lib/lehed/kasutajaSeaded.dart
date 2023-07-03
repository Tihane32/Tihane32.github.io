import 'package:flutter/material.dart';


class KasutajaSeaded extends StatefulWidget {
  @override
  _KasutajaSeadedState createState() => _KasutajaSeadedState();
}

class _KasutajaSeadedState extends State<KasutajaSeaded> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Tuleb lisada',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}