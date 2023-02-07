import 'package:flutter/material.dart';
import 'package:loja_virtual/models/order.dart';

class CancelOrderDialog extends StatefulWidget {
  final Order order;
  const CancelOrderDialog({Key? key, required this.order}) : super(key: key);

  @override
  State<CancelOrderDialog> createState() => _CancelOrderDialogState();
}

class _CancelOrderDialogState extends State<CancelOrderDialog> {
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: AlertDialog(
        title: Text('Cancelar pedido ${widget.order.formattedId}?'),
        content: _loading
            ? const Text('Cancelando...')
            : const Text('Esta ação não poderá ser desfeita!'),
        actions: [
          TextButton(
            onPressed: _loading
                ? null
                : () {
                    Navigator.of(context).pop();
                  },
            child: const Text('Voltar'),
          ),
          TextButton(
            onPressed: _loading
                ? null
                : () async {
                    setState(() {
                      _loading = true;
                    });
                    await widget.order.cancel();
                    Navigator.of(context).pop();
                  },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Cancelar Pedido'),
          )
        ],
      ),
    );
  }
}
