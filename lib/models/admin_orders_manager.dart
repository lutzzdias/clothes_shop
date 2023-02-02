import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/order.dart' as model;
import 'package:loja_virtual/models/order.dart';
import 'package:loja_virtual/models/user.dart';

class AdminOrdersManager extends ChangeNotifier {
  final List<model.Order> _orders = [];
  User? user;
  List<Status> statusFilter = [Status.preparing];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription? _subscription;

  List<model.Order> get filteredOrders {
    List<model.Order> output = _orders.reversed.toList();
    output =
        output.where((order) => statusFilter.contains(order.status)).toList();
    return user != null
        ? output.where((order) => order.userId == user!.id).toList()
        : output;
  }

  void setUserFilter(User? user) {
    this.user = user;
    notifyListeners();
  }

  void setStatusFilter({required Status status, required bool enabled}) {
    if (enabled) statusFilter.add(status);
    else statusFilter.remove(status);
    notifyListeners();
  }

  void updateAdmin(bool isAdmin) {
    _orders.clear();

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
            _orders.add(model.Order.fromDocument(change.doc));
            break;
          case DocumentChangeType.modified:
            final modOrder =
                _orders.firstWhere((order) => order.orderId == change.doc.id);
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
