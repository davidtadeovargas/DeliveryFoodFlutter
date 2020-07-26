import 'package:food_delivery_app/src/models/Extra.dart';
import 'package:food_delivery_app/src/models/Media.dart';

import 'IBaseParser.dart';
import 'MediaJsonParser.dart';


class ExtraJsonParser implements IBaseParser {

  @override
  Object fromJsonToModel(Map<String, dynamic> jsonMap) {

    MediaJsonParser MediaJsonParser_ = new MediaJsonParser();

    Extra Extra_ = new Extra();

    Extra_.id = jsonMap['id'].toString();
    Extra_.extraGroupId = jsonMap['extra_group_id'] != null ? jsonMap['extra_group_id'].toString() : '0';
    Extra_.name = jsonMap['name'].toString();
    Extra_.price = jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0;
    Extra_.description = jsonMap['description'];
    Extra_.checked = false;
    Extra_.image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0 ? MediaJsonParser_.fromJsonToModel(jsonMap['media'][0]) : new Media();

    return Extra_;
  }

  @override
  Map fromModeltoMap(Object Object) {

    //Cast the model
    Extra Extra_ = Object;

    var map = new Map<String, dynamic>();

    map["id"] = Extra_.id;
    map["name"] = Extra_.name;
    map["price"] = Extra_.price;
    map["description"] = Extra_.description;

    return map;
  }

  @override
  String mapToString(Object Object) {
    throw UnimplementedError();
  }
}