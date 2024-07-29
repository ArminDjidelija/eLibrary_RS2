import 'package:elibrary_bibliotekar/models/penal.dart';
import 'package:elibrary_bibliotekar/models/rezervacija.dart';
import 'package:elibrary_bibliotekar/providers/base_provider.dart';

class PenaliProvider extends BaseProvider<Penal> {
  PenaliProvider() : super("Penali");

  @override
  Penal fromJson(data) {
    // TODO: implement fromJson
    return Penal.fromJson(data);
  }
}
