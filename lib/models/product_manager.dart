import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/product.dart';

class ProductManager extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Product> _allProducts = [];
  String _search = '';

  ProductManager() {
    _loadAllProducts();
  }

  List<Product> get allProducts => _allProducts;

  List<Product> get filteredProducts {
    final List<Product> filteredProducts = [];
    if (search.isEmpty)
      filteredProducts.addAll(allProducts);
    else
      filteredProducts.addAll(
        allProducts.where(
          (product) =>
              product.name.toLowerCase().contains(search.toLowerCase()),
        ),
      );
    return filteredProducts;
  }

  String get search => _search;

  set search(String query) {
    _search = query;
    notifyListeners();
  }

  Future<void> _loadAllProducts() async {
    final QuerySnapshot snapProducts =
        await _firestore.collection('products').get();

    _allProducts =
        snapProducts.docs.map((doc) => Product.fromDocument(doc)).toList();
    notifyListeners();
  }

  Product? findProductById(String? id) {
    try {
      return allProducts.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  void update(Product product) {
    allProducts.removeWhere((prevProduct) => prevProduct.id == product.id);
    allProducts.add(product);
    notifyListeners();
  }
}
