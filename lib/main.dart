import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/admin_users_manager.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/product_manager.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/screens/address/address_screen.dart';
import 'package:loja_virtual/screens/base/base_screen.dart';
import 'package:loja_virtual/screens/cart/cart_screen.dart';
import 'package:loja_virtual/screens/edit_product/edit_product_screen.dart';
import 'package:loja_virtual/screens/login/login_screen.dart';
import 'package:loja_virtual/screens/product/product_screen.dart';
import 'package:loja_virtual/screens/select_product/select_product_screen.dart';
import 'package:loja_virtual/screens/signup/signup_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserManager>(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider<ProductManager>(
          create: (_) => ProductManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          create: (_) => CartManager(),
          lazy: false,
          update: (_, userManager, cartManager) =>
              cartManager!..updateUser(userManager),
        ),
        ChangeNotifierProvider<HomeManager>(
          create: (_) => HomeManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          lazy: false,
          update: (_, userManager, adminUsersManager) =>
              adminUsersManager!..updateUser(userManager),
        ),
      ],
      child: MaterialApp(
        title: 'Lütz\' store',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 4, 125, 141),
          appBarTheme: AppBarTheme.of(context).copyWith(
            elevation: 0,
            backgroundColor: const Color.fromARGB(255, 4, 125, 141),
          ),
          scaffoldBackgroundColor: const Color.fromARGB(255, 4, 125, 141),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/base',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/base':
              return MaterialPageRoute(builder: (_) => BaseScreen());
            case '/signup':
              return MaterialPageRoute(builder: (_) => SignUpScreen());
            case '/login':
              return MaterialPageRoute(builder: (_) => LoginScreen());
            case '/product':
              return MaterialPageRoute(
                builder: (_) =>
                    ProductScreen(product: settings.arguments as Product),
              );
            case '/cart':
              return MaterialPageRoute(
                builder: (_) => const CartScreen(),
              );
            case '/address':
              return MaterialPageRoute(
                builder: (_) => const AddressScreen(),
              );
            case '/edit_product':
              return MaterialPageRoute(
                builder: (_) =>
                    EditProductScreen(product: settings.arguments as Product?),
              );
            case '/select_product':
              return MaterialPageRoute(
                builder: (_) => const SelectProductScreen(),
              );
            default:
              return MaterialPageRoute(builder: (_) => BaseScreen());
          }
        },
      ),
    );
  }
}
