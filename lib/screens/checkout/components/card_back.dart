import 'package:flutter/material.dart';

class CardBack extends StatelessWidget {
  const CardBack({Key? key}) : super(key: key);

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
      ),
    );
  }
}
