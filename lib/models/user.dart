import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:loja_virtual/models/address.dart';

class User {
  String id;
  String name;
  String cpf;
  String email;
  String? password;
  String? confirmPassword;
  bool admin;
  Address? address;

  final _notification = FirebaseMessaging.instance;

  User({
    this.id = '',
    this.name = '',
    this.cpf = '',
    required this.email,
    required this.password,
    this.confirmPassword = '',
    this.admin = false,
  });

  User.fromDocument(DocumentSnapshot document)
      : id = document.id,
        name = document.get('name'),
        cpf = document.get('cpf'),
        email = document.get('email'),
        admin = false {
    address = document.data().toString().contains('address')
        ? Address.fromMap(document.get('address') as Map<String, dynamic>)
        : null;
  }

  User.empty({
    this.id = '',
    this.name = '',
    this.cpf = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.admin = false,
  });

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.doc('users/$id');

  CollectionReference get cartRef => firestoreRef.collection('cart');

  CollectionReference get tokensRef => firestoreRef.collection('tokens');

  Future<void> saveData() async {
    await firestoreRef.set(toMap());
  }

  void setAddress(Address address) {
    this.address = address;
    saveData();
  }

  void setCpf(String cpf) {
    this.cpf = cpf;
    saveData();
  }

  Future<void> saveToken() async {
    final token = await _notification.getToken();
    tokensRef.doc(token).set({
      'token': token,
      'updatedAt': FieldValue.serverTimestamp(),
      'platform': Platform.operatingSystem,
    });
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        if (cpf.isNotEmpty) 'cpf': cpf,
        'email': email,
        if (address != null) 'address': address!.toMap(),
      };
}
