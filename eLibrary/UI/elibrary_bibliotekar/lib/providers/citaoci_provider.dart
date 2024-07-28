import 'package:elibrary_bibliotekar/models/autor.dart';
import 'package:elibrary_bibliotekar/models/citalac.dart';
import 'package:elibrary_bibliotekar/providers/base_provider.dart';
import 'package:flutter/material.dart';

class CitaociProvider extends BaseProvider<Citalac> {
  CitaociProvider() : super("Citaoci");

  @override
  Citalac fromJson(data) {
    // TODO: implement fromJson
    return Citalac.fromJson(data);
  }
}
