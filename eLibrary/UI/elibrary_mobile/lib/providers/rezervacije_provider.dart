import 'package:elibrary_mobile/models/rezervacija.dart';
import 'package:elibrary_mobile/providers/base_provider.dart';

class RezervacijeProvider extends BaseProvider<Rezervacija> {
  RezervacijeProvider() : super("Rezervacije");

  @override
  Rezervacija fromJson(data) {
    // TODO: implement fromJson
    return Rezervacija.fromJson(data);
  }
}
