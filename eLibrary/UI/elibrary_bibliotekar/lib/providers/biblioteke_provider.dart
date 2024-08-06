import 'package:elibrary_bibliotekar/models/autor.dart';
import 'package:elibrary_bibliotekar/models/biblioteka.dart';
import 'package:elibrary_bibliotekar/models/citalac.dart';
import 'package:elibrary_bibliotekar/providers/base_provider.dart';
import 'package:flutter/material.dart';

class BibliotekeProvider extends BaseProvider<Biblioteka> {
  BibliotekeProvider() : super("Biblioteke");

  @override
  Biblioteka fromJson(data) {
    // TODO: implement fromJson
    return Biblioteka.fromJson(data);
  }
}
