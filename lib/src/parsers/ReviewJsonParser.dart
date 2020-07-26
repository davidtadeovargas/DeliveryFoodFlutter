import 'package:food_delivery_app/src/models/Review.dart';

import 'IBaseParser.dart';
import 'UserJsonParser.dart';


class ReviewJsonParser implements IBaseParser {

  @override
  Object fromJsonToModel(Map<String, dynamic> jsonMap) {

    UserJsonParser UserJsonParser_ = new UserJsonParser();

    Review Review_ = new Review();

    Review_.id = jsonMap['id'].toString();
    Review_.review = jsonMap['review'];
    Review_.rate = jsonMap['rate'].toString() ?? '0';
    Review_.user = jsonMap['user'] != null ? UserJsonParser_.fromJsonToModel(jsonMap['user']) : UserJsonParser_.fromJsonToModel({});

    return Review_;
  }

  @override
  Map fromModeltoMap(Object Object) {

    //Cast the model
    Review Review_ = Object;

    var map = new Map<String, dynamic>();

    map["id"] = Review_.id;
    map["review"] = Review_.review;
    map["rate"] = Review_.rate;
    map["user_id"] = Review_.user?.id;

    return map;
  }

  Map ofFoodToMap(Review Review_, String foodId) {

    var map = fromModeltoMap(Review_);
    map["food_id"] = foodId;
    return map;
  }

  Map ofRestaurantToMap(Review Review_, String restaurantId) {

    var map = fromModeltoMap(Review_);
    map["restaurant_id"] = restaurantId;
    return map;
  }

  @override
  String mapToString(Object Object) {
    throw UnimplementedError();
  }
}