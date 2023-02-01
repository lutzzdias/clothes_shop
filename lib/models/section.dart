import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/section_item.dart';
import 'package:uuid/uuid.dart';

class Section extends ChangeNotifier {
  String id;
  String name;
  String type;
  List<SectionItem> items;
  List<SectionItem> originalItems;
  String? _error;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Section({
    this.id = '',
    this.name = '',
    this.type = '',
    items,
  })  : items = items ?? [],
        originalItems = List.from(items ?? []);

  Section.fromDocument(DocumentSnapshot doc)
      : id = doc.id,
        name = doc.get('name') as String,
        type = doc.get('type') as String,
        items = (doc.get('items') as List)
            .map((item) => SectionItem.fromMap(item as Map<String, dynamic>))
            .toList(),
        originalItems = (doc.get('items') as List)
            .map((item) => SectionItem.fromMap(item as Map<String, dynamic>))
            .toList();

  DocumentReference get firestoreRef => _firestore.doc('home/$id');
  Reference get storageRef => _storage.ref().child('home/$id');

  String? get error => _error;
  set error(String? value) {
    _error = value;
    notifyListeners();
  }

  Section clone() => Section(
        id: id,
        name: name,
        type: type,
        items: items.map((item) => item.clone()).toList(),
      );

  bool valid() {
    if (name.isEmpty)
      error = 'Título inválido';
    else if (items.isEmpty)
      error = 'Insira ao menos uma imagem';
    else
      error = null;

    return error == null;
  }

  Future<void> save(int position) async {
    final Map<String, dynamic> data = {
      'name': name,
      'type': type,
      'position': position,
    };

    if (id.isEmpty) {
      final doc = await _firestore.collection('home').add(data);
      id = doc.id;
    } else {
      await firestoreRef.update(data);
    }

    for (final item in items) {
      if (item.image is File) {
        final TaskSnapshot task = await storageRef
            .child(const Uuid().v4())
            .putFile(item.image as File);
        final String url = await task.ref.getDownloadURL();
        item.image = url;
      }
    }

    for (final original in originalItems) {
      if (!items.contains(original) && original.image.contains('firebase')) {
        try {
          final ref = _storage.refFromURL(original.image as String);
          await ref.delete();
        } catch (e) {
          debugPrint('falha ao deletar $original');
        }
      }
    }

    final Map<String, dynamic> itemsData = {
      'items': items.map((item) => item.toMap()).toList(),
    };

    firestoreRef.update(itemsData);
  }

  Future<void> delete() async {
    await firestoreRef.delete();
    for (final item in items) {
      if (item.image.contains('firebase')) {
        try {
          final ref = _storage.refFromURL(item.image as String);
          await ref.delete();
        } catch (e) {
          debugPrint('falha ao deletar ${item.image}');
        }
      }
    }
  }

  void addItem(SectionItem item) {
    items.add(item);
    notifyListeners();
  }

  void removeItem(SectionItem item) {
    items.remove(item);
    notifyListeners();
  }

  @override
  String toString() {
    return 'Section { name: $name, type: $type, items: $items }';
  }
}
