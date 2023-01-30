import 'package:flutter/material.dart';
import 'package:loja_virtual/common/price_card.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagamento'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          PriceCard(
            buttonText: 'Finalizar pedido',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
