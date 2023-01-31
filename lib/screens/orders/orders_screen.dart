import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/common/empty_card.dart';
import 'package:loja_virtual/common/login_card.dart';
import 'package:loja_virtual/common/order_tile.dart';
import 'package:loja_virtual/models/orders_manager.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
        centerTitle: true,
      ),
      body: Consumer<OrdersManager>(
        builder: (_, ordersManager, __) => ordersManager.user == null
            ? const LoginCard()
            : ordersManager.orders.isEmpty
                ? const EmptyCard(
                    title: 'Nenhuma compra encontrada',
                    iconData: Icons.border_clear)
                : ListView.builder(
                    itemCount: ordersManager.orders.length,
                    itemBuilder: (_, index) => OrderTile(
                        order: ordersManager.orders.reversed.toList()[index]),
                  ),
      ),
    );
  }
}
