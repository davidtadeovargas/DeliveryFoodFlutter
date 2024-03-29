import 'dart:convert';

import 'package:food_delivery_app/src/parsers/CuisineJsonParser.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helpers/helper.dart';
import '../models/Cuisine.dart';

class CuisineRepository{

  Future<Stream<Cuisine>> getCuisines() async {

    CuisineJsonParser CuisineJsonParser_ = new CuisineJsonParser();

    final String url = '${GlobalConfiguration().getString('api_base_url')}cuisines?orderBy=updated_at&sortedBy=desc';

    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return CuisineJsonParser_.fromJsonToModel(data);
    });
  }
}