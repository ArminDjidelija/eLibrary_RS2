import 'dart:convert';

import 'package:elibrary_mobile/models/biblioteka.dart';
import 'package:elibrary_mobile/models/penal.dart';
import 'package:elibrary_mobile/models/rezervacija.dart';
import 'package:elibrary_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class PenaliProvider extends BaseProvider<Penal> {
  PenaliProvider() : super("Penali");

  @override
  Penal fromJson(data) {
    // TODO: implement fromJson
    return Penal.fromJson(data);
  }

  Future<Biblioteka?> getBibliotekaByPenal(int penalId) async {
    var url = "${BaseProvider.baseUrl}Penali/biblioteka?penalId=${penalId}";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    var data = jsonDecode(response.body);

    return Biblioteka.fromJson(data);
  }
}
