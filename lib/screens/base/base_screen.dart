import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/models/page_manager.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/screens/admin/users/users_screen.dart';
import 'package:loja_virtual/screens/home/home_screen.dart';
import 'package:loja_virtual/screens/products/products_screen.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatelessWidget {
  final PageController pageController = PageController();
  BaseScreen({Key? key}) : super(key: key);

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
            Scaffold(
              drawer: const CustomDrawer(),
              appBar: AppBar(
                title: const Text('Meus pedidos'),
              ),
            ),
            Scaffold(
              drawer: const CustomDrawer(),
              appBar: AppBar(
                title: const Text('Lojas'),
              ),
            ),
            if (userManager.isAdmin) ...[
              const UsersScreen(),
              Scaffold(
                drawer: const CustomDrawer(),
                appBar: AppBar(
                  title: const Text('Pedidos'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}