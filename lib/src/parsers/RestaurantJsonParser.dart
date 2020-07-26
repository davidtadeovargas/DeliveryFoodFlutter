import 'package:food_delivery_app/src/models/Media.dart';
import 'package:food_delivery_app/src/models/Restaurant.dart';

import 'IBaseParser.dart';
import 'MediaJsonParser.dart';


class RestaurantJsonParser implements IBaseParser {

  @override
  Object fromJsonToModel(Map<String, dynamic> jsonMap) {

    Restaurant Restaurant_ = new Restaurant();
    MediaJsonParser MediaJsonParser_ = new MediaJsonParser();

    Restaurant_.id = jsonMap['id'].toString();
    Restaurant_.name = jsonMap['name'];
    Restaurant_.image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0 ? MediaJsonParser_.fromJsonToModel(jsonMap['media'][0]) : new Media();
    Restaurant_.rate = jsonMap['rate'] ?? '0';
    Restaurant_.deliveryFee = jsonMap['delivery_fee'] != null ? jsonMap['delivery_fee'].toDouble() : 0.0;
    Restaurant_.adminCommission = jsonMap['admin_commission'] != null ? jsonMap['admin_commission'].toDouble() : 0.0;
    Restaurant_.deliveryRange = jsonMap['delivery_range'] != null ? jsonMap['delivery_range'].toDouble() : 0.0;
    Restaurant_.address = jsonMap['address'];
    Restaurant_.description = jsonMap['description'];
    Restaurant_.phone = jsonMap['phone'];
    Restaurant_.mobile = jsonMap['mobile'];
    Restaurant_.defaultTax = jsonMap['default_tax'] != null ? jsonMap['default_tax'].toDouble() : 0.0;
    Restaurant_.information = jsonMap['information'];
    Restaurant_.latitude = jsonMap['latitude'];
    Restaurant_.longitude = jsonMap['longitude'];
    Restaurant_.closed = jsonMap['closed'] ?? false;
    Restaurant_.availableForDelivery = jsonMap['available_for_delivery'] ?? false;
    Restaurant_.distance = jsonMap['distance'] != null ? double.parse(jsonMap['distance'].toString()) : 0.0;

    return Restaurant_;
  }

  @override
  Map fromModeltoMap(Object Object) {

    //Cast the model
    Restaurant Restaurant_ = Object;

    return {
      'id': Restaurant_.id,
      'name': Restaurant_.name,
      'latitude': Restaurant_.latitude,
      'longitude': Restaurant_.longitude,
      'delivery_fee': Restaurant_.deliveryFee,
      'distance': Restaurant_.distance,
    };
  }

  @override
  String mapToString(Object Object) {
    throw UnimplementedError();
  }
}