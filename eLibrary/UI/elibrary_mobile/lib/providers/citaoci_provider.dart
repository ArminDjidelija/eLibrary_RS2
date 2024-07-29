import 'package:elibrary_mobile/models/autor.dart';
import 'package:elibrary_mobile/models/citalac.dart';
import 'package:elibrary_mobile/providers/base_provider.dart';
import 'package:flutter/material.dart';

class CitaociProvider extends BaseProvider<Citalac> {
  CitaociProvider() : super("Citaoci");

  @override
  Citalac fromJson(data) {
    // TODO: implement fromJson
    return Citalac.fromJson(data);
  }
}
