import 'package:food_delivery_app/src/models/Media.dart';

import 'IBaseParser.dart';


class MediaJsonParser implements IBaseParser {

  @override
  Object fromJsonToModel(Map<String, dynamic> jsonMap) {

    Media Media_ = new Media();

    Media_.id = jsonMap['id'].toString();
    Media_.name = jsonMap['name'];
    Media_.url = jsonMap['url'];
    Media_.thumb = jsonMap['thumb'];
    Media_.icon = jsonMap['icon'];
    Media_.size = jsonMap['formated_size'];

    return Media_;
  }

  @override
  Map fromModeltoMap(Object Object) {

    //Cast the model
    Media Media_ = Object;

    var map = new Map<String, dynamic>();
    map["id"] = Media_.id;
    map["name"] = Media_.name;
    map["url"] = Media_.url;
    map["thumb"] = Media_.thumb;
    map["icon"] = Media_.icon;
    map["formated_size"] = Media_.size;

    return map;
  }

  @override
  String mapToString(Object Object) {
    throw UnimplementedError();
  }
}