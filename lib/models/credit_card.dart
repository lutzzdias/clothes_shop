import 'package:credit_card_type_detector/credit_card_type_detector.dart';

class CreditCard {
  String? _number;
  String? holder;
  String? expirationDate;
  String? securityCode;
  String? _brand;

  CreditCard();

  set number(String? number) {
    _number = number;
    _brand = number == null
        ? ''
        : detectCCType(number.replaceAll(' ', '')).toString();
  }

  String? get number => _number;

  String? get brand => _brand;

  Map<String, dynamic> toMap() => {
        'cardNumber': _number?.replaceAll(' ', ''),
        'holder': holder,
        'expirationDate': expirationDate,
        'securityCode': securityCode,
        'brand': _brand,
      };

  @override
  String toString() {
    return 'CreditCard{_number: $_number, _holder: $holder, _expirationDate: $expirationDate, _securityCode: $securityCode, brand: $_brand}';
  }
}
