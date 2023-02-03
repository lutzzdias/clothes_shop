import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/checkout/components/card_back.dart';
import 'package:loja_virtual/screens/checkout/components/card_front.dart';

class CreditCardWidget extends StatelessWidget {
  final GlobalKey<FlipCardState> _cardKey = GlobalKey<FlipCardState>();
  CreditCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FlipCard(
            key: _cardKey,
            direction: FlipDirection.HORIZONTAL,
            speed: 700,
            flipOnTouch: false,
            front: CardFront(),
            back: const CardBack(),
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
    );
  }
}
