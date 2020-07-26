import 'dart:convert';

import 'package:food_delivery_app/src/models/Filter.dart';
import 'package:food_delivery_app/src/parsers/GalleryJsonParser.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helpers/helper.dart';
import '../models/Gallery.dart';
import '../models/User.dart';
import '../repository/UserRepository.dart';

class FilterRepository{

  String filterToString(Filter Filter_) {

    String filter = "";
    if (Filter_.delivery) {
      if (Filter_.open) {
        filter = "search=available_for_delivery:1;closed:0&searchFields=available_for_delivery:=;closed:=&searchJoin=and";
      } else {
        filter = "search=available_for_delivery:1&searchFields=available_for_delivery:=";
      }
    } else if (Filter_.open) {
      filter = "search=closed:${Filter_.open ? 0 : 1}&searchFields=closed:=";
    }
    return filter;
  }

}