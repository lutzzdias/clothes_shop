import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/section.dart';

class HomeManager extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<Section> _sections = [];
  List<Section> _editingSections = [];
  bool _editing = false;
  bool loading = false;
  HomeManager() {
    _loadSections();
  }

  List<Section> get sections => editing ? _editingSections : _sections;
  bool get editing => _editing;

  Future<void> _loadSections() async {
    _firestore.collection('home').orderBy('position').snapshots().listen(
      (snapshot) {
        _sections.clear();
        for (final DocumentSnapshot doc in snapshot.docs) {
          _sections.add(Section.fromDocument(doc));
        }
        notifyListeners();
      },
    );
  }

  void addSection(Section section) {
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

  Future<void> saveEditing() async {
    bool valid = true;
    for (final Section section in _editingSections) {
      if (!section.valid()) {
        valid = false;
        break;
      }
    }

    if (!valid) return;

    loading = true;
    notifyListeners();

    int position = 0;
    for (final Section section in _editingSections) {
      await section.save(position);
      position++;
    }

    for (final Section section in List.from(_sections)) {
      if (!_editingSections
          .any((originalSection) => originalSection.id == section.id)) {
        await section.delete();
      }
    }

    loading = false;
    _editing = false;
    notifyListeners();
  }

  void discardEditing() {
    _editing = false;
    notifyListeners();
  }
}
