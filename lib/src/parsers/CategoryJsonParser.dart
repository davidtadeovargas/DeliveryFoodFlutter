import 'package:food_delivery_app/src/helpers/custom_trace.dart';
import 'package:food_delivery_app/src/models/Category.dart';
import 'package:food_delivery_app/src/models/Media.dart';

import 'IBaseParser.dart';
import 'MediaJsonParser.dart';


class CategoryJsonParser implements IBaseParser {

  @override
  Object fromJsonToModel(Map<String, dynamic> jsonMap) {

    Category Category_ = new Category();
    MediaJsonParser MediaJsonParser_ = new MediaJsonParser();

    try{

      Category_.id = jsonMap['id'].toString();
      Category_.name = jsonMap['name'];
      Category_.image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0 ? MediaJsonParser_.fromJsonToModel(jsonMap['media'][0]) : new Media();

    }catch(e){

      print(CustomTrace(StackTrace.current, message: e));

      Category_.id = '';
      Category_.name = '';
      Category_.image = new Media();
    }

    return Category_;
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