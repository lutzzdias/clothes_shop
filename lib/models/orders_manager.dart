import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/order.dart' as model;
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';

class OrdersManager extends ChangeNotifier {
  List<model.Order> orders = [];
  User? user;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void updateUser(UserManager userManager) {
    user = userManager.user;
    if (user != null) {
      _listenToOrders();
    }
  }

  void _listenToOrders() {
    _firestore
        .collection('orders')
        .where('user', isEqualTo: user!.id)
        .snapshots()
        .listen((event) {
      orders.clear();
      for (final doc in event.docs) orders.add(model.Order.fromDocument(doc));
      print(orders);
    });
  }
}
