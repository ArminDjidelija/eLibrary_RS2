import 'package:elibrary_mobile/models/jezik.dart';
import 'package:elibrary_mobile/providers/base_provider.dart';

class JezikProvider extends BaseProvider<Jezik> {
  JezikProvider() : super("Jezici");

  @override
  Jezik fromJson(data) {
    // TODO: implement fromJson
    return Jezik.fromJson(data);
  }
}
