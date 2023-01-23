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
      builder: (state) => CustomCarousel(
        images: state.value!,
        state: state,
      ),
    );
  }
}
