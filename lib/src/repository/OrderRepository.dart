import 'dart:convert';
import 'dart:io';

import 'package:food_delivery_app/src/parsers/OrderJsonParser.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helpers/helper.dart';
import '../models/credit_card.dart';
import '../models/Order.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../models/User.dart';
import 'UserRepository.dart';

class OrderRepository {

  UserRepository UserRepository_ = new UserRepository();
  
  Future<Stream<Order>> getOrders() async {
    User _user = UserRepository_.currentUser.value;
    if (_user.apiToken == null) {
      return new Stream.value(null);
    }
    final String _apiToken = 'api_token=${_user.apiToken}&';
    final String url =
        '${GlobalConfiguration().getString('api_base_url')}orders?${_apiToken}with=user;foodOrders;foodOrders.food;orderStatus;payment&search=user.id:${_user.id}&searchFields=user.id:=&orderBy=id&sortedBy=desc';

    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return new OrderJsonParser().fromJsonToModel(data);
    });
  }

  Future<Stream<Order>> getOrder(orderId) async {
    User _user = UserRepository_.currentUser.value;
    if (_user.apiToken == null) {
      return new Stream.value(null);
    }
    final String _apiToken = 'api_token=${_user.apiToken}&';
    final String url =
        '${GlobalConfiguration().getString('api_base_url')}orders/$orderId?${_apiToken}with=user;foodOrders;foodOrders.food;orderStatus;deliveryAddress;payment';
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).map((data) {
      return new OrderJsonParser().fromJsonToModel(data);
    });
  }

  Future<Stream<Order>> getRecentOrders() async {
    User _user = UserRepository_.currentUser.value;
    if (_user.apiToken == null) {
      return new Stream.value(null);
    }
    final String _apiToken = 'api_token=${_user.apiToken}&';
    final String url =
        '${GlobalConfiguration().getString('api_base_url')}orders?${_apiToken}with=user;foodOrders;foodOrders.food;orderStatus;payment&search=user.id:${_user.id}&searchFields=user.id:=&orderBy=updated_at&sortedBy=desc&limit=3';

    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return new OrderJsonParser().fromJsonToModel(data);
    });
  }

  Future<Stream<OrderStatus>> getOrderStatus() async {
    User _user = UserRepository_.currentUser.value;
    if (_user.apiToken == null) {
      return new Stream.value(null);
    }
    final String _apiToken = 'api_token=${_user.apiToken}';
    final String url = '${GlobalConfiguration().getString('api_base_url')}order_statuses?$_apiToken';

    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return OrderStatus.fromJSON(data);
    });
  }

  Future<Order> addOrder(Order order, Payment payment) async {
    User _user = UserRepository_.currentUser.value;
    if (_user.apiToken == null) {
      return new Order();
    }
    CreditCard _creditCard = await UserRepository_.getCreditCard();
    order.user = _user;
    order.payment = payment;
    final String _apiToken = 'api_token=${_user.apiToken}';
    final String url = '${GlobalConfiguration().getString('api_base_url')}orders?$_apiToken';
    final client = new http.Client();

    Map params = new OrderJsonParser().fromModeltoMap(order);

    params.addAll(_creditCard.toMap());
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(params),
    );

    order = new OrderJsonParser().fromJsonToModel(json.decode(response.body)['data']);

    return order;
  }

  Future<Order> cancelOrder(Order order) async {

    //Cancel order
    order.active = false;

    //Get params to send
    Map params = new OrderJsonParser().fromModeltoMap(order);

    print(params);

    User _user = UserRepository_.currentUser.value;
    final String _apiToken = 'api_token=${_user.apiToken}';
    final String url = '${GlobalConfiguration().getString('api_base_url')}orders/${order.id}?$_apiToken';
    final client = new http.Client();
    final response = await client.put(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(params),
    );
    if (response.statusCode == 200) {

      order = new OrderJsonParser().fromJsonToModel(json.decode(response.body)['data']);
      return order;

    } else {
      throw new Exception(response.body);
    }

  }

  bool canCancelOrder(Order order) {
    return order.active == true && order.orderStatus.id == '1'; // 1 for order received status
  }
}
