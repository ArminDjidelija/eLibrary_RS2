import 'package:elibrary_bibliotekar/models/knjiga.dart';
import 'package:elibrary_bibliotekar/providers/base_provider.dart';

class KnjigaProvider extends BaseProvider<Knjiga> {
  KnjigaProvider() : super("Knjige");

  @override
  Knjiga fromJson(data) {
    // TODO: implement fromJson
    return Knjiga.fromJson(data);
  }
}
