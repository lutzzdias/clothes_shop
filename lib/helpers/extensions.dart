import 'package:flutter/material.dart';

extension Date on TimeOfDay {
  String formatted() => '$hour:${minute.toString().padLeft(2, '0')}';
  int toMinutes() => hour * 60 + minute;
}
