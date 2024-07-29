import 'package:elibrary_mobile/models/tip_clanarine_biblioteka.dart';
import 'package:elibrary_mobile/providers/base_provider.dart';

class TipClanarineBibliotekaProvider
    extends BaseProvider<TipClanarineBiblioteka> {
  TipClanarineBibliotekaProvider() : super("TipClanarineBiblioteke");

  @override
  TipClanarineBiblioteka fromJson(data) {
    // TODO: implement fromJson
    return TipClanarineBiblioteka.fromJson(data);
  }
}
