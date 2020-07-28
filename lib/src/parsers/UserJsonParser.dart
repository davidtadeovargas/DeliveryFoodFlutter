import 'package:food_delivery_app/src/helpers/custom_trace.dart';
import 'package:food_delivery_app/src/models/Media.dart';
import 'package:food_delivery_app/src/models/User.dart';

import '../models/User.dart';
import 'IBaseParser.dart';
import 'MediaJsonParser.dart';


class UserJsonParser implements IBaseParser {

  MediaJsonParser MediaJsonParser_ = new MediaJsonParser();

  @override
  Object fromJsonToModel(Map<String, dynamic> jsonMap) {

    User User_ = new User();

    try{

      User_.id = jsonMap['id'].toString();
      User_.name = jsonMap['name'] != null ? jsonMap['name'] : '';
      User_.email = jsonMap['email'] != null ? jsonMap['email'] : '';
      User_.apiToken = jsonMap['api_token'];
      User_.deviceToken = jsonMap['device_token'];
      User_.phone = jsonMap['custom_fields']['phone']['view'];
      User_.address = jsonMap['custom_fields']['address']['view'];
      User_.bio = jsonMap['custom_fields']['bio']['view'];
      User_.image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0 ? MediaJsonParser_.fromJsonToModel(jsonMap['media'][0]) : new Media();

    }catch(e){

        print(CustomTrace(StackTrace.current, message: e));

        User_.phone = "";
        User_.address = "";
        User_.bio = "";
        User_.image = Media();
    }

    return User_;
  }

  @override
  Map fromModeltoMap(Object Object) {

    //Cast the model
    User User_ = Object;

    var map = new Map<String, dynamic>();

    map["id"] = User_.id;
    map["email"] = User_.email;
    map["name"] = User_.name;
    map["password"] = User_.password;
    map["api_token"] = User_.apiToken;
    if (User_.deviceToken != null) {
      map["device_token"] = User_.deviceToken;
    }
    map["phone"] = User_.phone;
    map["address"] = User_.address;
    map["bio"] = User_.bio;
    map["media"] = MediaJsonParser_.fromModeltoMap(User_.image);

    return map;
  }

  @override
  String mapToString(Object Object) {

    //Cast the model
    User User_ = Object;

    var map = fromModeltoMap(User_);
    map["auth"] = User_.auth;
    return map.toString();
  }
}