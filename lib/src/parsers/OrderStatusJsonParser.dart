import 'package:food_delivery_app/src/helpers/custom_trace.dart';
import 'package:food_delivery_app/src/models/OrderStatus.dart';

import 'IBaseParser.dart';


class OrderStatusJsonParser implements IBaseParser {

  @override
  Object fromJsonToModel(Map<String, dynamic> jsonMap) {

    OrderStatus OrderStatus_ = new OrderStatus();

    try{

      OrderStatus_.id = jsonMap['id'].toString();
      OrderStatus_.status = jsonMap['status'] != null ? jsonMap['status'] : '';

    }catch(e){
      print(CustomTrace(StackTrace.current, message: e));
    }

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