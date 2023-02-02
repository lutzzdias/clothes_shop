import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_icon_button.dart';
import 'package:loja_virtual/models/cart_product.dart';
import 'package:provider/provider.dart';

class CartTile extends StatelessWidget {
  final CartProduct cartProduct;
  const CartTile({Key? key, required this.cartProduct}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: cartProduct,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(
          '/product',
          arguments: cartProduct.product,
        ),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Row(
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: Image.network(cartProduct.product!.images.first),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cartProduct.product!.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Tamanho ${cartProduct.size}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        Consumer<CartProduct>(
                            builder: (_, cartProduct, __) =>
                                cartProduct.hasStock
                                    ? Text(
                                        'R\$ ${cartProduct.unitPrice.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : const Text(
                                        'Sem estoque suficiente',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      )),
                      ],
                    ),
                  ),
                ),
                Consumer<CartProduct>(
                  builder: (_, cartProduct, __) => Column(
                    children: [
                      CustomIconButton(
                        icon: Icons.add,
                        onTap: cartProduct.increment,
                      ),
                      Text(
                        cartProduct.quantity.toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                      CustomIconButton(
                        icon: Icons.remove,
                        color: cartProduct.quantity > 1
                            ? Theme.of(context).primaryColor
                            : Colors.red,
                        onTap: cartProduct.decrement,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
