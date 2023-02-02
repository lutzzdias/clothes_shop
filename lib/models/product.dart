import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/item_size.dart';
import 'package:uuid/uuid.dart';

class Product extends ChangeNotifier {
  String id;
  String name;
  String description;
  List<String> images;
  List<ItemSize> sizes;
  bool deleted;
  ItemSize? _selectedSize;
  List<dynamic> newImages = [];
  bool _loading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    sizes,
    this.deleted = false,
  }) : sizes = sizes ?? [];

  Product.fromDocument(DocumentSnapshot document)
      : id = document.id,
        name = document.get('name'),
        description = document.get('description'),
        images = List<String>.from(document.get('images') as List<dynamic>),
        sizes = (document.get('sizes') as List<dynamic>)
            .map(
              (size) => ItemSize.fromMap(size as Map<String, dynamic>),
            )
            .toList(),
        deleted = document.get('deleted') as bool? ?? false;

  Product.empty()
      : id = '',
        name = '',
        description = '',
        images = [],
        sizes = [],
        deleted = false;

  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

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

  bool get hasStock => totalStock > 0 && !deleted;

  num get basePrice {
    num lowest = sizes.first.price;
    for (final size in sizes) {
      if (size.price < lowest) lowest = size.price;
    }

    return lowest;
  }

  DocumentReference get firestoreRef => _firestore.doc('products/$id');
  Reference get storageRef => _storage.ref().child('products').child(id);

  ItemSize? findSize(String name) {
    try {
      return sizes.firstWhere((size) => size.name == name);
    } catch (e) {
      return null;
    }
  }

  List<Map<String, dynamic>> exportSizeList() =>
      sizes.map<Map<String, dynamic>>((size) => size.toMap()).toList();

  Future<void> save() async {
    loading = true;
    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'sizes': exportSizeList(),
      'deleted': deleted,
    };

    if (id.isEmpty) {
      final doc = await _firestore.collection('products').add(data);
      id = doc.id;
    } else {
      await firestoreRef.update(data);
    }

    final List<String> updateImages = [];
    for (final newImage in newImages) {
      if (images.contains(newImage)) {
        updateImages.add(newImage as String);
      } else {
        final TaskSnapshot task =
            await storageRef.child(const Uuid().v4()).putFile(newImage as File);
        final String url = await task.ref.getDownloadURL();
        updateImages.add(url);
      }
    }

    for (final image in images) {
      if (!newImages.contains(image) && image.contains('firebase')) {
        try {
          final ref = _storage.refFromURL(image);
          await ref.delete();
        } catch (e) {
          debugPrint('falha ao deletar $image');
        }
      }
    }

    await firestoreRef.update({'images': updateImages});
    images = updateImages;
    loading = false;
  }

  void delete() {
    firestoreRef.update({'deleted': true});
  }

  Product clone() {
    return Product(
      id: id,
      name: name,
      description: description,
      images: List.from(images),
      sizes: sizes.map((size) => size.clone()).toList(),
      deleted: deleted,
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, description: $description, images: $images, sizes: $sizes, newImages: $newImages}';
  }
}
