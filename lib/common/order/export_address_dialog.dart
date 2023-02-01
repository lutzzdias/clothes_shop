import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:screenshot/screenshot.dart';

class ExportAddressDialog extends StatelessWidget {
  final Address address;
  final ScreenshotController _screenshotController = ScreenshotController();
  ExportAddressDialog({Key? key, required this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      title: const Text('Endereço de Entrega'),
      content: Screenshot(
        controller: _screenshotController,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(8),
          child: Text(
            '${address.street}, ${address.number} ${address.complement}\n'
            '${address.district}\n'
            '${address.city}/${address.state}\n'
            '${address.zipCode}',
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            final imgAsBytes = await _screenshotController.capture();
            await ImageGallerySaver.saveImage(imgAsBytes!);
          },
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor,
          ),
          child: const Text('Exportar'),
        ),
      ],
    );
  }
}
