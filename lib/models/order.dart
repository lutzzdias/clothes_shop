import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/cart_product.dart';

enum Status {
  canceled,
  preparing,
  transporting,
  delivered,
}

class Order {
  String orderId;
  List<CartProduct> items;
  num price;
  String userId;
  Address address;
  Timestamp? date;
  Status status;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Order.fromCartManager(CartManager cartManager, this.orderId)
      : items = List.from(cartManager.items),
        price = cartManager.totalPrice,
        userId = cartManager.user!.id,
        address = cartManager.address!,
        status = Status.preparing;

  Order.fromDocument(DocumentSnapshot doc)
      : orderId = doc.id,
        items = (doc.get('items') as List<dynamic>)
            .map((item) => CartProduct.fromMap(item as Map<String, dynamic>))
            .toList(),
        price = doc.get('price') as num,
        userId = doc.get('user') as String,
        address = Address.fromMap(doc.get('address') as Map<String, dynamic>),
        date = doc.get('date') as Timestamp,
        status = Status.values[doc.get('status')];

  String get formattedId => '#${orderId.padLeft(5, '0')}';

  String get statusText => getStatusText(status);

  Function()? get back {
    return status.index >= Status.transporting.index
        ? () {
            status = Status.values[status.index - 1];
            _firestore.collection('orders').doc(orderId).update(
              {'status': status.index},
            );
          }
        : null;
  }

  Function()? get advance {
    return status.index <= Status.transporting.index
        ? () {
            status = Status.values[status.index + 1];
            _firestore.collection('orders').doc(orderId).update(
              {'status': status.index},
            );
          }
        : null;
  }

  static String getStatusText(Status status) {
    switch (status) {
      case Status.canceled:
        return 'Cancelado';
      case Status.preparing:
        return 'Em preparo';
      case Status.transporting:
        return 'Em transporte';
      case Status.delivered:
        return 'Entregue';
      default:
        return 'Erro';
    }
  }

  Future<void> save() async {
    _firestore.collection('orders').doc(orderId).set({
      'items': items.map((item) => item.toOrderItemMap()).toList(),
      'price': price,
      'user': userId,
      'address': address.toMap(),
      'date': Timestamp.now(),
      'status': status.index,
    });
  }

  @override
  String toString() {
    return 'Order{orderId: $orderId, items: $items, price: $price, userId: $userId, address: $address, date: $date}';
  }
}
