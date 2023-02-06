import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardTextField extends StatelessWidget {
  final String? title;
  final bool bold;
  final String hint;
  final TextInputType textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String> validator;
  final int? maxLength;
  final TextAlign textAlign;
  final FocusNode focusNode;
  final Function(String)? onSubmitted;
  final TextInputAction textInputAction;
  final Function(String?)? onSaved;
  final String initialValue;

  const CardTextField({
    Key? key,
    this.title,
    this.bold = false,
    required this.hint,
    this.textInputType = TextInputType.text,
    this.inputFormatters,
    required this.validator,
    this.maxLength,
    this.textAlign = TextAlign.start,
    required this.focusNode,
    this.onSubmitted,
    required this.onSaved,
    required this.initialValue,
  })  : textInputAction =
            onSubmitted == null ? TextInputAction.done : TextInputAction.next,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: initialValue,
      validator: validator,
      builder: (state) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null)
              Row(
                children: [
                  Text(
                    title!,
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
              initialValue: initialValue,
              style: TextStyle(
                color:
                    title == null && state.hasError ? Colors.red : Colors.white,
                fontWeight: bold ? FontWeight.bold : FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: title == null && state.hasError
                      ? Colors.red.withAlpha(200)
                      : Colors.white.withAlpha(100),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 2),
                counterText: '',
              ),
              cursorColor: Colors.white,
              maxLength: maxLength,
              keyboardType: textInputType,
              textAlign: textAlign,
              inputFormatters: inputFormatters,
              focusNode: focusNode,
              onFieldSubmitted: onSubmitted,
              onChanged: (text) => state.didChange(text),
              onSaved: onSaved,
            ),
          ],
        ),
      ),
    );
  }
}
