import 'package:food_delivery_app/src/helpers/custom_trace.dart';
import 'package:food_delivery_app/src/models/Notification.dart';

import 'IBaseParser.dart';


class NotificationJsonParser implements IBaseParser {

  @override
  Object fromJsonToModel(Map<String, dynamic> jsonMap) {

    Notification Notification_ = new Notification();

    try{

      Notification_.id = jsonMap['id'].toString();
      Notification_.type = jsonMap['type'] != null ? jsonMap['type'].toString() : '';
      Notification_.data = jsonMap['data'] != null ? {} : {};
      Notification_.read = jsonMap['read_at'] != null ? true : false;
      Notification_.createdAt = DateTime.parse(jsonMap['created_at']);

    }catch(e){
      print(CustomTrace(StackTrace.current, message: e));
    }

    return Notification_;
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

  Map markReadMap(Notification Notification_) {

    var map = new Map<String, dynamic>();
    map["id"] = Notification_.id;
    map["read_at"] = !Notification_.read;
    return map;

  }
}