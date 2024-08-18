import 'package:elibrary_mobile/models/rezervacija.dart';
import 'package:elibrary_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class RezervacijeProvider extends BaseProvider<Rezervacija> {
  RezervacijeProvider() : super("Rezervacije");

  @override
  Rezervacija fromJson(data) {
    // TODO: implement fromJson
    return Rezervacija.fromJson(data);
  }

  Future ponisti(int rezervacijaId) async {
    var url = "${BaseProvider.baseUrl}Rezervacije/${rezervacijaId}/ponisti";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.put(uri, headers: headers);
  }
}
