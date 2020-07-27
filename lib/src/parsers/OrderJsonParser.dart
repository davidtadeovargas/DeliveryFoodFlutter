import 'package:food_delivery_app/src/models/Order.dart';
import 'package:food_delivery_app/src/repository/AddressRepository.dart';
import 'package:food_delivery_app/src/repository/RepositoryManager.dart';

import 'AddressJsonParser.dart';
import 'FoodOrderJsonParser.dart';
import 'IBaseParser.dart';
import 'OrderStatusJsonParser.dart';
import 'PaymentJsonParser.dart';
import 'UserJsonParser.dart';


class OrderJsonParser implements IBaseParser {

  FoodOrderJsonParser FoodOrderJsonParser_  = FoodOrderJsonParser();
  AddressJsonParser AddressJsonParser_ = AddressJsonParser();
  OrderStatusJsonParser OrderStatusJsonParser_ = OrderStatusJsonParser();
  PaymentJsonParser PaymentJsonParser_ = PaymentJsonParser();

  @override
  Object fromJsonToModel(Map<String, dynamic> jsonMap) {

    UserJsonParser UserJsonParser_ = UserJsonParser();
    AddressJsonParser AddressJsonParser_ = AddressJsonParser();

    Order Order_ = new Order();

    Order_.id = jsonMap['id'].toString();
    Order_.tax = jsonMap['tax'] != null ? jsonMap['tax'].toDouble() : 0.0;
    Order_.deliveryFee = jsonMap['delivery_fee'] != null ? jsonMap['delivery_fee'].toDouble() : 0.0;
    Order_.hint = jsonMap['hint'] != null ? jsonMap['hint'].toString() : '';

    Order_.placesCar = jsonMap['places_car'] != null ? jsonMap['places_car'].toString() : '';
    Order_.colorCar = jsonMap['color_car'] != null ? jsonMap['color_car'].toString() : '';

    Order_.active = jsonMap['active'] ?? false;
    Order_.orderStatus = jsonMap['order_status'] != null ? OrderStatusJsonParser_.fromJsonToModel(jsonMap['order_status']) : OrderStatusJsonParser_.fromJsonToModel({});
    Order_.dateTime = DateTime.parse(jsonMap['updated_at']);
    Order_.user = jsonMap['user'] != null ? UserJsonParser_.fromJsonToModel(jsonMap['user']) : UserJsonParser_.fromJsonToModel({});
    Order_.deliveryAddress = jsonMap['delivery_address'] != null ? AddressJsonParser_.fromJsonToModel(jsonMap['delivery_address']) : AddressJsonParser_.fromJsonToModel({});
    Order_.payment = jsonMap['payment'] != null ? PaymentJsonParser_.fromJsonToModel(jsonMap['payment']) : PaymentJsonParser_.fromJsonToModel({});
    Order_.foodOrders = jsonMap['food_orders'] != null ? List.from(jsonMap['food_orders']).map((element) => FoodOrderJsonParser_.fromJsonToModel(element)).toList() : [];

    return Order_;
  }

  @override
  Map fromModeltoMap(Object Object) {

    AddressRepository AddressRepository_ = RepositoryManager.AddressRepository_;

    //Cast the model
    Order Order_ = Object;

    var map = new Map<String, dynamic>();
    map["id"] = Order_.id;
    map["user_id"] = Order_.user?.id;
    map["order_status_id"] = Order_.orderStatus?.id;
    map["tax"] = Order_.tax;
    map['hint'] = Order_.hint;
    map["delivery_fee"] = Order_.deliveryFee;
    map["places_car"] = Order_.placesCar;
    map["color_car"] = Order_.colorCar;
    map["foods"] = Order_.foodOrders.map((element) => FoodOrderJsonParser_.fromModeltoMap(element)).toList();
    map["payment"] = PaymentJsonParser_.fromModeltoMap(Order_.payment);
    if (!AddressRepository_.isUnknown(Order_.deliveryAddress)) {
      map["delivery_address_id"] = Order_.deliveryAddress?.id;
    }
    return map;
  }

  @override
  String mapToString(Object Object) {
    throw UnimplementedError();
  }
}