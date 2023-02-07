import 'package:flutter/material.dart';
import 'package:loja_virtual/common/order/cancel_order_dialog.dart';
import 'package:loja_virtual/common/order/export_address_dialog.dart';
import 'package:loja_virtual/common/order/order_product_tile.dart';
import 'package:loja_virtual/models/order.dart';

class OrderTile extends StatelessWidget {
  final Order order;
  final bool showControls;
  const OrderTile({
    Key? key,
    required this.order,
    this.showControls = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.formattedId,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  'R\$ ${order.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Text(
              order.statusText,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: order.status == Status.canceled
                    ? Colors.red
                    : Theme.of(context).primaryColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
        children: [
          Column(
            children: order.items
                .map((item) => OrderProductTile(cartProduct: item))
                .toList(),
          ),
          if (showControls && order.status != Status.canceled)
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  TextButton(
                    onPressed: () => showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (_) => CancelOrderDialog(
                        order: order,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: order.back,
                    child: const Text('Recuar'),
                  ),
                  TextButton(
                    onPressed: order.advance,
                    child: const Text('Avançar'),
                  ),
                  TextButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => ExportAddressDialog(
                        address: order.address,
                      ),
                    ),
                    style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor),
                    child: const Text('Endereço'),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
