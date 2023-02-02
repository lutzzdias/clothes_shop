import 'package:flutter/material.dart';
import 'package:loja_virtual/common/price_card.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/screens/address/components/address_card.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrega'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const AddressCard(),
          Consumer<CartManager>(
            builder: (_, cartManager, __) => PriceCard(
              buttonText: 'Continuar para o pagamento',
              onPressed: cartManager.isAddressValid
                  ? () {
                      Navigator.of(context).pushNamed('/checkout');
                    }
                  : null,
            ),
          )
        ],
      ),
    );
  }
}
