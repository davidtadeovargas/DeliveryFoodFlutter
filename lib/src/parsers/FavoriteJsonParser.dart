import 'package:food_delivery_app/src/models/Favorite.dart';

import 'ExtraJsonParser.dart';
import 'FoodJsonParser.dart';
import 'IBaseParser.dart';


class FavoriteJsonParser implements IBaseParser {

  @override
  Object fromJsonToModel(Map<String, dynamic> jsonMap) {

    Favorite Favorite_ = new Favorite();
    FoodJsonParser FoodJsonParser_ = new FoodJsonParser();
    ExtraJsonParser ExtraJsonParser_ = new ExtraJsonParser();

    Favorite_.id = jsonMap['id'] != null ? jsonMap['id'].toString() : null;
    Favorite_.food = jsonMap['food'] != null ? FoodJsonParser_.fromJsonToModel(jsonMap['food']) : FoodJsonParser_.fromJsonToModel({});
    Favorite_.extras = jsonMap['extras'] != null ? List.from(jsonMap['extras']).map((element) => ExtraJsonParser_.fromJsonToModel(element)).toList() : null;

    return Favorite_;
  }

  @override
  Map fromModeltoMap(Object Object) {

    //Cast the model
    Favorite Favorite_ = Object;

    var map = new Map<String, dynamic>();

    map["id"] = Favorite_.id;
    map["food_id"] = Favorite_.food.id;
    map["user_id"] = Favorite_.userId;
    map["extras"] = Favorite_.extras.map((element) => element.id).toList();

    return map;
  }

  @override
  String mapToString(Object Object) {
    throw UnimplementedError();
  }
}