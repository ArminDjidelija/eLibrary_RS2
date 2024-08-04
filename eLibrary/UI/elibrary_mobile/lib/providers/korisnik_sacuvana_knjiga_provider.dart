import 'package:elibrary_mobile/models/korisnik_sacuvana_knjiga.dart';
import 'package:elibrary_mobile/providers/base_provider.dart';

class KorisnikSacuvanaKnjigaProvider
    extends BaseProvider<KorisnikSacuvanaKnjiga> {
  KorisnikSacuvanaKnjigaProvider() : super("KorisnikSacuvanaKnjiga");

  @override
  KorisnikSacuvanaKnjiga fromJson(data) {
    // TODO: implement fromJson
    return KorisnikSacuvanaKnjiga.fromJson(data);
  }
}
