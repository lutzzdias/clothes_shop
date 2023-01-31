import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/order.dart' as model;
import 'package:loja_virtual/models/product.dart';

class CheckoutManager extends ChangeNotifier {
  late CartManager cartManager;
  bool _loading = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void updateCart(CartManager cartManager) {
    this.cartManager = cartManager;
  }

  Future<void> checkout(
      {required Function onStockFail, required Function onSuccess}) async {
    loading = true;
    try {
      await _decrementStock();
    } catch (e) {
      onStockFail(e);
      loading = false;
      return;
    }

    // TODO: Process payment

    final orderId = await _getOrderId();
    final order = model.Order.fromCartManager(cartManager, orderId.toString());
    order.save();

    cartManager.clear();
    onSuccess(order);
    loading = false;
  }

  Future<void> _decrementStock() {
    return _firestore.runTransaction(
      (transaction) async {
        final List<Product> productsToUpdate = [];
        final List<Product> productsWithoutStock = [];
        for (final cartProduct in cartManager.items) {
          Product product;

          if (productsToUpdate
              .any((prod) => prod.id == cartProduct.productId)) {
            product = productsToUpdate
                .firstWhere((prod) => prod.id == cartProduct.productId);
          } else {
            final doc = await transaction
                .get(_firestore.doc('products/${cartProduct.productId}'));
            product = Product.fromDocument(doc);
          }

          cartProduct.product = product;

          final size = product.findSize(cartProduct.size);

          if (size!.stock - cartProduct.quantity < 0) {
            productsWithoutStock.add(product);
          } else {
            size.stock -= cartProduct.quantity;
            productsToUpdate.add(product);
          }
        }

        if (productsWithoutStock.isNotEmpty)
          return Future.error(
              '${productsWithoutStock.length} produtos sem estoque');

        for (final product in productsToUpdate) {
          transaction.update(
            _firestore.doc('products/${product.id}'),
            {'sizes': product.exportSizeList()},
          );
        }
      },
    );
  }

  Future<int> _getOrderId() async {
    final ref = _firestore.doc('aux/ordercounter');

    try {
      final result = await _firestore.runTransaction(
        (transaction) async {
          final doc = await transaction.get(ref);
          final orderId = doc.get('current') as int;
          transaction.update(
            ref,
            {'current': orderId + 1},
          );
          return {'orderId': orderId};
        },
      );

      return result['orderId'] as int;
    } catch (e) {
      debugPrint(e.toString());
      return Future.error('Falha ao gerar número do pedido');
    }
  }
}
