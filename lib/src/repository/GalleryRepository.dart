import 'dart:convert';

import 'package:food_delivery_app/src/parsers/GalleryJsonParser.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helpers/helper.dart';
import '../models/Gallery.dart';
import '../models/User.dart';

import '../repository/UserRepository.dart';
import 'RepositoryManager.dart';

class GalleryRepository{

  Future<Stream<Gallery>> getGalleries(String idRestaurant) async {

    UserRepository UserRepository_ = RepositoryManager.UserRepository_;
    GalleryJsonParser GalleryJsonParser_ = new GalleryJsonParser();

    User _user = UserRepository_.currentUser.value;
    final String _apiToken = 'api_token=${_user.apiToken}&';
    final String url = '${GlobalConfiguration().getString('api_base_url')}galleries?${_apiToken}search=restaurant_id:$idRestaurant';

    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => GalleryJsonParser_.fromJsonToModel(data));
  }

}