import 'package:food_delivery_app/src/helpers/custom_trace.dart';
import 'package:food_delivery_app/src/models/Media.dart';
import 'package:global_configuration/global_configuration.dart';

import 'IBaseParser.dart';


class MediaJsonParser implements IBaseParser {

  @override
  Object fromJsonToModel(Map<String, dynamic> jsonMap) {

    Media Media_ = new Media();

    try{

      Media_.id = jsonMap['id'].toString();
      Media_.name = jsonMap['name'];
      Media_.url = jsonMap['url'];
      Media_.thumb = jsonMap['thumb'];
      Media_.icon = jsonMap['icon'];
      Media_.size = jsonMap['formated_size'];

    }catch(e){

      print(CustomTrace(StackTrace.current, message: e));

      Media_.url = "${GlobalConfiguration().getString('base_url')}images/image_default.png";
      Media_.thumb = "${GlobalConfiguration().getString('base_url')}images/image_default.png";
      Media_.icon = "${GlobalConfiguration().getString('base_url')}images/image_default.png";
    }

    return Media_;
  }

  @override
  Map fromModeltoMap(Object Object) {

    //Cast the model
    Media Media_ = Object;

    var map = new Map<String, dynamic>();

    if(Media_!=null){
      map["id"] = Media_.id;
      map["name"] = Media_.name;
      map["url"] = Media_.url;
      map["thumb"] = Media_.thumb;
      map["icon"] = Media_.icon;
      map["formated_size"] = Media_.size;
    }

    return map;
  }

  @override
  String mapToString(Object Object) {
    throw UnimplementedError();
  }
}