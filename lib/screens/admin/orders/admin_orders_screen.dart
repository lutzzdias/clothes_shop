import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/common/empty_card.dart';
import 'package:loja_virtual/common/order/order_tile.dart';
import 'package:loja_virtual/models/admin_orders_manager.dart';
import 'package:provider/provider.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Todos os Pedidos'),
        centerTitle: true,
      ),
      body: Consumer<AdminOrdersManager>(
        builder: (_, ordersManager, __) => ordersManager.orders.isEmpty
            ? const EmptyCard(
                title: 'Nenhuma venda realizada', iconData: Icons.border_clear)
            : ListView.builder(
                itemCount: ordersManager.orders.length,
                itemBuilder: (_, index) => OrderTile(
                  order: ordersManager.orders.reversed.toList()[index],
                  showControls: true,
                ),
              ),
      ),
    );
  }
}
