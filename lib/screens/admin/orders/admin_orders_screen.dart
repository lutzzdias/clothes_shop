import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/common/custom_icon_button.dart';
import 'package:loja_virtual/common/empty_card.dart';
import 'package:loja_virtual/common/order/order_tile.dart';
import 'package:loja_virtual/models/admin_orders_manager.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AdminOrdersScreen extends StatelessWidget {
  final PanelController _panelController = PanelController();
  AdminOrdersScreen({Key? key}) : super(key: key);

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

          return SlidingUpPanel(
            minHeight: 40,
            maxHeight: 240,
            controller: _panelController,
            body: Column(
              children: [
                ordersManager.user != null
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 2),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Pedidos de ${ordersManager.user!.name}',
                                style: const TextStyle(
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
                        ? const Expanded(
                            child: EmptyCard(
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
                const SizedBox(height: 120)
              ],
            ),
            panel: Column(
              children: [
                GestureDetector(
                  onTap: () => _panelController.isPanelClosed
                      ? _panelController.open()
                      : _panelController.close(),
                  child: Container(
                    height: 40,
                    color: Colors.white,
                    child: Center(
                      child: Text(
                        'Filtros',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: Status.values
                        .map(
                          (status) => CheckboxListTile(
                            value: ordersManager.statusFilter.contains(status),
                            dense: true,
                            activeColor: Theme.of(context).primaryColor,
                            title: Text(Order.getStatusText(status)),
                            onChanged: (value) {
                              ordersManager.setStatusFilter(
                                status: status,
                                enabled: value!,
                              );
                            },
                          ),
                        )
                        .toList(),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
