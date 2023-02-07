import 'package:flutter/foundation.dart';
import 'package:loja_virtual/models/credit_card.dart';
import 'package:loja_virtual/models/user.dart';

class CieloPayment {
  Future<void> authorize({
    required CreditCard creditCard,
    required num price,
    required String orderId,
    required User user,
  }) async {
    final Map<String, dynamic> dataSale = {
      'merchantOrderId': orderId,
      'amount': (price * 100).toInt(), // Price is sent as cents
      'softDescriptor': 'Loja SESI',
      'installments': 1,
      'creditCard': creditCard.toMap(),
      'cpf': user.cpf,
      'paymentType': 'CreditCard',
    };

    // Call to cloud function

    // get response

    debugPrint('mock authorized');
    return;
  }

  Future<void> capture(String paymentId) async {
    final Map<String, dynamic> captureData = {
      'paymentId': paymentId,
    };

    // Call to cloud function

    // Get response

    debugPrint('mock captured');
    return;
  }

  Future<void> cancel(String paymentId) async {
    final Map<String, dynamic> cancelData = {
      'paymentId': paymentId,
    };

    // Call to cloud function

    // Get response

    debugPrint('mock canceled');
    return;
  }
}
