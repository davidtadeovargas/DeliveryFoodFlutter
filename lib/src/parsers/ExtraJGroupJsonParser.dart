import 'package:food_delivery_app/src/helpers/custom_trace.dart';
import 'package:food_delivery_app/src/models/ExtraGroup.dart';

import 'IBaseParser.dart';


class ExtraJGroupJsonParser implements IBaseParser {

  @override
  Object fromJsonToModel(Map<String, dynamic> jsonMap) {

    ExtraGroup ExtraGroup_ = new ExtraGroup();

    try{

      ExtraGroup_.id = jsonMap['id'].toString();
      ExtraGroup_.name = jsonMap['name'];
      bool forzed_ = jsonMap['forzed'];
      ExtraGroup_.forzed = forzed_;

    }catch(e){

      print(CustomTrace(StackTrace.current, message: e));

      ExtraGroup_.id = '';
      ExtraGroup_.name = '';
      ExtraGroup_.forzed = false;
    }

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