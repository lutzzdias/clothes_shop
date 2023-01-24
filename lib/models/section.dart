import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/section_item.dart';

class Section extends ChangeNotifier {
  String name;
  String type;
  List<SectionItem> items;

  Section({
    this.name = '',
    this.type = '',
    items,
  }) : items = items ?? [];

  Section.fromDocument(DocumentSnapshot doc)
      : name = doc.get('name') as String,
        type = doc.get('type') as String,
        items = (doc.get('items') as List)
            .map((item) => SectionItem.fromMap(item as Map<String, dynamic>))
            .toList();

  Section clone() => Section(
        name: name,
        type: type,
        items: items.map((item) => item.clone()).toList(),
      );

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
