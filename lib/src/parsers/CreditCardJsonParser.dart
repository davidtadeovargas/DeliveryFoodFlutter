import 'package:food_delivery_app/src/models/CreditCard.dart';

import 'IBaseParser.dart';


class CreditCardJsonParser implements IBaseParser {

  @override
  Object fromJsonToModel(Map<String, dynamic> jsonMap) {

    CreditCard CreditCard_ = CreditCard();

    CreditCard_.id = jsonMap['id'].toString();
    CreditCard_.number = jsonMap['stripe_number'].toString();
    CreditCard_.expMonth = jsonMap['stripe_exp_month'].toString();
    CreditCard_.expYear = jsonMap['stripe_exp_year'].toString();
    CreditCard_.cvc = jsonMap['stripe_cvc'].toString();

    return CreditCard_;
  }

  @override
  Map fromModeltoMap(Object Object) {

    //Cast the model
    CreditCard CreditCard_ = Object;

    var map = new Map<String, dynamic>();

    map["id"] = CreditCard_.id;
    map["stripe_number"] = CreditCard_.number;
    map["stripe_exp_month"] = CreditCard_.expMonth;
    map["stripe_exp_year"] = CreditCard_.expYear;
    map["stripe_cvc"] = CreditCard_.cvc;

    return map;
  }

  @override
  String mapToString(Object Object) {
    throw UnimplementedError();
  }
}