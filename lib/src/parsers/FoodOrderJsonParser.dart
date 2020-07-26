import 'package:food_delivery_app/src/models/FoodOrder.dart';

import '../models/FoodOrder.dart';
import 'ExtraJsonParser.dart';
import 'FoodJsonParser.dart';
import 'IBaseParser.dart';


class FoodOrderJsonParser implements IBaseParser {

  @override
  Object fromJsonToModel(Map<String, dynamic> jsonMap) {

    FoodJsonParser FoodJsonParser_ = new FoodJsonParser();
    ExtraJsonParser ExtraJsonParser_ = new ExtraJsonParser();

    FoodOrder FoodOrder_ = new FoodOrder();

    FoodOrder_.id = jsonMap['id'].toString();
    FoodOrder_.price = jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0.0;
    FoodOrder_.quantity = jsonMap['quantity'] != null ? jsonMap['quantity'].toDouble() : 0.0;
    FoodOrder_.food = jsonMap['food'] != null ? FoodJsonParser_.fromJsonToModel(jsonMap['food']) : FoodJsonParser_.fromJsonToModel({});
    FoodOrder_.dateTime = DateTime.parse(jsonMap['updated_at']);
    FoodOrder_.extras = jsonMap['extras'] != null ? List.from(jsonMap['extras']).map((element) => ExtraJsonParser_.fromJsonToModel(element)).toList() : [];

    return FoodOrder_;
  }

  @override
  Map fromModeltoMap(Object Object) {

    //Cast the model
    FoodOrder FoodOrder_ = Object;

    var map = new Map<String, dynamic>();

    map["id"] = FoodOrder_.id;
    map["price"] = FoodOrder_.price;
    map["quantity"] = FoodOrder_.quantity;
    map["food_id"] = FoodOrder_.food.id;
    map["extras"] = FoodOrder_.extras.map((element) => element.id).toList();

    return map;
  }

  @override
  String mapToString(Object Object) {
    throw UnimplementedError();
  }
}