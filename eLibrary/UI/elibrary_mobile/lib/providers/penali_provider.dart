import 'package:elibrary_mobile/models/penal.dart';
import 'package:elibrary_mobile/models/rezervacija.dart';
import 'package:elibrary_mobile/providers/base_provider.dart';

class PenaliProvider extends BaseProvider<Penal> {
  PenaliProvider() : super("Penali");

  @override
  Penal fromJson(data) {
    // TODO: implement fromJson
    return Penal.fromJson(data);
  }
}
