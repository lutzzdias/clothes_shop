import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_icon_button.dart';
import 'package:loja_virtual/models/item_size.dart';

class EditItemSize extends StatelessWidget {
  final ItemSize size;
  final VoidCallback onRemove;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;

  const EditItemSize({
    Key? key,
    required this.size,
    required this.onRemove,
    required this.onMoveUp,
    required this.onMoveDown,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 30,
          child: TextFormField(
            initialValue: size.name,
            decoration: const InputDecoration(
              labelText: 'Título',
              isDense: true,
            ),
            validator: (name) {
              if (name == null || name.isEmpty)
                return 'Inválido';
              else
                return null;
            },
            onChanged: (name) => size.name = name,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          flex: 30,
          child: TextFormField(
            initialValue: size.stock.toString(),
            decoration: const InputDecoration(
              labelText: 'Estoque',
              isDense: true,
            ),
            keyboardType: TextInputType.number,
            validator: (stock) {
              if (stock == null || stock.isEmpty || int.tryParse(stock) == null)
                return 'Inválido';
              else
                return null;
            },
            onChanged: (stock) => size.stock = int.tryParse(stock) ?? 0,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          flex: 40,
          child: TextFormField(
            initialValue: size.price.toStringAsFixed(2),
            decoration: const InputDecoration(
              labelText: 'Preço',
              isDense: true,
              prefixText: 'R\$ ',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (price) {
              if (price == null || price.isEmpty || num.tryParse(price) == null)
                return 'Inválido';
              else
                return null;
            },
            onChanged: (price) => size.price = double.tryParse(price) ?? 0,
          ),
        ),
        CustomIconButton(
          icon: Icons.remove,
          color: Colors.red,
          onTap: onRemove,
        ),
        CustomIconButton(
          icon: Icons.arrow_drop_up,
          color: Colors.black,
          onTap: onMoveUp,
        ),
        CustomIconButton(
          icon: Icons.arrow_drop_down,
          color: Colors.black,
          onTap: onMoveDown,
        ),
      ],
    );
  }
}
