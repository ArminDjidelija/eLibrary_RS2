import 'package:elibrary_bibliotekar/models/penal.dart';
import 'package:elibrary_bibliotekar/models/rezervacija.dart';
import 'package:elibrary_bibliotekar/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class PenaliProvider extends BaseProvider<Penal> {
  PenaliProvider() : super("Penali");

  @override
  Penal fromJson(data) {
    // TODO: implement fromJson
    return Penal.fromJson(data);
  }

  Future Plati(int penalId, int tipUplateId) async {
    var url =
        "${BaseProvider.baseUrl}Penali/plati?penalId=${penalId}&tipUplateId=${tipUplateId}";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.post(uri, headers: headers);
  }
}
