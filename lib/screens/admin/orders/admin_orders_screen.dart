import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/common/custom_icon_button.dart';
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
        builder: (_, ordersManager, __) {
          final filteredOrders = ordersManager.filteredOrders;

          return Column(
            children: [
              ordersManager.user != null
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 2),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Pedidos de ${ordersManager.user!.name}',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          CustomIconButton(
                            icon: Icons.close,
                            color: Colors.white,
                            onTap: () => ordersManager.setUserFilter(null),
                          ),
                        ],
                      ),
                    )
                  : filteredOrders.isEmpty
                      ? Expanded(
                          child: const EmptyCard(
                              title: 'Nenhuma venda realizada',
                              iconData: Icons.border_clear),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: filteredOrders.length,
                            itemBuilder: (_, index) => OrderTile(
                              order: filteredOrders[index],
                              showControls: true,
                            ),
                          ),
                        ),
            ],
          );
        },
      ),
    );
  }
}
