import 'package:flutter/material.dart';


class AbiLeht extends StatefulWidget {
  @override
  _AbiLehtState createState() => _AbiLehtState();
}

class _AbiLehtState extends State<AbiLeht> {
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