import 'package:food_delivery_app/src/models/ExtraGroup.dart';

import 'IBaseParser.dart';


class ExtraJGroupJsonParser implements IBaseParser {

  @override
  Object fromJsonToModel(Map<String, dynamic> jsonMap) {

    ExtraGroup ExtraGroup_ = new ExtraGroup();

    ExtraGroup_.id = jsonMap['id'].toString();
    ExtraGroup_.name = jsonMap['name'];
    int forzed_ = jsonMap['forzed'];
    ExtraGroup_.forzed = forzed_==1;

    return ExtraGroup_;
  }

  @override
  Map fromModeltoMap(Object Object) {

    //Cast the model
    ExtraGroup ExtraGroup_ = Object;

    var map = new Map<String, dynamic>();

    map["id"] = ExtraGroup_.id;
    map["name"] = ExtraGroup_.name;

    return map;
  }

  @override
  String mapToString(Object Object) {
    throw UnimplementedError();
  }
}