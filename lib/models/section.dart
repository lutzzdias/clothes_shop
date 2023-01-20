import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/section_item.dart';

class Section {
  String name;
  String type;
  List<SectionItem> items;

  Section.fromDocument(DocumentSnapshot doc)
      : name = doc.get('name') as String,
        type = doc.get('type') as String,
        items = (doc.get('items') as List)
            .map((item) => SectionItem.fromMap(item as Map<String, dynamic>))
            .toList();

  @override
  String toString() {
    return 'Section { name: $name, type: $type, items: $items }';
  }
}
