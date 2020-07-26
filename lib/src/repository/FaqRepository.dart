import 'dart:convert';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helpers/helper.dart';
import '../models/faq_category.dart';
import '../models/User.dart';
import '../repository/UserRepository.dart';

class FaqRepository{

  Future<Stream<FaqCategory>> getFaqCategories() async {

    UserRepository UserRepository_ = new UserRepository();

    User _user = UserRepository_.currentUser.value;
    final String _apiToken = 'api_token=${_user.apiToken}&';
    final String url = '${GlobalConfiguration().getString('api_base_url')}faq_categories?${_apiToken}with=faqs';

    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return FaqCategory.fromJSON(data);
    });
  }
}