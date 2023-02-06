import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/models/credit_card.dart';
import 'package:loja_virtual/screens/checkout/components/card_text_field.dart';

class CardBack extends StatelessWidget {
  final FocusNode cvvFocus;
  final CreditCard creditCard;
  const CardBack({
    Key? key,
    required this.cvvFocus,
    required this.creditCard,
  }) : super(key: key);

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
        child: Column(
          children: [
            Container(
              color: Colors.black,
              height: 40,
              margin: const EdgeInsets.symmetric(vertical: 16),
            ),
            Row(
              children: [
                Expanded(
                  flex: 70,
                  child: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.grey[500],
                    margin: const EdgeInsets.only(left: 12),
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: CardTextField(
                      hint: '123',
                      maxLength: 3,
                      textAlign: TextAlign.end,
                      textInputType: TextInputType.number,
                      initialValue: creditCard.securityCode ?? '',
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      focusNode: cvvFocus,
                      validator: (cvv) {
                        if (cvv == null || cvv.length != 3)
                          return 'Inválido';
                        else
                          return null;
                      },
                      onSaved: (securityCode) =>
                          creditCard.securityCode = securityCode!,
                    ),
                  ),
                ),
                const Expanded(
                  flex: 30,
                  child: SizedBox(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
