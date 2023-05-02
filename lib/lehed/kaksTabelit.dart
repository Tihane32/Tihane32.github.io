import 'package:flutter/material.dart';
import 'hinnaGraafik.dart';
import 'Login.dart';
import 'koduleht.dart';

void main() {
  runApp(const MaterialApp(
    home: SeadmeTabel(),
  ));
}

class MinuSeadmed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SeadmeTabel(),
    );
  }
}

class SeadmeTabel extends StatefulWidget {
  const SeadmeTabel({Key? key}) : super(key: key);

  @override
  _SeadmeTabelState createState() => _SeadmeTabelState();
}

int koduindex = 0;

class _SeadmeTabelState extends State<SeadmeTabel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[600],
        title: const Text('Shelly pistik'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginApp()),
              );
            },
            child: const Text('LOG IN'),
          ),
        ],
      ),
      body: Column(
        children: [
          const DecoratedBox(
            decoration: const BoxDecoration(color: Colors.amber),
            child: Text(
              'Kontolt lisatud Seadmed:',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: KontoSeadmed(),
          ),
          const DecoratedBox(
            decoration: const BoxDecoration(color: Colors.cyan),
            child: Text(
              'Manualselt lisatud Seadmed:',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: ManuaalsedSeadmed(onTap: (rowData) {
              print('Tapped row with data: $rowData');
            }),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.red[600],
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: 'Teie seade',
              icon: Icon(Icons.electrical_services_rounded),
            ),
            BottomNavigationBarItem(
              label: 'Kodu',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: 'Hinnagraafik',
              icon: Icon(Icons.table_rows_outlined),
            ),
          ],
          currentIndex: koduindex,
          onTap: (int kodu) {
            setState(() {
              koduindex = kodu;

              if (koduindex == 2) {
                Navigator.push(
                  //Kui vajutatakse Hinnagraafiku ikooni peale, siis viiakse Hinnagraafiku lehele

                  context,

                  MaterialPageRoute(builder: (context) => HinnaGraafik()),
                );
              } else if (koduindex == 1) {
                Navigator.push(
                  //Kui vajutatakse Teie seade ikooni peale, siis viiakse Seadmetelisamine lehele

                  context,

                  MaterialPageRoute(builder: (context) => const KoduLeht()),
                );
              }
            });
          }),
    );
  }
}

class ManuaalsedSeadmed extends StatelessWidget {
  ManuaalsedSeadmed({Key? key, required this.onTap}) : super(key: key);

  final Function(List<String>) onTap;

  final Map<String, List<String>> minuSeadmedM = {
    '123': ['123', 'Boiler 55', 'Shelly plug S'],
    '456': ['456', 'Kulmik 1', 'Shelly plug'],
    '789': ['789', 'Kulmik 2', 'Shelly plug S'],
    '7': ['789', 'Kulmik 2', 'Shelly plug S'],
    '78': ['789', 'Kulmik 2', 'Shelly plug S'],
    '79': ['789', 'Kulmik 2', 'Shelly plug S'],
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: DataTable(
        showCheckboxColumn: false,
        columns: const <DataColumn>[
          DataColumn(
            label: Text(
              'ID',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              'Nimi',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              'Pistik',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ],
        rows: minuSeadmedM.entries
            .map(
              (e) => DataRow(
                cells: [
                  DataCell(Text(e.value[0])),
                  DataCell(Text(e.value[1])),
                  DataCell(Text(e.value[2])),
                ],
                onSelectChanged: (isSelected) {
                  if (isSelected != null && isSelected) {
                    onTap(e.value);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HinnaGraafik()),
                    );
                  }
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

class KontoSeadmed extends StatelessWidget {
  KontoSeadmed({Key? key}) : super(key: key);

  final Map<String, List<String>> minuSeadmedK = {
    '123': ['123', 'Boiler 1', 'Shelly plug S'],
    '456': ['456', 'Kaevu pump', 'Shelly plug'],
    '789': ['789', 'Boiler 2', 'Shelly plug S'],
    '78': ['789', 'Boiler 2', 'Shelly plug S'],
    '13': ['123', 'Boiler 1', 'Shelly plug S'],
    '56': ['456', 'Kaevu pump', 'Shelly plug'],
    '89': ['789', 'Boiler 2', 'Shelly plug S'],
    '8': ['789', 'Boiler 2', 'Shelly plug S'],
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: DataTable(
        columns: const <DataColumn>[
          DataColumn(
            label: Text(
              'ID',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              'Nimi',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              'Pistik',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ],
        rows: minuSeadmedK.entries
            .map((e) => DataRow(cells: [
                  DataCell(Text(e.value[0])),
                  DataCell(Text(e.value[1])),
                  DataCell(Text(e.value[2])),
                ]))
            .toList(),
      ),
    );
  }
}
