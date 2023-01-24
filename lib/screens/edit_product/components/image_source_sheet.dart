import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  final Function(File) onImageSelected;
  final ImagePicker picker = ImagePicker();
  ImageSourceSheet({
    Key? key,
    required this.onImageSelected,
  }) : super(key: key);

  Future<void> editImage(Color color, String path) async {
    ImageCropper cropper = ImageCropper();
    final CroppedFile? croppedFile = await cropper.cropImage(
      sourcePath: path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Editar Imagem',
          toolbarColor: color,
          toolbarWidgetColor: Colors.white,
        ),
        IOSUiSettings(
          title: 'Editar Imagem',
          cancelButtonTitle: 'Cancelar',
          doneButtonTitle: 'Concluir',
        )
      ],
    );

    if (croppedFile != null) onImageSelected(File(croppedFile.path));
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    if (Platform.isAndroid)
      return BottomSheet(
        onClosing: () {},
        builder: (_) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton(
              onPressed: () async {
                final XFile? file =
                    await picker.pickImage(source: ImageSource.camera);
                editImage(primaryColor, file?.path ?? '');
              },
              child: const Text('Câmera'),
            ),
            TextButton(
              onPressed: () async {
                final XFile? file =
                    await picker.pickImage(source: ImageSource.gallery);
                await editImage(primaryColor, file?.path ?? '');
              },
              child: const Text('Galeria'),
            ),
          ],
        ),
      );
    else
      return CupertinoActionSheet(
        title: const Text('Selecionar foto pata o item'),
        message: const Text('Escolha a origem da foto'),
        cancelButton: CupertinoActionSheetAction(
          onPressed: Navigator.of(context).pop,
          child: const Text('Cancelar'),
        ),
        actions: [
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () async {
              final XFile? file =
                  await picker.pickImage(source: ImageSource.camera);
              editImage(primaryColor, file?.path ?? '');
            },
            child: const Text('Câmera'),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              final XFile? file =
                  await picker.pickImage(source: ImageSource.gallery);
              editImage(primaryColor, file?.path ?? '');
            },
            child: const Text('Galeria'),
          ),
        ],
      );
  }
}
