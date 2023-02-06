import 'package:brasil_fields/brasil_fields.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/models/credit_card.dart';
import 'package:loja_virtual/screens/checkout/components/card_text_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CardFront extends StatelessWidget {
  final FocusNode numberFocus;
  final FocusNode dateFocus;
  final FocusNode nameFocus;
  final VoidCallback finished;
  final CreditCard creditCard;

  CardFront({
    Key? key,
    required this.numberFocus,
    required this.dateFocus,
    required this.nameFocus,
    required this.finished,
    required this.creditCard,
  }) : super(key: key);

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
                    initialValue: creditCard.number ?? '',
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CartaoBancarioInputFormatter(),
                    ],
                    focusNode: numberFocus,
                    validator: (number) {
                      if (number == null ||
                          number.length != 19 ||
                          detectCCType(number) == CreditCardType.unknown)
                        return 'Inválido';
                      else
                        return null;
                    },
                    onSubmitted: (_) => dateFocus.requestFocus(),
                    onSaved: (number) => creditCard.number = number!,
                  ),
                  CardTextField(
                    title: 'Validade',
                    hint: '11/2027',
                    textInputType: TextInputType.number,
                    inputFormatters: [dateFormatter],
                    focusNode: dateFocus,
                    initialValue: creditCard.expirationDate ?? '',
                    validator: (date) {
                      if (date == null || date.length != 7)
                        return 'Inválido';
                      else
                        return null;
                    },
                    onSubmitted: (_) => nameFocus.requestFocus(),
                    onSaved: (date) => creditCard.expirationDate = date!,
                  ),
                  CardTextField(
                    title: 'Título',
                    hint: 'Thiago Lütz Dias',
                    bold: true,
                    focusNode: nameFocus,
                    initialValue: creditCard.holder ?? '',
                    validator: (name) {
                      if (name == null || name.isEmpty)
                        return 'Inválido';
                      else
                        return null;
                    },
                    onSubmitted: (_) => finished(),
                    onSaved: (holder) => creditCard.holder = holder!,
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
