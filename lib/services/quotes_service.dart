import 'dart:convert';

import 'package:http/http.dart' as http;

Future<dynamic> getRandomQuote() async {
  http.Response response = await http.get(
    Uri.parse('https://api.quotable.io/random'),
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }
  return Future.error(false);
}
