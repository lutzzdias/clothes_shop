import 'package:flutter/services.dart';

abstract class Env {
  static final Future<Map<String, String>> env = init();
  static Future<Map<String, String>> init() async {
    final lines = await rootBundle.loadString('.env');
    Map<String, String> env = {};
    for (String line in lines.split('\n')) {
      line = line.trim();
      if (line.contains('=') && !line.startsWith(RegExp(r'=|#'))) {
        List<String> contents = line.split('=');
        env[contents[0]] = contents.sublist(1).join('=');
      }
    }
    return env;
  }

  static get cepAbertoToken async {
    final doneEnv = await env;
    return doneEnv['CEPABERTO_KEY'];
  }
}
