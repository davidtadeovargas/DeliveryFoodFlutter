import 'package:food_delivery_app/src/models/OrderStatus.dart';

import 'IBaseParser.dart';


class OrderStatusJsonParser implements IBaseParser {

  @override
  Object fromJsonToModel(Map<String, dynamic> jsonMap) {

    OrderStatus OrderStatus_ = new OrderStatus();

    OrderStatus_.id = jsonMap['id'].toString();
    OrderStatus_.status = jsonMap['status'] != null ? jsonMap['status'] : '';

    return OrderStatus_;
  }

  @override
  Map fromModeltoMap(Object Object) {

    var map = new Map<String, dynamic>();
    return map;
  }

  @override
  String mapToString(Object Object) {
    throw UnimplementedError();
  }
}