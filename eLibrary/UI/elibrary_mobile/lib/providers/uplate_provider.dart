import 'package:elibrary_mobile/models/uplata.dart';
import 'package:elibrary_mobile/providers/base_provider.dart';

class UplataProvider extends BaseProvider<Uplata> {
  UplataProvider() : super("Uplate");

  @override
  Uplata fromJson(data) {
    // TODO: implement fromJson
    return Uplata.fromJson(data);
  }
}
