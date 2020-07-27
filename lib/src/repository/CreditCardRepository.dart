import 'package:food_delivery_app/src/models/CreditCard.dart';

class CreditCardRepository{

  bool validated(CreditCard CreditCard_) {
    return CreditCard_.number != null && CreditCard_.number != '' && CreditCard_.expMonth != null && CreditCard_.expMonth != '' && CreditCard_.expYear != null && CreditCard_.expYear != '' && CreditCard_.cvc != null && CreditCard_.cvc != '';
  }
}