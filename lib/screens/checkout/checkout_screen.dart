import 'package:flutter/material.dart';
import 'package:loja_virtual/common/price_card.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/checkout_manager.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CartManager, CheckoutManager>(
      lazy: false,
      create: (_) => CheckoutManager(),
      update: (_, cartManager, checkoutManager) =>
          checkoutManager!..updateCart(cartManager),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pagamento'),
          centerTitle: true,
        ),
        body: Consumer<CheckoutManager>(
          builder: (_, checkoutManager, __) => checkoutManager.loading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Processando seu pagamento...',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                )
              : ListView(
                  children: [
                    PriceCard(
                      buttonText: 'Finalizar pedido',
                      onPressed: () async {
                        await checkoutManager.checkout(onStockFail: (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                              backgroundColor: Colors.red,
                            ),
                          );
                          Navigator.of(context).popUntil(
                              (route) => route.settings.name == '/cart');
                        }, onSuccess: (order) {
                          Navigator.of(context).popUntil(
                              (route) => route.settings.name == '/base');
                          Navigator.of(context)
                              .pushNamed('/confirmation', arguments: order);
                        });
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
