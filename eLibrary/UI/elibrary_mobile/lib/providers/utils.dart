import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

String formatNumber(dynamic) {
  var f = NumberFormat('###,00');
  if (dynamic == null) {
    return "";
  }
  return f.format(dynamic);
}

Image imageFromString(String input) {
  return Image.memory(base64Decode(input));
}

String formatDateTimeToLocal(String date) {
  return DateFormat("dd.MM.yyyy. HH:mm")
      .format(
          DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").parseStrict(date.toString()))
      .toString();
}

String formatDateToLocal(String date) {
  return DateFormat("dd.MM.yyyy.")
      .format(
          DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").parseStrict(date.toString()))
      .toString();
}

extension ShowDataInOwnFormat on DateTime {
  String showDateInOwnFormat() {
    return '$day.$month.$year. $hour:$minute';
  }
}
