import 'package:food_delivery_app/src/models/Filter.dart';

import 'CuisineJsonParser.dart';
import 'IBaseParser.dart';


class FilterJsonParser implements IBaseParser {

  CuisineJsonParser CuisineJsonParser_ = new CuisineJsonParser();

  @override
  Object fromJsonToModel(Map<String, dynamic> jsonMap) {

    Filter Filter_ = new Filter();

    Filter_.open = jsonMap['open'] ?? false;
    Filter_.delivery = jsonMap['delivery'] ?? false;
    Filter_.cuisines = jsonMap['cuisines'] != null && (jsonMap['cuisines'] as List).length > 0
        ? List.from(jsonMap['cuisines']).map((element) => CuisineJsonParser_.fromJsonToModel(element)).toList()
        : [];

    return Filter_;
  }

  @override
  Map fromModeltoMap(Object Object) {

    //Cast the model
    Filter Filter_ = Object;

    var map = new Map<String, dynamic>();

    map['open'] = Filter_.open;
    map['delivery'] = Filter_.delivery;
    map['cuisines'] = Filter_.cuisines.map((element) => CuisineJsonParser_.fromModeltoMap(element)).toList();

    return map;
  }

  @override
  String mapToString(Object Object) {
    throw UnimplementedError();
  }

  Map<String, dynamic> toQuery(Filter Filter_,{Map<String, dynamic> oldQuery}) {
    Map<String, dynamic> query = {};
    String relation = '';
    if (oldQuery != null) {
      relation = oldQuery['with'] != null ? oldQuery['with'] + '.' : '';
      query['with'] = oldQuery['with'] != null ? oldQuery['with'] : null;
    }
    if (Filter_.delivery) {
      if (Filter_.open) {
        query['search'] = relation + 'available_for_delivery:1;closed:0';
        query['searchFields'] = relation + 'available_for_delivery:=;closed:=';
      } else {
        query['search'] = relation + 'available_for_delivery:1';
        query['searchFields'] = relation + 'available_for_delivery:=';
      }
    } else if (Filter_.open) {
      query['search'] = relation + 'closed:${Filter_.open ? 0 : 1}';
      query['searchFields'] = relation + 'closed:=';
    }
    if (Filter_.cuisines != null && Filter_.cuisines.isNotEmpty) {
      query['cuisines[]'] = Filter_.cuisines.map((element) => element.id).toList();
    }
    if (oldQuery != null) {
      if (query['search'] != null) {
        query['search'] += ';' + oldQuery['search'];
      } else {
        query['search'] = oldQuery['search'];
      }

      if (query['searchFields'] != null) {
        query['searchFields'] = query['searchFields'] + ';' + oldQuery['searchFields'];
      } else {
        query['searchFields'] = oldQuery['searchFields'];
      }

//      query['search'] =
//          oldQuery['search'] != null ? (query['search']) ?? '' + ';' + oldQuery['search'] : query['search'];
//      query['searchFields'] = oldQuery['searchFields'] != null
//          ? query['searchFields'] ?? '' + ';' + oldQuery['searchFields']
//          : query['searchFields'];
    }
    query['searchJoin'] = 'and';
    return query;
  }
}