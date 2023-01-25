import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

const token = '887bc7802a93d23b124847f56783e8c5';

class CepAbertoService {
  final Dio dio = Dio();
  Future<void> getAddressFromCep(String cep) async {
    final cleanCep = cep.replaceAll('.', '').replaceAll('-', '');
    final endpoint = 'https://www.cepaberto.com/api/v3/cep?cep=$cleanCep';
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Token token=$token';

    try {
      final response = await dio.get<Map>(endpoint);
      if (response.data?.isEmpty ?? true) return Future.error('CEP Inválido');
      debugPrint(response.data.toString());
    } on DioError catch (e) {
      return Future.error('Erro ao buscar CEP');
    }
  }
}
