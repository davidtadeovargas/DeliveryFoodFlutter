import 'package:food_delivery_app/src/models/RouteArgument.dart';

import 'IBaseParser.dart';


class RouteArgumentJsonParser implements IBaseParser {

  @override
  Object fromJsonToModel(Map<String, dynamic> jsonMap) {

    RouteArgument RouteArgument_ = new RouteArgument();
    return RouteArgument_;
  }

  @override
  Map fromModeltoMap(Object Object) {

    var map = new Map<String, dynamic>();
    return map;
  }

  @override
  String mapToString(Object Object) {

    //Cast model
    RouteArgument RouteArgument_ = Object;

    return '{id: $RouteArgument_.id, heroTag:${RouteArgument_..heroTag.toString()}}';
  }
}