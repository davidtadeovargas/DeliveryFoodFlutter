import 'package:food_delivery_app/src/helpers/custom_trace.dart';
import 'package:food_delivery_app/src/models/Nutrition.dart';

import 'IBaseParser.dart';


class NutritionJsonParser implements IBaseParser {

  @override
  Object fromJsonToModel(Map<String, dynamic> jsonMap) {

    Nutrition Nutrition_ = new Nutrition();

    try{

      Nutrition_.id = jsonMap['id'].toString();
      Nutrition_.name = jsonMap['name'];
      Nutrition_.quantity = jsonMap['quantity'].toDouble();

    }catch(e){
      print(CustomTrace(StackTrace.current, message: e));
    }

    return Nutrition_;
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