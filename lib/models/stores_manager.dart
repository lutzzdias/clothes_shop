import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/store.dart';

class StoresManager extends ChangeNotifier {
  List<Store> stores = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StoresManager() {
    _loadStoreList();
  }

  Future<void> _loadStoreList() async {
    final snapshot = await _firestore.collection('stores').get();
    stores =
        snapshot.docs.map((storeDoc) => Store.fromDocument(storeDoc)).toList();
    notifyListeners();
  }
}
