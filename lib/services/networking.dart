import 'dart:convert';
import 'package:http/http.dart';

final Client client = Client();

class NetworkHelper {
  NetworkHelper(this.url);

  final String url;

  Future<dynamic> getData() async {
    final Response result = await client.get(url);
    return jsonDecode(result.body);
  }
}
