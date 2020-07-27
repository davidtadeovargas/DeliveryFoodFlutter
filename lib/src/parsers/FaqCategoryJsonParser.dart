import 'package:food_delivery_app/src/models/Faq.dart';
import 'package:food_delivery_app/src/models/FaqCategory.dart';

import 'IBaseParser.dart';


class FaqCategoryJsonParser implements IBaseParser {

  @override
  Object fromJsonToModel(Map<String, dynamic> jsonMap) {

    FaqCategoryJsonParser FaqCategoryJsonParser_ = FaqCategoryJsonParser();
    FaqCategory FaqCategory_ = new FaqCategory();

    FaqCategory_.id = jsonMap['id'].toString();
    FaqCategory_.name = jsonMap['faqs'] != null ? jsonMap['name'].toString() : '';
    FaqCategory_.faqs = jsonMap['faqs'] != null ? List.from(jsonMap['faqs']).map((element) => FaqCategoryJsonParser_.fromJsonToModel(element) as Faq).toList() : [];

    return FaqCategory_;
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