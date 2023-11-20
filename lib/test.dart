import 'package:http/http.dart' as http;

Future<void>  main() async {
  try {
    await http.post(
      Uri.parse("http://172.22.22.217:5000/log"),
      body: "Test",
      headers: {'Content-Type': 'text/plain'},
    );
  } catch (e) {
    print('Error sending log to server: $e');
  }
}