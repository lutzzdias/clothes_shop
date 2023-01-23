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

  void editImage(String path) {
    ImageCropper cropper = ImageCropper();
    cropper.cropImage(
      sourcePath: path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                editImage(file?.path ?? '');
              },
              child: const Text('Câmera'),
            ),
            TextButton(
              onPressed: () async {
                final XFile? file =
                    await picker.pickImage(source: ImageSource.gallery);
                editImage(file?.path ?? '');
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
              editImage(file?.path ?? '');
            },
            child: const Text('Câmera'),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              final XFile? file =
                  await picker.pickImage(source: ImageSource.gallery);
              editImage(file?.path ?? '');
            },
            child: const Text('Galeria'),
          ),
        ],
      );
  }
}
