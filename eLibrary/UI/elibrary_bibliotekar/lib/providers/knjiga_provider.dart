import 'dart:convert';
import 'package:elibrary_bibliotekar/providers/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class KnjigaProvider {
  static String? _baseUrl;

  KnjigaProvider() {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://localhost:5023/api");
  }

  Future<dynamic> get() async {
    var url = "${_baseUrl}/Knjige";
    print("url::::::::::::::::::$url");
    var uri = Uri.parse(url);
    var response = await http.get(uri, headers: createHeaders());

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw new Exception("Unknows exception");
    }
  }

  bool isValidResponse(Response response) {
    if (response.statusCode < 299) {
      return true;
    } else if (response.statusCode == 401) {
      throw new Exception("Unauthorized");
    } else {
      throw new Exception("Greška, pokušajte ponovo");
    }
  }

  Map<String, String> createHeaders() {
    String username = AuthProvider.username!;
    String password = AuthProvider.password!;

    String basicAuth =
        "Basic ${base64Encode(utf8.encode('${username}:${password}'))}";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };

    return headers;
  }
}
