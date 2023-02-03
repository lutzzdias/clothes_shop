import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:loja_virtual/screens/checkout/components/card_back.dart';
import 'package:loja_virtual/screens/checkout/components/card_front.dart';

class CreditCardWidget extends StatefulWidget {
  const CreditCardWidget({Key? key}) : super(key: key);

  @override
  State<CreditCardWidget> createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget> {
  final GlobalKey<FlipCardState> _cardKey = GlobalKey<FlipCardState>();

  final FocusNode numberFocus = FocusNode();

  final FocusNode dateFocus = FocusNode();

  final FocusNode nameFocus = FocusNode();

  final FocusNode cvvFocus = FocusNode();

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
      keyboardBarColor: Colors.grey[200],
      actions: [
        KeyboardActionsItem(focusNode: numberFocus, displayDoneButton: false),
        KeyboardActionsItem(focusNode: dateFocus, displayDoneButton: false),
        KeyboardActionsItem(
          focusNode: nameFocus,
          toolbarButtons: [
            (_) => GestureDetector(
                  onTap: () {
                    _cardKey.currentState!.toggleCard();
                    cvvFocus.requestFocus();
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Text('Continuar'),
                  ),
                )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardActions(
      config: _buildConfig(context),
      autoScroll: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FlipCard(
              key: _cardKey,
              direction: FlipDirection.HORIZONTAL,
              speed: 700,
              flipOnTouch: false,
              front: CardFront(
                numberFocus: numberFocus,
                dateFocus: dateFocus,
                nameFocus: nameFocus,
                finished: () {
                  _cardKey.currentState!.toggleCard();
                  cvvFocus.requestFocus();
                },
              ),
              back: CardBack(
                cvvFocus: cvvFocus,
              ),
            ),
            TextButton(
              onPressed: () => _cardKey.currentState!.toggleCard(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              child: const Text('Virar cartão'),
            )
          ],
        ),
      ),
    );
  }
}
