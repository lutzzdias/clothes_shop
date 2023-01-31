import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/order.dart' as model;
import 'package:loja_virtual/models/user.dart';

class AdminOrdersManager extends ChangeNotifier {
  List<model.Order> orders = [];
  User? user;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription? _subscription;

  void updateAdmin(bool isAdmin) {
    orders.clear();

    _subscription?.cancel();
    if (isAdmin) {
      _listenToOrders();
    }
  }

  void _listenToOrders() {
    _subscription = _firestore.collection('orders').snapshots().listen((event) {
      orders.clear();
      for (final doc in event.docs) orders.add(model.Order.fromDocument(doc));
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}
