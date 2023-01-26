import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:provider/provider.dart';

class AddressInputField extends StatelessWidget {
  final Address address;
  const AddressInputField({Key? key, required this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<CartManager>();
    String? emptyValidator(String? text) =>
        text == null || text.isEmpty ? 'Campo obrigatório' : null;

    if (address.zipCode.isNotEmpty && cartManager.deliveryPrice == null)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            enabled: !cartManager.loading,
            initialValue: address.street,
            decoration: const InputDecoration(
              isDense: true,
              labelText: 'Rua/Avenida',
              hintText: 'Av. Brasil',
            ),
            validator: emptyValidator,
            onSaved: (text) => address.street = text!,
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  enabled: !cartManager.loading,
                  initialValue: address.number,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Número',
                    hintText: '123',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  validator: emptyValidator,
                  onSaved: (number) => address.number = number!,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  enabled: !cartManager.loading,
                  initialValue: address.complement,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Complemento',
                    hintText: 'Opcional',
                  ),
                  onSaved: (text) => address.complement = text,
                ),
              ),
            ],
          ),
          TextFormField(
            enabled: !cartManager.loading,
            initialValue: address.district,
            decoration: const InputDecoration(
              isDense: true,
              labelText: 'Bairro',
              hintText: 'Guanabara',
            ),
            validator: emptyValidator,
            onSaved: (text) => address.district = text!,
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  enabled: false,
                  initialValue: address.city,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Cidade',
                    hintText: 'Campinas',
                  ),
                  validator: emptyValidator,
                  onSaved: (text) => address.city = text!,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  autocorrect: false,
                  enabled: false,
                  textCapitalization: TextCapitalization.characters,
                  initialValue: address.state,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'UF',
                    hintText: 'SP',
                    counterText: '',
                  ),
                  maxLength: 2,
                  validator: (text) {
                    if (text == null || text.isEmpty)
                      return 'Campo obrigatório';
                    else if (text.length != 2)
                      return 'Inválido';
                    else
                      return null;
                  },
                  onSaved: (text) => address.state = text!,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (cartManager.loading)
            LinearProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation(Theme.of(context).primaryColor),
              backgroundColor: Colors.transparent,
            ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              disabledBackgroundColor:
                  Theme.of(context).primaryColor.withAlpha(100),
            ),
            onPressed: !cartManager.loading
                ? () async {
                    if (Form.of(context).validate()) {
                      Form.of(context).save();
                      try {
                        await context.read<CartManager>().setAddress(address);
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
            child: const Text('Calcular Frete'),
          )
        ],
      );
    else if (address.zipCode.isNotEmpty)
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(
          '${address.street}, ${address.number}\n'
          '${address.district}\n'
          '${address.city} - ${address.state}',
          style: const TextStyle(),
        ),
      );
    else
      return Container();
  }
}
