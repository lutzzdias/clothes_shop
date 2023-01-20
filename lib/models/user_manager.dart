import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/helpers/firebase_errors.dart';
import 'package:loja_virtual/models/user.dart' as model;

class UserManager extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  model.User? user;
  bool _loading = false;

  UserManager() {
    _loadCurrentUser();
  }

  void signIn({
    required model.User user,
    required Function onFail,
    required onSuccess,
  }) async {
    loading = true;
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: user.email,
        password: user.password!,
      );
      await _loadCurrentUser(firebaseUser: result.user);
      onSuccess();
    } on FirebaseAuthException catch (e) {
      onFail(getErrorString(e.code));
    } finally {
      loading = false;
    }
  }

  Future<void> signUp({
    required model.User user,
    required Function onFail,
    required Function onSuccess,
  }) async {
    loading = true;
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password!,
      );
      user.id = result.user!.uid;
      this.user = user;
      notifyListeners();
      await user.saveData();
      onSuccess();
    } on FirebaseAuthException catch (e) {
      onFail(getErrorString(e.code));
    } finally {
      loading = false;
    }
  }

  void signOut() {
    _auth.signOut();
    user = null;
    notifyListeners();
  }

  bool get isLoggedIn => user != null;

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool get isAdmin => isLoggedIn && user!.admin;

  Future<void> _loadCurrentUser({User? firebaseUser}) async {
    User? currentUser = firebaseUser ?? _auth.currentUser;
    if (currentUser != null) {
      final DocumentSnapshot docUser =
          await _firestore.collection('users').doc(currentUser.uid).get();
      user = model.User.fromDocument(docUser);

      final docAdmin =
          await _firestore.collection('admins').doc(user!.id).get();
      if (docAdmin.exists) user!.admin = true;

      notifyListeners();
    }
  }
}
