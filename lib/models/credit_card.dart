import 'package:credit_card_type_detector/credit_card_type_detector.dart';

class CreditCard {
  String? _number;
  String? _holder;
  String? _expirationDate;
  String? _securityCode;
  String? _brand;

  CreditCard();

  set number(String? number) {
    _number = number;
    _brand = number == null
        ? ''
        : detectCCType(number.replaceAll(' ', '')).toString();
  }

  String? get number => _number;

  set holder(String? name) => _holder = name;
  String? get holder => _holder;

  set expirationDate(String? date) => _expirationDate = date;
  String? get expirationDate => _expirationDate;

  set securityCode(String? securityCode) => _securityCode = securityCode;
  String? get securityCode => _securityCode;

  String? get brand => _brand;

  Map<String, dynamic> toMap() => {
        'cardNumber': _number?.replaceAll(' ', ''),
        'holder': _holder,
        'expirationDate': _expirationDate,
        'securityCode': _securityCode,
        'brand': _brand,
      };

  @override
  String toString() {
    return 'CreditCard{_number: $_number, _holder: $_holder, _expirationDate: $_expirationDate, _securityCode: $_securityCode, brand: $_brand}';
  }
}
