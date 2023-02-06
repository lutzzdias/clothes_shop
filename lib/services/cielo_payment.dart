import 'package:loja_virtual/models/credit_card.dart';
import 'package:loja_virtual/models/user.dart';

class CieloPayment {
  Future<void> authorize({
    required CreditCard creditCard,
    required num price,
    required String orderId,
    required User user,
  }) {
    final Map<String, dynamic> dataSale = {
      'merchantOrderId': orderId,
      'amount': (price * 100).toInt(), // Price is sent as cents
      'softDescriptor': 'Loja SESI',
      'installments': 1,
      'creditCard': creditCard.toMap(),
      'cpf': user.cpf,
      'paymentType': 'CreditCard',
    };

    // Call to cloud functions

    // get response

    return Future.value('mock success');
  }
}
