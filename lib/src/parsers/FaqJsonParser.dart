import 'package:food_delivery_app/src/models/Faq.dart';

import 'IBaseParser.dart';


class FaqJsonParser implements IBaseParser {

  @override
  Object fromJsonToModel(Map<String, dynamic> jsonMap) {

    Faq Faq_ = new Faq();

    Faq_.id = jsonMap['id'].toString();
    Faq_.question = jsonMap['question'] != null ? jsonMap['question'] : '';
    Faq_.answer = jsonMap['answer'] != null ? jsonMap['answer'] : '';

    return Faq_;
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