import 'package:elibrary_mobile/models/knjiga.dart';
import 'package:elibrary_mobile/providers/base_provider.dart';

class KnjigaProvider extends BaseProvider<Knjiga> {
  KnjigaProvider() : super("Knjige");

  @override
  Knjiga fromJson(data) {
    // TODO: implement fromJson
    return Knjiga.fromJson(data);
  }
}
