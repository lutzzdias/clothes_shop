import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/address.dart';

class User {
  String id;
  String name;
  String email;
  String? password;
  String? confirmPassword;
  bool admin;
  Address? address;

  User({
    this.id = '',
    this.name = '',
    required this.email,
    required this.password,
    this.confirmPassword = '',
    this.admin = false,
  });

  User.fromDocument(DocumentSnapshot document)
      : id = document.id,
        name = document.get('name'),
        email = document.get('email'),
        admin = false {
    address = document.data().toString().contains('address')
        ? Address.fromMap(document.get('address') as Map<String, dynamic>)
        : null;
  }

  User.empty({
    this.id = '',
    this.name = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.admin = false,
  });

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.doc('users/$id');

  CollectionReference get cartRef => firestoreRef.collection('cart');

  Future<void> saveData() async {
    await firestoreRef.set(toMap());
  }

  void setAddress(Address address) {
    this.address = address;
    saveData();
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        if (address != null) 'address': address!.toMap(),
      };
}
