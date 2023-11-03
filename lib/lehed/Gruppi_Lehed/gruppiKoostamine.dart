import 'package:flutter/material.dart';

class GruppiKoostamine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('GruppiKoostamine'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  DraggableBox(color: Colors.green, label: 'Seade'),
                  DraggableBox(color: Colors.green, label: 'Seade'),
                  DraggableBox(color: Colors.green, label: 'Seade'),
                ],
              ),
              SizedBox(height: 20),
              TargetCircle(),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  DraggableBox(color: Colors.green, label: 'Seade'),
                  DraggableBox(color: Colors.green, label: 'Seade'),
                  DraggableBox(color: Colors.green, label: 'Seade'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TargetCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
      alignment: Alignment.center,
      child: Text(
        'Grupp',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class DraggableBox extends StatelessWidget {
  final Color color;
  final String label;

  DraggableBox({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Draggable(
      data: label,
      feedback: Container(
        width: 100,
        height: 100,
        color: color,
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      child: Container(
        width: 100,
        height: 100,
        color: color,
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      childWhenDragging: Container(
        width: 100,
        height: 100,
        color: color.withOpacity(0.5),
      ),
    );
  }
}
