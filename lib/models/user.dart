import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String name;
  String email;
  String? password;
  String? confirmPassword;
  bool admin;

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
        admin = false;

  User.late({
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

  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
      };
}
