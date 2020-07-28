import 'package:food_delivery_app/src/helpers/custom_trace.dart';
import 'package:food_delivery_app/src/models/Cart.dart';
import 'package:food_delivery_app/src/models/Extra.dart';

import 'ExtraJsonParser.dart';
import 'FoodJsonParser.dart';
import 'IBaseParser.dart';


class CartJsonParser implements IBaseParser {

  @override
  Object fromJsonToModel(Map<String, dynamic> jsonMap) {

    FoodJsonParser FoodJsonParser_ = new FoodJsonParser();
    ExtraJsonParser ExtraJsonParser_ = new ExtraJsonParser();

    Cart Cart_ = new Cart();

    try{

      Cart_.id = jsonMap['id'].toString();
      Cart_.quantity = jsonMap['quantity'] != null ? jsonMap['quantity'].toDouble() : 0.0;
      Cart_.food = jsonMap['food'] != null ? FoodJsonParser_.fromJsonToModel(jsonMap['food']) : FoodJsonParser_.fromJsonToModel({});
      Cart_.extras = jsonMap['extras'] != null ? List.from(jsonMap['extras']).map((element) => ExtraJsonParser_.fromJsonToModel(element) as Extra).toList() : [];

    }catch(e){

      print(CustomTrace(StackTrace.current, message: e));

      FoodJsonParser FoodJsonParser_ = new FoodJsonParser();

      Cart_.id = '';
      Cart_.quantity = 0.0;
      Cart_.food = FoodJsonParser_.fromJsonToModel({});
      Cart_.extras = [];
    }


    return Cart_;
  }

  @override
  Map fromModeltoMap(Object Object) {

    //Cast the model
    Cart Cart_ = Object;

    var map = new Map<String, dynamic>();

    map["id"] = Cart_.id;
    map["quantity"] = Cart_.quantity;
    map["food_id"] = Cart_.food.id;
    map["user_id"] = Cart_.userId;
    map["extras"] = Cart_.extras.map((element) => element.id).toList();

    return map;
  }

  @override
  String mapToString(Object Object) {
    throw UnimplementedError();
  }
}