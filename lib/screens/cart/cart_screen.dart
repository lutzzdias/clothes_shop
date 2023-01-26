import 'package:flutter/material.dart';
import 'package:loja_virtual/common/empty_card.dart';
import 'package:loja_virtual/common/login_card.dart';
import 'package:loja_virtual/common/price_card.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/screens/cart/components/cart_tile.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
        centerTitle: true,
      ),
      body: Consumer<CartManager>(
        builder: (_, cartManager, __) {
          if (cartManager.user == null)
            return const LoginCard();
          else if (cartManager.items.isEmpty)
            return const EmptyCard(
              iconData: Icons.remove_shopping_cart,
              title: 'Nenhum produto no carrinho',
            );
          else
            return ListView(
              children: [
                Column(
                  children: cartManager.items
                      .map((cartProduct) => CartTile(cartProduct: cartProduct))
                      .toList(),
                ),
                PriceCard(
                  buttonText: 'Continuar para Entrega',
                  onPressed: cartManager.isCartValid
                      ? () => Navigator.of(context).pushNamed('/address')
                      : null,
                ),
              ],
            );
        },
      ),
    );
  }
}
