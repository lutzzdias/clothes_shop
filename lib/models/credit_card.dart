import 'package:credit_card_type_detector/credit_card_type_detector.dart';

class CreditCard {
  late String _number;
  late String _holder;
  late String _expirationDate;
  late String _securityCode;
  late String brand;

  CreditCard();

  set number(String number) {
    _number = number;
    brand = detectCCType(number.replaceAll(' ', '')).toString();
  }

  set holder(String name) => _holder = name;
  set expirationDate(String date) => _expirationDate = date;
  set securityCode(String securityCode) => _securityCode = securityCode;

  @override
  String toString() {
    return 'CreditCard{_number: $_number, _holder: $_holder, _expirationDate: $_expirationDate, _securityCode: $_securityCode, brand: $brand}';
  }
}
