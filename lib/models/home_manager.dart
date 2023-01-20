import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/section.dart';

class HomeManager extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<Section> _sections = [];
  HomeManager() {
    _loadSections();
  }

  List<Section> get sections => _sections;

  Future<void> _loadSections() async {
    _firestore.collection('home').snapshots().listen(
      (snapshot) {
        _sections.clear();
        for (final DocumentSnapshot doc in snapshot.docs) {
          _sections.add(Section.fromDocument(doc));
        }
        notifyListeners();
      },
    );
  }
}
