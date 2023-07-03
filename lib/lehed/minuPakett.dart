import 'package:flutter/material.dart';


class MinuPakett extends StatefulWidget {
  @override
  _MinuPakettState createState() => _MinuPakettState();
}

class _MinuPakettState extends State<MinuPakett> {
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