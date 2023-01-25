import 'package:flutter/material.dart';
import 'package:loja_virtual/models/product_manager.dart';
import 'package:provider/provider.dart';

class SelectProductScreen extends StatelessWidget {
  const SelectProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Vincular Produto'),
        centerTitle: true,
      ),
      body: Consumer<ProductManager>(
        builder: (_, productManager, __) => ListView.builder(
            itemCount: productManager.allProducts.length,
            itemBuilder: (context, index) {
              final product = productManager.allProducts[index];
              return ListTile(
                leading: Image.network(product.images.first),
                title: Text(product.name),
                subtitle: Text(
                  'R\$ ${product.basePrice.toStringAsFixed(2)}',
                ),
                onTap: () => Navigator.of(context).pop(product),
              );
            }),
      ),
    );
  }
}
