import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/section.dart';

class HomeManager extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<Section> _sections = [];
  List<Section> _editingSections = [];
  bool _editing = false;
  HomeManager() {
    _loadSections();
  }

  List<Section> get sections => editing ? _editingSections : _sections;
  bool get editing => _editing;

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

  void addSection(Section section){
    _editingSections.add(section);
    notifyListeners();
  }

  void removeSection(Section section) {
    _editingSections.remove(section);
    notifyListeners();
  }

  void enterEditing() {
    _editing = true;

    _editingSections = _sections.map((section) => section.clone()).toList();

    notifyListeners();
  }

  void saveEditing() {
    _editing = false;
    notifyListeners();
  }

  void discardEditing() {
    _editing = false;
    notifyListeners();
  }
}
