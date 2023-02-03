import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardTextField extends StatelessWidget {
  final String title;
  final bool bold;
  final String hint;
  final TextInputType textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String> validator;
  const CardTextField({
    Key? key,
    required this.title,
    this.bold = false,
    required this.hint,
    this.textInputType = TextInputType.text,
    this.inputFormatters,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: validator,
      builder: (state) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                if (state.hasError)
                  const Text(
                    '    Inválido',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 9,
                    ),
                  )
              ],
            ),
            TextFormField(
              style: TextStyle(
                color: Colors.white,
                fontWeight: bold ? FontWeight.bold : FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: Colors.white.withAlpha(100),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 2),
              ),
              keyboardType: textInputType,
              inputFormatters: inputFormatters,
              onChanged: (text) => state.didChange(text),
            ),
          ],
        ),
      ),
    );
  }
}
