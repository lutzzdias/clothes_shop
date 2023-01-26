import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/common/custom_icon_button.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:provider/provider.dart';

class CepInputField extends StatelessWidget {
  final Address address;

  const CepInputField({
    Key? key,
    required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<CartManager>();
    String cep = address.zipCode;
    return address.zipCode.isEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                enabled: !cartManager.loading,
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
              if (cartManager.loading)
                LinearProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                  backgroundColor: Colors.transparent,
                ),
              ElevatedButton(
                onPressed: !cartManager.loading
                    ? () async {
                        if (Form.of(context).validate()) {
                          try {
                            await context.read<CartManager>().getAddress(cep);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  disabledBackgroundColor:
                      Theme.of(context).primaryColor.withAlpha(100),
                ),
                child: const Text('Buscar CEP'),
              )
            ],
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'CEP: ${address.zipCode}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                CustomIconButton(
                  icon: Icons.edit,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                  onTap: () => context.read<CartManager>().removeAddress(),
                )
              ],
            ),
          );
  }
}
