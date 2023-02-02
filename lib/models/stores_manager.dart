import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/store.dart';

class StoresManager extends ChangeNotifier {
  List<Store> stores = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Timer? _timer;

  StoresManager() {
    _loadStoreList();
    _startTimer();
  }

  Future<void> _loadStoreList() async {
    final snapshot = await _firestore.collection('stores').get();
    stores =
        snapshot.docs.map((storeDoc) => Store.fromDocument(storeDoc)).toList();
    notifyListeners();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkOpening();
    });
  }

  void _checkOpening() {
    for (final store in stores) store.updateStatus();
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }
}
