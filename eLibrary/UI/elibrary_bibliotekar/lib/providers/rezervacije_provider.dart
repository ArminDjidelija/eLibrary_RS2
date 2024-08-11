import 'dart:convert';

import 'package:elibrary_bibliotekar/models/rezervacija.dart';
import 'package:elibrary_bibliotekar/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class RezervacijeProvider extends BaseProvider<Rezervacija> {
  RezervacijeProvider() : super("Rezervacije");

  @override
  Rezervacija fromJson(data) {
    // TODO: implement fromJson
    return Rezervacija.fromJson(data);
  }

  Future odobri(int rezervacijaId) async {
    var url = "${BaseProvider.baseUrl}Rezervacije/${rezervacijaId}/odobri";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.put(uri, headers: headers);
  }

  Future ponisti(int rezervacijaId) async {
    var url = "${BaseProvider.baseUrl}Rezervacije/${rezervacijaId}/ponisti";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.put(uri, headers: headers);
  }

  Future obnovi(int rezervacijaId) async {
    var url = "${BaseProvider.baseUrl}Rezervacije/${rezervacijaId}/obnovi";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.put(uri, headers: headers);
  }

  Future zavrsi(int rezervacijaId) async {
    var url = "${BaseProvider.baseUrl}Rezervacije/${rezervacijaId}/zavrsi";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.put(uri, headers: headers);
  }

  Future<List<String>> getAllowedActions(int rezervacijaId) async {
    var url =
        "${BaseProvider.baseUrl}Rezervacije/${rezervacijaId}/allowedActions";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      List<dynamic> obj = jsonDecode(response.body);
      return obj.cast<String>();
    }
    throw new Exception("Greška");
  }
}
