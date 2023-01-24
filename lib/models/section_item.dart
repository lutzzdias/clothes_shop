class SectionItem {
  dynamic image;
  String? product;

  SectionItem({
    required this.image,
    required this.product,
  });

  SectionItem.fromMap(Map<String, dynamic> map)
      : image = map['image'] as String,
        product = map['product'] as String?;

  SectionItem clone() => SectionItem(
        image: image,
        product: product,
      );

  @override
  String toString() {
    return 'SectionItem { image: $image, product: $product }';
  }
}
