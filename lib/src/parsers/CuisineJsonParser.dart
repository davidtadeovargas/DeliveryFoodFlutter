import 'package:food_delivery_app/src/helpers/custom_trace.dart';
import 'package:food_delivery_app/src/models/Cuisine.dart';
import 'package:food_delivery_app/src/models/Media.dart';

import 'IBaseParser.dart';
import 'MediaJsonParser.dart';


class CuisineJsonParser implements IBaseParser {

  @override
  Object fromJsonToModel(Map<String, dynamic> jsonMap) {

    MediaJsonParser MediaJsonParser_ = new MediaJsonParser();

    Cuisine Cuisine_ = new Cuisine();

    try{

      Cuisine_.id = jsonMap['id'].toString();
      Cuisine_.name = jsonMap['name'];
      Cuisine_.description = jsonMap['description'];
      Cuisine_.image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0 ? MediaJsonParser_.fromJsonToModel(jsonMap['media'][0]) : new Media();
      Cuisine_.selected = jsonMap['selected'] ?? false;

    }catch(e){

      print(CustomTrace(StackTrace.current, message: e));

      Cuisine_.id = '';
      Cuisine_.name = '';
      Cuisine_.description = '';
      Cuisine_.image = new Media();
      Cuisine_.selected = false;
    }

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