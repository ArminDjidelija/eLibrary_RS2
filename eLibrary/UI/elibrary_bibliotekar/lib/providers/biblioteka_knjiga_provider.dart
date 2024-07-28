import 'package:elibrary_bibliotekar/models/biblioteka_knjiga.dart';
import 'package:elibrary_bibliotekar/providers/base_provider.dart';

class BibliotekaKnjigaProvider extends BaseProvider<BibliotekaKnjiga> {
  BibliotekaKnjigaProvider() : super("BibliotekaKnjige");

  @override
  BibliotekaKnjiga fromJson(data) {
    // TODO: implement fromJson
    return BibliotekaKnjiga.fromJson(data);
  }
}
