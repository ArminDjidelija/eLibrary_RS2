import 'package:elibrary_mobile/models/vrsta_sadrzaja.dart';
import 'package:elibrary_mobile/providers/base_provider.dart';

class VrsteSadrzajaProvider extends BaseProvider<VrstaSadrzaja> {
  VrsteSadrzajaProvider() : super("VrsteSadrzaja");

  @override
  VrstaSadrzaja fromJson(data) {
    // TODO: implement fromJson
    return VrstaSadrzaja.fromJson(data);
  }
}
