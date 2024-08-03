import 'package:elibrary_mobile/models/autor.dart';
import 'package:elibrary_mobile/models/biblioteka.dart';
import 'package:elibrary_mobile/models/citalac.dart';
import 'package:elibrary_mobile/providers/base_provider.dart';
import 'package:flutter/material.dart';

class BibliotekaProvider extends BaseProvider<Biblioteka> {
  BibliotekaProvider() : super("Biblioteke");

  @override
  Biblioteka fromJson(data) {
    // TODO: implement fromJson
    return Biblioteka.fromJson(data);
  }
}
