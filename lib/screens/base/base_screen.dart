import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/page_manager.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/screens/admin/orders/admin_orders_screen.dart';
import 'package:loja_virtual/screens/admin/users/admin_users_screen.dart';
import 'package:loja_virtual/screens/home/home_screen.dart';
import 'package:loja_virtual/screens/orders/orders_screen.dart';
import 'package:loja_virtual/screens/products/products_screen.dart';
import 'package:loja_virtual/screens/stores/stores_screen.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageController pageController = PageController();

  void configFCM() {
    final fcm = FirebaseMessaging.instance;
    if (Platform.isIOS) fcm.requestPermission(provisional: true);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage msg) {
      print('onLaunch or Resume: $msg');
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
      showNotification(
        title: msg.data['notification']['title'] as String,
        message: msg.data['notification']['body'] as String,
      );
    });
  }

  void showNotification({required String title, required String message}) {
    Flushbar(
      title: title,
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      isDismissible: true,
      backgroundColor: Theme.of(context).primaryColor,
      duration: const Duration(seconds: 5),
      icon: const Icon(Icons.shopping_cart, color: Colors.white),
    ).show(context);
  }

  @override
  void initState() {
    super.initState();
    configFCM();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PageManager(pageController: pageController),
      child: Consumer<UserManager>(
        builder: (_, userManager, __) => PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const HomeScreen(),
            const ProductsScreen(),
            const OrdersScreen(),
            const StoresScreen(),
            if (userManager.isAdmin) ...[
              const AdminUsersScreen(),
              AdminOrdersScreen(),
            ],
          ],
        ),
      ),
    );
  }
}
