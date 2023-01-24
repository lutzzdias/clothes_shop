import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/section.dart';
import 'package:loja_virtual/models/section_item.dart';
import 'package:loja_virtual/screens/edit_product/components/image_source_sheet.dart';
import 'package:provider/provider.dart';

class AddTileWidget extends StatelessWidget {
  const AddTileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final section = context.watch<Section>();

    void onImageSelected(File file) {
      section.addItem(SectionItem(image: file, product: null));
      Navigator.of(context).pop();
    }

    // TODO: Discover why the add tile does not use all the available space in the staggered list
    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onTap: () {
          if (Platform.isAndroid)
            showModalBottomSheet(
              context: context,
              builder: (_) => ImageSourceSheet(
                onImageSelected: onImageSelected,
              ),
            );
          else
            showCupertinoModalPopup(
              context: context,
              builder: (_) => ImageSourceSheet(
                onImageSelected: onImageSelected,
              ),
            );
        },
        child: Container(
          color: Colors.white.withAlpha(30),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
