import 'dart:convert';
import 'package:elibrary_bibliotekar/models/izdavac.dart';
import 'package:elibrary_bibliotekar/models/jezik.dart';
import 'package:elibrary_bibliotekar/models/knjiga.dart';
import 'package:elibrary_bibliotekar/models/search_result.dart';
import 'package:elibrary_bibliotekar/models/uvez.dart';
import 'package:elibrary_bibliotekar/models/vrsta_grade.dart';
import 'package:elibrary_bibliotekar/providers/auth_provider.dart';
import 'package:elibrary_bibliotekar/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class VrstaGradeProvider extends BaseProvider<VrstaGrade> {
  VrstaGradeProvider() : super("VrsteGrade");

  @override
  VrstaGrade fromJson(data) {
    // TODO: implement fromJson
    return VrstaGrade.fromJson(data);
  }
}
