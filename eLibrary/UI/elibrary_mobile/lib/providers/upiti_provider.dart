import 'package:elibrary_mobile/models/upit.dart';
import 'package:elibrary_mobile/providers/base_provider.dart';

class UpitiProvider extends BaseProvider<Upit> {
  UpitiProvider() : super("Upiti");

  @override
  Upit fromJson(data) {
    // TODO: implement fromJson
    return Upit.fromJson(data);
  }
}
