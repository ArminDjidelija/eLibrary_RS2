import 'package:elibrary_bibliotekar/models/korisnik.dart';
import 'package:elibrary_bibliotekar/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class KorisnikProvider extends BaseProvider<Korisnik> {
  KorisnikProvider() : super("Korisnici");

  @override
  Korisnik fromJson(data) {
    // TODO: implement fromJson
    return Korisnik.fromJson(data);
  }

  Future login(String username, String password) async {
    var url =
        "${BaseProvider.baseUrl}Korisnici/Login?username=${username}&password=${password}";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.post(uri, headers: headers);
    if (response.body == "") {
      throw new Exception("Pogrešan username ili lozinka");
    }
  }
}
