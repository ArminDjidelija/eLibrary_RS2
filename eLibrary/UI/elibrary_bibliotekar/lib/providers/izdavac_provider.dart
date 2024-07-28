import 'package:elibrary_bibliotekar/models/izdavac.dart';
import 'package:elibrary_bibliotekar/providers/base_provider.dart';

class IzdavacProvider extends BaseProvider<Izdavac> {
  IzdavacProvider() : super("Izdavaci");

  @override
  Izdavac fromJson(data) {
    // TODO: implement fromJson
    return Izdavac.fromJson(data);
  }
}