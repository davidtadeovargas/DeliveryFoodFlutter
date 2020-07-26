import 'package:food_delivery_app/src/models/Cuisine.dart';
import 'package:food_delivery_app/src/models/Media.dart';

import 'IBaseParser.dart';
import 'MediaJsonParser.dart';


class CuisineJsonParser implements IBaseParser {

  @override
  Object fromJsonToModel(Map<String, dynamic> jsonMap) {

    MediaJsonParser MediaJsonParser_ = new MediaJsonParser();

    Cuisine Cuisine_ = new Cuisine();

    Cuisine_.id = jsonMap['id'].toString();
    Cuisine_.name = jsonMap['name'];
    Cuisine_.description = jsonMap['description'];
    Cuisine_.image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0 ? MediaJsonParser_.fromJsonToModel(jsonMap['media'][0]) : new Media();
    Cuisine_.selected = jsonMap['selected'] ?? false;

    return Cuisine_;
  }

  @override
  Map fromModeltoMap(Object Object) {

    //Cast the model
    Cuisine Cuisine__ = Object;

    var map = new Map<String, dynamic>();

    map['id'] = Cuisine__.id;

    return map;
  }

  @override
  String mapToString(Object Object) {
    throw UnimplementedError();
  }
}