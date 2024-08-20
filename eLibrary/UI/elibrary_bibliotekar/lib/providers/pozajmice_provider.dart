import 'package:elibrary_bibliotekar/models/pozajmica.dart';
import 'package:elibrary_bibliotekar/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class PozajmiceProvider extends BaseProvider<Pozajmica> {
  PozajmiceProvider() : super("Pozajmice");
  String? endpoint = "Pozajmice";
  @override
  Pozajmica fromJson(data) {
    // TODO: implement fromJson
    return Pozajmica.fromJson(data);
  }

  Future potvrdiPozajmicu(int id) async {
    var url = "${BaseProvider.baseUrl}Pozajmice/Potvrdi?id=${id}";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.post(uri, headers: headers);
  }

  Future obavijesti(int id) async {
    var url = "${BaseProvider.baseUrl}Pozajmice/${id}/obavijesti";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.post(uri, headers: headers);
  }
}
