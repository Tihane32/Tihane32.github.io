import 'dart:io';

void main() async {
  const String serverUrl = '172.22.22.222';
  final int port = 5000; // You can adjust the port number

  try {
    final socket = await Socket.connect(serverUrl, port, timeout: Duration(seconds: 2));
    print('Connected to $serverUrl:$port');
    socket.close();
  } catch (e) {
    print('Error: $e');
  }
}
