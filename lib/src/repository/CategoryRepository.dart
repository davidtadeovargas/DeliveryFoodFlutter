import 'dart:convert';

import 'package:food_delivery_app/src/parsers/CategoryJsonParser.dart';
import 'package:food_delivery_app/src/parsers/FilterJsonParser.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/Category.dart';
import '../models/Filter.dart';

class CategoryRepository{

  CategoryJsonParser CategoryJsonParser_ = new CategoryJsonParser();
  FilterJsonParser FilterJsonParser_ = new FilterJsonParser();

  Future<Stream<Category>> getCategories() async {

    Uri uri = Helper.getUri('api/categories');
    Map<String, dynamic> _queryParams = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Filter filter = FilterJsonParser_.fromJsonToModel(json.decode(prefs.getString('filter') ?? '{}'));
    filter.delivery = false;
    filter.open = false;

    _queryParams.addAll(FilterJsonParser_.toQuery(filter));
    uri = uri.replace(queryParameters: _queryParams);
    try {
      final client = new http.Client();
      final streamedRest = await client.send(http.Request('get', uri));

      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .expand((data) => (data as List))
          .map((data) => CategoryJsonParser_.fromJsonToModel(data));
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
      return new Stream.value(CategoryJsonParser_.fromJsonToModel({}));
    }
  }

  Future<Stream<Category>> getCategory(String id) async {
    final String url = '${GlobalConfiguration().getString('api_base_url')}categories/$id';
    try {
      final client = new http.Client();
      final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

      return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).map((data) => CategoryJsonParser_.fromJsonToModel(data));
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: url).toString());
      return new Stream.value(CategoryJsonParser_.fromJsonToModel({}));
    }
  }
}