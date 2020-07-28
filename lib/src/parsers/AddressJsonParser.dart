import 'package:food_delivery_app/src/helpers/custom_trace.dart';
import 'package:food_delivery_app/src/models/Address.dart';

import 'IBaseParser.dart';


class AddressJsonParser implements IBaseParser {

  @override
  Object fromJsonToModel(Map<String, dynamic> jsonMap) {

    Address Address_ = new Address();

    try{

      Address_.id = jsonMap['id'].toString();
      Address_.description = jsonMap['description'] != null ? jsonMap['description'].toString() : null;
      Address_.address = jsonMap['address'] != null ? jsonMap['address'] : null;
      Address_.latitude = jsonMap['latitude'] != null ? jsonMap['latitude'].toDouble() : null;
      Address_.longitude = jsonMap['longitude'] != null ? jsonMap['longitude'].toDouble() : null;
      Address_.isDefault = jsonMap['is_default'] ?? false;

    }catch(e){
      print(CustomTrace(StackTrace.current, message: e));
    }

    return Address_;
  }

  @override
  Map fromModeltoMap(Object Object) {

    //Cast the model
    Address Address_ = Object;

    var map = new Map<String, dynamic>();

    map["id"] = Address_.id;
    map["description"] = Address_.description;
    map["address"] = Address_.address;
    map["latitude"] = Address_.latitude;
    map["longitude"] = Address_.longitude;
    map["is_default"] = Address_.isDefault;
    map["user_id"] = Address_.userId;

    return map;
  }

  @override
  String mapToString(Object Object) {
    throw UnimplementedError();
  }
}