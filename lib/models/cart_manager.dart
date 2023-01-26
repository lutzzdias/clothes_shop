import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_product.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/services/cep_aberto_service.dart';

class CartManager extends ChangeNotifier {
  List<CartProduct> items = [];
  User? user;
  Address? address;
  num? deliveryPrice;
  num productsPrice = 0.0;
  bool _loading = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool get isCartValid {
    for (final CartProduct cartProduct in items)
      if (!cartProduct.hasStock) return false;
    return true;
  }

  bool get isAddressValid => address != null && deliveryPrice != null;

  num get totalPrice => productsPrice + (deliveryPrice ?? 0);

  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void updateUser(UserManager userManager) {
    user = userManager.user;
    items.clear();

    if (user != null) {
      _loadCartItems();
    }
  }

  _loadCartItems() async {
    final QuerySnapshot? cartSnap = await user?.cartRef.get();
    items = cartSnap?.docs.map((doc) {
          final item = CartProduct.fromDocument(doc);
          item.addListener(() => _onItemUpdated(item));
          return item;
        }).toList() ??
        [];
  }

  void addToCart(Product product) {
    try {
      final cartItem = items.firstWhere((item) => item.stackable(product));
      cartItem.increment();
    } catch (e) {
      final CartProduct cartProduct = CartProduct.fromProduct(product);
      cartProduct.addListener(() => _onItemUpdated(cartProduct));
      items.add(cartProduct);
      user?.cartRef.add(cartProduct.toMap()).then((doc) {
        cartProduct.id = doc.id;
        _onItemUpdated(cartProduct);
      });
    }
    notifyListeners();
  }

  void _onItemUpdated(CartProduct cartProduct) {
    if (cartProduct.quantity > 0)
      _updateCartProduct(cartProduct);
    else
      _removeFromCart(cartProduct);
    _calculateTotalPrice();
    notifyListeners();
  }

  void _removeFromCart(CartProduct cartProduct) {
    items.removeWhere((element) => element.id == cartProduct.id);
    user!.cartRef.doc(cartProduct.id).delete();
    cartProduct.removeListener(() => _onItemUpdated(cartProduct));
    notifyListeners();
  }

  void _updateCartProduct(CartProduct cartProduct) {
    user!.cartRef.doc(cartProduct.id).update(cartProduct.toMap());
  }

  void _calculateTotalPrice() {
    productsPrice = 0;
    for (CartProduct cartProduct in items)
      productsPrice += cartProduct.totalPrice;
  }

  // ADDRESS
  Future<void> getAddress(String cep) async {
    loading = true;
    final cepAbertoService = CepAbertoService();
    try {
      final cepAbertoAddress = await cepAbertoService.getAddressFromCep(cep);
      address = Address(
        street: cepAbertoAddress.logradouro,
        number: null,
        complement: null,
        district: cepAbertoAddress.bairro,
        zipCode: cepAbertoAddress.cep,
        city: cepAbertoAddress.cidade.nome,
        state: cepAbertoAddress.estado.sigla,
        latitude: cepAbertoAddress.latitude,
        longitude: cepAbertoAddress.longitude,
      );
      loading = false;
    } catch (e) {
      loading = false;
      return Future.error('CEP Inválido');
    }
  }

  Future<void> setAddress(Address address) async {
    loading = true;
    this.address = address;
    if (await _calculateDelivery(
      lat: address.latitude,
      long: address.longitude,
    )) {
      loading = false;
    } else {
      loading = false;
      return Future.error('Endereço fora do raio de entrega');
    }
  }

  void removeAddress() {
    address = null;
    deliveryPrice = null;
    notifyListeners();
  }

  Future<bool> _calculateDelivery(
      {required double lat, required double long}) async {
    final DocumentSnapshot doc = await _firestore.doc('aux/delivery').get();
    final latStore = doc.get('lat') as double;
    final longStore = doc.get('long') as double;
    final maxKm = doc.get('maxKm') as num;
    final base = doc.get('base') as num;
    final km = doc.get('km') as num;

    // distance in meters
    double distance =
        Geolocator.distanceBetween(latStore, longStore, lat, long);

    // distance in kilometers
    distance /= 1000;

    if (distance > maxKm) return false;

    deliveryPrice = base + distance * km;
    return true;
  }
}
