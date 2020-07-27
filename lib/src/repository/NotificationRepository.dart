import 'dart:convert';

import 'package:food_delivery_app/src/models/Notification.dart';
import 'package:food_delivery_app/src/parsers/NotificationJsonParser.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/User.dart';

import 'RepositoryManager.dart';
import '../repository/UserRepository.dart';

class NotificationRepository{

  Future<Stream<Notification>> getNotifications() async {

    UserRepository UserRepository_ = RepositoryManager.UserRepository_;
    NotificationJsonParser NotificationJsonParser_ = NotificationJsonParser();

    User _user = UserRepository_.currentUser.value;
    if (_user.apiToken == null) {
      return new Stream.value(null);
    }
    final String _apiToken = 'api_token=${_user.apiToken}&';
    final String url =
        '${GlobalConfiguration().getString('api_base_url')}notifications?${_apiToken}search=notifiable_id:${_user.id}&searchFields=notifiable_id:=&orderBy=created_at&sortedBy=desc&limit=10';

    final client = new http.Client();
    try {
      final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

      return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
        return NotificationJsonParser_.fromJsonToModel(data);
      });
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: url));
      return new Stream.value(NotificationJsonParser_.fromJsonToModel({}));
    }
  }

}