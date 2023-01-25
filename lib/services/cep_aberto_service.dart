import 'dart:io';

import 'package:dio/dio.dart';
import 'package:loja_virtual/helpers/env.dart';
import 'package:loja_virtual/models/cep_aberto_address.dart';

class CepAbertoService {
  final Dio dio = Dio();

  get token async => await Env.cepAbertoToken;

  Future<CepAbertoAddress> getAddressFromCep(String cep) async {
    final cleanCep = cep.replaceAll('.', '').replaceAll('-', '');
    final endpoint = 'https://www.cepaberto.com/api/v3/cep?cep=$cleanCep';
    dio.options.headers[HttpHeaders.authorizationHeader] =
        'Token token=${await token}';
    try {
      final response = await dio.get<Map<String, dynamic>>(endpoint);
      if (response.data == null || response.data!.isEmpty)
        return Future.error('CEP Inválido');

      final CepAbertoAddress address = CepAbertoAddress.fromMap(response.data!);
      return address;
    } on DioError catch (e) {
      return Future.error('Erro ao buscar CEP');
    }
  }
}
