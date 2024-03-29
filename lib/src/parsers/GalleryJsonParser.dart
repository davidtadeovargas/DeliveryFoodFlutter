import 'package:food_delivery_app/src/helpers/custom_trace.dart';
import 'package:food_delivery_app/src/models/Gallery.dart';
import 'package:food_delivery_app/src/models/Media.dart';

import 'IBaseParser.dart';
import 'MediaJsonParser.dart';


class GalleryJsonParser implements IBaseParser {

  @override
  Object fromJsonToModel(Map<String, dynamic> jsonMap) {

    MediaJsonParser MediaJsonParser_ = new MediaJsonParser();

    Gallery Gallery_ = new Gallery();

    try{

      Gallery_.id = jsonMap['id'].toString();
      Gallery_.image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0 ? MediaJsonParser_.fromJsonToModel(jsonMap['media'][0]) : new Media();
      Gallery_.description = jsonMap['description'];

    }catch(e){

      print(CustomTrace(StackTrace.current, message: e));

      Gallery_.id = '';
      Gallery_.image = new Media();
      Gallery_.description = '';
    }

    return Gallery_;
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