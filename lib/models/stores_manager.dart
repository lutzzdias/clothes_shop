import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StoresManager extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StoresManager() {
    _loadStoreList();
  }

  Future<void> _loadStoreList() async {
    final snapshot = await _firestore.collection('stores').get();
    print(snapshot.docs.first.data());
    notifyListeners();
  }
}
