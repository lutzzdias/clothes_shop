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
      for (final change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            orders.add(model.Order.fromDocument(change.doc));
            break;
          case DocumentChangeType.modified:
            final modOrder =
                orders.firstWhere((order) => order.orderId == change.doc.id);
            modOrder.updateStatusFromDocument(change.doc);
            break;
          case DocumentChangeType.removed:
            debugPrint('Doc removido que não deveria ser removido nunca');
            break;
        }
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}
