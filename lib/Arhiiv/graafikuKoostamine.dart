/*
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'graafikuValimine.dart';

class GraafikLeht extends StatefulWidget {
  final String value; // Add a parameter to receive the value String
  const GraafikLeht(this.value, {Key? key}) : super(key: key);

  @override
  State<GraafikLeht> createState() => _GraafikLehtState();
}

class _GraafikLehtState extends State<GraafikLeht> {
  int koduindex = 1;

  int onTunnidSisestatud = 0;

  @override
  void initState() {
    super.initState();

    _tooTund();
  }

  Future<void> _tooTund() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      onTunnidSisestatud = (prefs.getInt('counter') ?? 0);
    });
  }

  Future<void> _tundLisa() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      if (onTunnidSisestatud < 24) {
        onTunnidSisestatud = (prefs.getInt('counter') ?? 0) + 1;
        prefs.setInt('counter', onTunnidSisestatud);
      }
    });
  }

  Future<void> _tundEemalda() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      if (onTunnidSisestatud > 0) {
        onTunnidSisestatud = (prefs.getInt('counter') ?? 0) - 1;
        prefs.setInt('counter', onTunnidSisestatud);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[600],
        title: const Text('Shelly pistik'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text(
            'Sisselülitatud tundide arv:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          Text(
            '$onTunnidSisestatud',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: _tundEemalda,
                child: const Icon(Icons.remove),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TundideValimineTana(
                            soovitudTunnid: onTunnidSisestatud,
                            value: widget
                                .value)), // Pass the value String to TundideValimineTana
                  );
                },
                child: const Icon(Icons.check_circle_outline_rounded),
              ),
              ElevatedButton(
                onPressed: _tundLisa,
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
*/