import 'dart:convert';

import 'package:elibrary_mobile/models/autor.dart';
import 'package:elibrary_mobile/models/citalac.dart';
import 'package:elibrary_mobile/providers/base_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CitaociProvider extends BaseProvider<Citalac> {
  CitaociProvider() : super("Citaoci");

  @override
  Citalac fromJson(data) {
    // TODO: implement fromJson
    return Citalac.fromJson(data);
  }

  Future<Citalac> login(String username, String password) async {
    var url =
        "${BaseProvider.baseUrl}Citaoci/Login?username=${username}&password=${password}";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.post(uri, headers: headers);

    if (response.body == "") {
      throw new Exception("Pogrešan username ili lozinka");
    }
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw new Exception("Unknown error");
    }
  }
}
