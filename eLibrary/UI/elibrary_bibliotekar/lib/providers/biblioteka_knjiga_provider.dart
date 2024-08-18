import 'dart:convert';

import 'package:elibrary_bibliotekar/models/biblioteka_knjiga.dart';
import 'package:elibrary_bibliotekar/models/pozajmica_info.dart';
import 'package:elibrary_bibliotekar/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class BibliotekaKnjigaProvider extends BaseProvider<BibliotekaKnjiga> {
  BibliotekaKnjigaProvider() : super("BibliotekaKnjige");

  @override
  BibliotekaKnjiga fromJson(data) {
    // TODO: implement fromJson
    return BibliotekaKnjiga.fromJson(data);
  }

  Future<List<PozajmicaInfo>> getReportData(int bkId) async {
    var url = "${BaseProvider.baseUrl}BibliotekaKnjige/${bkId}/report";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var obj = jsonDecode(response.body);

      if (obj is List) {
        List<PozajmicaInfo> lista =
            obj.map((item) => PozajmicaInfo.fromJson(item)).toList();
        return lista; // Vratite listu PozajmicaInfo
      } else {
        throw new Exception("Očekivana lista iz JSON odgovora.");
      }
    }
    throw new Exception("Greška");
  }
}
