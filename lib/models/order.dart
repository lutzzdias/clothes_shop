import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/cart_product.dart';

class Order {
  String orderId;
  List<CartProduct> items;
  num price;
  String userId;
  Address address;
  late Timestamp date;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Order.fromCartManager(CartManager cartManager, this.orderId)
      : items = List.from(cartManager.items),
        price = cartManager.totalPrice,
        userId = cartManager.user!.id,
        address = cartManager.address!;

  Future<void> save() async {
    _firestore.collection('orders').doc(orderId).set({
      'items': items.map((item) => item.toOrderItemMap()).toList(),
      'price': price,
      'user': userId,
      'address': address.toMap(),
    });
  }
}
