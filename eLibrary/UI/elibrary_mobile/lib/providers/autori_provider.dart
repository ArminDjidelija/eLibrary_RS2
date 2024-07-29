import 'package:elibrary_mobile/models/autor.dart';
import 'package:elibrary_mobile/providers/base_provider.dart';
import 'package:flutter/material.dart';

class AutoriProvider extends BaseProvider<Autor> {
  AutoriProvider() : super("Autori");

  @override
  Autor fromJson(data) {
    // TODO: implement fromJson
    return Autor.fromJson(data);
  }
}
