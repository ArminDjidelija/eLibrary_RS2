import 'dart:convert';
import 'package:elibrary_bibliotekar/models/jezik.dart';
import 'package:elibrary_bibliotekar/models/knjiga.dart';
import 'package:elibrary_bibliotekar/models/search_result.dart';
import 'package:elibrary_bibliotekar/providers/auth_provider.dart';
import 'package:elibrary_bibliotekar/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class JezikProvider extends BaseProvider<Jezik> {
  JezikProvider() : super("Jezici");

  @override
  Jezik fromJson(data) {
    // TODO: implement fromJson
    return Jezik.fromJson(data);
  }
}
