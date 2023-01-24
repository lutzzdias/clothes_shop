import 'package:flutter/material.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/screens/product/components/custom_carousel.dart';

class ImagesForm extends StatelessWidget {
  final Product product;
  const ImagesForm({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormField<List<dynamic>>(
      initialValue: List.from(product.images),
      validator: (images) {
        if (images == null || images.isEmpty)
          return 'Insira ao menos uma imagem';
        else
          return null;
      },
      onSaved: (images) => product.newImages = images!,
      builder: (state) => Column(
        children: [
          CustomCarousel(
            images: state.value!,
            state: state,
          ),
          if (state.hasError)
            Container(
              margin: const EdgeInsets.only(
                top: 16,
                left: 16,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                state.errorText!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
