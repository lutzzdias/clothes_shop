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
  Timestamp? date;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Order.fromCartManager(CartManager cartManager, this.orderId)
      : items = List.from(cartManager.items),
        price = cartManager.totalPrice,
        userId = cartManager.user!.id,
        address = cartManager.address!;

  Order.fromDocument(DocumentSnapshot doc)
      : orderId = doc.id,
        items = (doc.get('items') as List<dynamic>)
            .map((item) => CartProduct.fromMap(item as Map<String, dynamic>))
            .toList(),
        price = doc.get('price') as num,
        userId = doc.get('user') as String,
        address = Address.fromMap(doc.get('address') as Map<String, dynamic>),
        date = null; //doc.get('date') as Timestamp;

  Future<void> save() async {
    _firestore.collection('orders').doc(orderId).set({
      'items': items.map((item) => item.toOrderItemMap()).toList(),
      'price': price,
      'user': userId,
      'address': address.toMap(),
    });
  }

  @override
  String toString() {
    return 'Order{orderId: $orderId, items: $items, price: $price, userId: $userId, address: $address, date: $date}';
  }
}
