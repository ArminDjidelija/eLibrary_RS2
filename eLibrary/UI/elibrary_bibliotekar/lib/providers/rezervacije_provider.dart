import 'package:elibrary_bibliotekar/models/rezervacija.dart';
import 'package:elibrary_bibliotekar/providers/base_provider.dart';

class RezervacijeProvider extends BaseProvider<Rezervacija> {
  RezervacijeProvider() : super("Rezervacije");

  @override
  Rezervacija fromJson(data) {
    // TODO: implement fromJson
    return Rezervacija.fromJson(data);
  }
}
