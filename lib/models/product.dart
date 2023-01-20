import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/item_size.dart';

class Product extends ChangeNotifier {
  String id;
  String name;
  String description;
  List<String> images;
  List<ItemSize> sizes;
  ItemSize? _selectedSize;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
  }) : sizes = [];

  Product.fromDocument(DocumentSnapshot document)
      : id = document.id,
        name = document.get('name'),
        description = document.get('description'),
        images = List<String>.from(document.get('images') as List<dynamic>),
        sizes = (document.get('sizes') as List<dynamic>)
            .map(
              (size) => ItemSize.fromMap(size as Map<String, dynamic>),
            )
            .toList();

  set selectedSize(ItemSize? size) {
    _selectedSize = size;
    notifyListeners();
  }

  ItemSize? get selectedSize => _selectedSize;

  int get totalStock {
    int stock = 0;
    for (final size in sizes) stock += size.stock;
    return stock;
  }

  bool get hasStock => totalStock > 0;

  ItemSize? findSize(String name) {
    try {
      return sizes.firstWhere((size) => size.name == name);
    } catch (e) {
      return null;
    }
  }
}
