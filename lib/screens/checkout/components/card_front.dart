import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/screens/checkout/components/card_text_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CardFront extends StatelessWidget {
  CardFront({Key? key}) : super(key: key);

  final dateFormatter = MaskTextInputFormatter(
    mask: '!#/####',
    filter: {
      '#': RegExp(r'[0-9]'),
      '!': RegExp(r'[0-1]'),
    },
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 16,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        height: 200,
        color: const Color(0xff1B4B52),
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CardTextField(
                    title: 'Número',
                    hint: '0000 0000 0000 0000',
                    textInputType: TextInputType.number,
                    bold: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CartaoBancarioInputFormatter(),
                    ],
                    validator: (number) {
                      if (number == null || number.length != 19)
                        return 'Inválido';
                      else
                        return null;
                    },
                  ),
                  CardTextField(
                    title: 'Validade',
                    hint: '11/2027',
                    textInputType: TextInputType.number,
                    inputFormatters: [dateFormatter],
                    validator: (date) {
                      if (date == null || date.length != 7)
                        return 'Inválido';
                      else
                        return null;
                    },
                  ),
                  CardTextField(
                    title: 'Título',
                    hint: 'Thiago Lütz Dias',
                    bold: true,
                    validator: (name) {
                      if (name == null || name.isEmpty)
                        return 'Inválido';
                      else
                        return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
