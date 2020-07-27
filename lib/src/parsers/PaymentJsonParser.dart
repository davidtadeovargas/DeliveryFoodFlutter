import 'package:food_delivery_app/src/models/Payment.dart';

import 'IBaseParser.dart';


class PaymentJsonParser implements IBaseParser {

  @override
  Object fromJsonToModel(Map<String, dynamic> jsonMap) {

    Payment Payment_ = Payment();

    Payment_.id = jsonMap['id'].toString();
    Payment_.status = jsonMap['status'] ?? '';
    Payment_.method = jsonMap['method'] ?? '';

    return Payment_;
  }

  @override
  Map fromModeltoMap(Object Object) {

    //Cast the model
    Payment Payment_ = Object;

    return {
      'id': Payment_.id,
      'status': Payment_.status,
      'method': Payment_.method,
    };
  }

  @override
  String mapToString(Object Object) {
    throw UnimplementedError();
  }
}