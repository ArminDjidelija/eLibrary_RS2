import 'package:elibrary_bibliotekar/models/biblioteka_uposleni.dart';
import 'package:elibrary_bibliotekar/providers/base_provider.dart';

class BibliotekaUposleniProvider extends BaseProvider<BibliotekaUposleni> {
  BibliotekaUposleniProvider() : super("BibliotekaUposleni");

  @override
  BibliotekaUposleni fromJson(data) {
    // TODO: implement fromJson
    return BibliotekaUposleni.fromJson(data);
  }
}
