import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_icon_button.dart';
import 'package:loja_virtual/models/item_size.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/screens/edit_product/components/edit_item_size.dart';

class SizesForm extends StatelessWidget {
  final Product product;
  const SizesForm({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormField<List<ItemSize>>(
      initialValue: product.sizes,
      validator: (sizes) {
        if (sizes == null || sizes.isEmpty)
          return 'Insira um tamanho';
        else
          return null;
      },
      builder: (state) {
        return Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Tamanhos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                CustomIconButton(
                  icon: Icons.add,
                  color: Colors.black,
                  onTap: () {
                    state.value?.add(ItemSize.empty());
                    state.didChange(state.value);
                  },
                ),
              ],
            ),
            Column(
              children: state.value?.map<Widget>((size) {
                    return EditItemSize(
                      key: ObjectKey(size),
                      size: size,
                      onRemove: () {
                        state.value?.remove(size);
                        state.didChange(state.value);
                      },
                      onMoveUp: size != state.value?.first
                          ? () {
                              final index = state.value!.indexOf(size);
                              state.value?.remove(size);
                              state.value?.insert(index - 1, size);
                              state.didChange(state.value);
                            }
                          : null,
                      onMoveDown: size != state.value?.last
                          ? () {
                              final index = state.value!.indexOf(size);
                              state.value?.remove(size);
                              state.value?.insert(index + 1, size);
                              state.didChange(state.value);
                            }
                          : null,
                    );
                  }).toList() ??
                  [],
            ),
            if (state.hasError)
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  state.errorText!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}
