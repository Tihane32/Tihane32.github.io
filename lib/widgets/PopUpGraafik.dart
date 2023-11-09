import 'package:flutter/material.dart';
import '../main.dart';

void PopUpGraafik(BuildContext context, String pealkiri, seadmeGraafik) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      titlePadding: EdgeInsets.only(top: 10.0),
      contentPadding: EdgeInsets.only(top: 10.0),
      title: Align(
        alignment: Alignment.center,
        child: Text(pealkiri),
      ),
      content: Container(
        height: 528,
        child: Column(
          children: List.generate(
            seadmeGraafik.length,
            (index) {
              var item = seadmeGraafik[index];
              return Container(
                decoration: BoxDecoration(
                  color: item == 'on'
                      ? Colors.green
                      : Color.fromARGB(255, 202, 200, 200),
                  border: Border.all(
                      color: Color.fromARGB(82, 0, 0, 0), width: 0.5),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    index < 10
                        ? "0${index.toString()}:00"
                        : "${index.toString()}:00",
                    style: font,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    ),
  );
}
