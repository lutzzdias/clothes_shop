import 'package:flutter/material.dart';
import 'package:loja_virtual/models/order.dart';

class CancelOrderDialog extends StatelessWidget {
  final Order order;
  const CancelOrderDialog({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cancelar pedido ${order.formattedId}?'),
      content: const Text('Esta ação não poderá ser desfeita!'),
      actions: [
        TextButton(
          onPressed: () {
            order.cancel();
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
          ),
          child: const Text('Cancelar Pedido'),
        )
      ],
    );
  }
}
