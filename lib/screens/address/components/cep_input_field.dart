import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:provider/provider.dart';

class CepInputField extends StatelessWidget {
  const CepInputField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String cep = '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          decoration: const InputDecoration(
            isDense: true,
            labelText: 'CEP',
            hintText: 'XX.XXX-XXX',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            CepInputFormatter(),
          ],
          validator: (cep) {
            if (cep == null || cep.isEmpty)
              return 'Campo obrigatório';
            else if (cep.length != 10)
              return 'CEP Inválido';
            else
              return null;
          },
          onChanged: (text) => cep = text,
        ),
        ElevatedButton(
          onPressed: () {
            if (Form.of(context)?.validate() ?? false) {
              context.read<CartManager>().getAddress(cep);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            disabledBackgroundColor:
                Theme.of(context).primaryColor.withAlpha(100),
          ),
          child: const Text('Buscar CEP'),
        )
      ],
    );
  }
}
