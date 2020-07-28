import 'package:food_delivery_app/src/helpers/custom_trace.dart';
import 'package:food_delivery_app/src/models/Extra.dart';
import 'package:food_delivery_app/src/models/ExtraGroup.dart';
import 'package:food_delivery_app/src/models/Food.dart';
import 'package:food_delivery_app/src/models/Media.dart';
import 'package:food_delivery_app/src/models/Nutrition.dart';
import 'package:food_delivery_app/src/models/Review.dart';

import 'CategoryJsonParser.dart';
import 'ExtraJGroupJsonParser.dart';
import 'ExtraJsonParser.dart';
import 'IBaseParser.dart';
import 'MediaJsonParser.dart';
import 'NutritionJsonParser.dart';
import 'ReviewJsonParser.dart';
import 'RestaurantJsonParser.dart';


class FoodJsonParser implements IBaseParser {

  @override
  Object fromJsonToModel(Map<String, dynamic> jsonMap) {

    Food Food_ = new Food();

    RestaurantJsonParser RestaurantJsonParser_ = new RestaurantJsonParser();
    CategoryJsonParser CategoryJsonParser_ = new CategoryJsonParser();
    MediaJsonParser MediaJsonParser_ = new MediaJsonParser();
    ExtraJsonParser ExtraJsonParser_ = new ExtraJsonParser();
    ExtraJGroupJsonParser ExtraJGroupJsonParser_ = new ExtraJGroupJsonParser();
    ReviewJsonParser ReviewJsonParser_ = new ReviewJsonParser();
    NutritionJsonParser NutritionJsonParser_ = new NutritionJsonParser();

    try{

      Food_.id = jsonMap['id'].toString();
      Food_.name = jsonMap['name'];
      Food_.price = jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0.0;
      Food_.discountPrice = jsonMap['discount_price'] != null ? jsonMap['discount_price'].toDouble() : 0.0;
      Food_.price = Food_.discountPrice != 0 ? Food_.discountPrice : Food_.price;
      Food_.discountPrice = Food_.discountPrice == 0 ? Food_.discountPrice : jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0.0;
      Food_.description = jsonMap['description'];
      Food_.ingredients = jsonMap['ingredients'];
      Food_.weight = jsonMap['weight'] != null ? jsonMap['weight'].toString() : '';
      Food_.unit = jsonMap['unit'] != null ? jsonMap['unit'].toString() : '';
      Food_.packageItemsCount = jsonMap['package_items_count'].toString();
      Food_.featured = jsonMap['featured'] ?? false;
      Food_.deliverable = jsonMap['deliverable'] ?? false;
      Food_.restaurant = jsonMap['restaurant'] != null ? RestaurantJsonParser_.fromJsonToModel(jsonMap['restaurant']) : RestaurantJsonParser_.fromJsonToModel({});
      Food_.category = jsonMap['category'] != null ? CategoryJsonParser_.fromJsonToModel(jsonMap['category']) : CategoryJsonParser_.fromJsonToModel({});
      Food_.image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0 ? MediaJsonParser_.fromJsonToModel(jsonMap['media'][0]) : new Media();

      Food_.extras = jsonMap['extras'] != null && (jsonMap['extras'] as List).length > 0
          ? List.from(jsonMap['extras']).map((element) => ExtraJsonParser_.fromJsonToModel(element) as Extra).toSet().toList()
          : [];
      Food_.extraGroups = jsonMap['extra_groups'] != null && (jsonMap['extra_groups'] as List).length > 0
          ? List.from(jsonMap['extra_groups']).map((element) => ExtraJGroupJsonParser_.fromJsonToModel(element) as ExtraGroup).toSet().toList()
          : [];
      Food_.foodReviews = jsonMap['food_reviews'] != null && (jsonMap['food_reviews'] as List).length > 0
          ? List.from(jsonMap['food_reviews']).map((element) => ReviewJsonParser_.fromJsonToModel(element) as Review).toSet().toList()
          : [];
      Food_.nutritions = jsonMap['nutrition'] != null && (jsonMap['nutrition'] as List).length > 0
          ? List.from(jsonMap['nutrition']).map((element) => NutritionJsonParser_.fromJsonToModel(element) as Nutrition).toSet().toList()
          : [];

    }catch(e){

      print(CustomTrace(StackTrace.current, message: e));

      CategoryJsonParser CategoryJsonParser_ = CategoryJsonParser();
      RestaurantJsonParser RestaurantJsonParser_ = RestaurantJsonParser();

      Food_.id = '';
      Food_.name = '';
      Food_.price = 0.0;
      Food_.discountPrice = 0.0;
      Food_.description = '';
      Food_.weight = '';
      Food_.ingredients = '';
      Food_.unit = '';
      Food_.packageItemsCount = '';
      Food_.featured = false;
      Food_.deliverable = false;
      Food_.restaurant = RestaurantJsonParser_.fromJsonToModel({});
      Food_.category = CategoryJsonParser_.fromJsonToModel({});
      Food_.image = new Media();
      Food_.extras = [];
      Food_.extraGroups = [];
      Food_.foodReviews = [];
      Food_.nutritions = [];
    }

    return Food_;
  }

  @override
  Map fromModeltoMap(Object Object) {

    //Cast the model
    Food Food_ = Object;

    var map = new Map<String, dynamic>();
    map["id"] = Food_.id;
    map["name"] = Food_.name;
    map["price"] = Food_.price;
    map["discountPrice"] = Food_.discountPrice;
    map["description"] = Food_.description;
    map["ingredients"] = Food_.ingredients;
    map["weight"] = Food_.weight;
    return map;
  }

  @override
  String mapToString(Object Object) {
    throw UnimplementedError();
  }
}