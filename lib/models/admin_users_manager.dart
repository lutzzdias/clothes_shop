import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';

class AdminUsersManager extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription? _subscription;
  List<User> users = [];

  List<String> get names => users.map((user) => user.name).toList();

  void updateUser(UserManager userManager) {
    _subscription?.cancel();
    if (userManager.isAdmin)
      _listenToUsers();
    else {
      users.clear();
      notifyListeners();
    }
  }

  void _listenToUsers() {
    _subscription = _firestore.collection('users').snapshots().listen(
      (snapshot) {
        users = snapshot.docs.map((doc) => User.fromDocument(doc)).toList();
        users.sort((user1, user2) =>
            user1.name.toLowerCase().compareTo(user2.name.toLowerCase()));
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
