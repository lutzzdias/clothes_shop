import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/address/components/cep_input_field.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Endereço de Entrega',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              CepInputField(),
            ],
          ),
        ),
      ),
    );
  }
}
