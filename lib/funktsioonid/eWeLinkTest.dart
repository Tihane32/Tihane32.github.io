import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

String makeSign(String key, String message, int timestamp) {
  String messageWithTimestamp = '${message}_${timestamp}';
  List<int> bytes = utf8.encode(messageWithTimestamp);
  Hmac hmacSha256 = Hmac(sha256, utf8.encode(key));
  Digest digest = hmacSha256.convert(bytes);
  return base64.encode(digest.bytes);
}

void main() async {
  // Get current timestamp in milliseconds
  int timestampMs = DateTime.now().millisecondsSinceEpoch;

  // Example parameters
  String key = "mXLOjea0woSMvK9gw7Fjsy7YlFO4iSu6";
  String message = "Uw83EKZFxdif7XFXEsrpduz5YyjP7nTl";

  // Generate the signature with timestamp
  String sign = makeSign(key, message, timestampMs);
  print(sign);

  final headers = {
    'authority': 'eu-apia.coolkit.cc',
    'accept': 'application/json, text/plain, */*',
    'accept-language': 'et-EE,et;q=0.9',
    'authorization': 'Sign HjQiYPPBIWdXdijAhX1qTDIMzaZHR89hgXsZJ6aX9fE=',
    'content-type': 'application/json',
    'origin': 'https://web.ewelink.cc',
    'referer': 'https://web.ewelink.cc/',
    'sec-ch-ua':
        '"Chromium";v="122", "Not(A:Brand";v="24", "Google Chrome";v="122"',
    'sec-ch-ua-mobile': '?0',
    'sec-ch-ua-platform': '"Windows"',
    'sec-fetch-dest': 'empty',
    'sec-fetch-mode': 'cors',
    'sec-fetch-site': 'cross-site',
    'user-agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
    'x-ck-appid': 'K0OCDSvIaBWdEaU4zxlKEwk26kmshoXK',
    'x-ck-nonce': 'ujRemTdg',
  };
  //print(headers);
  final data1 =
      '{"countryCode":"+372","password":"kalatraaler","lang":"en","email":"jaakob.lambot@gmail.com"}';

  final url = Uri.parse('https://eu-apia.coolkit.cc/v2/user/login');

  final res = await http.post(url, headers: headers, body: data1);
  final status = res.statusCode;
  if (status != 200) throw Exception('http.post error: statusCode= $status');

  print(res.body);
}
