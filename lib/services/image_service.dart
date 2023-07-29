import 'dart:convert';
import 'package:http/http.dart' as http;

Future<dynamic> getRandomImage(String category) async {
  http.Response response = await http.get(
    Uri.parse(
        'https://random.imagecdn.app/v1/image?category=$category&format=json'),
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }
  return Future.error(false);
}
