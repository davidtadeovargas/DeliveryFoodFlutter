import 'dart:convert';
import 'dart:io';

import 'package:food_delivery_app/src/models/Extra.dart';
import 'package:food_delivery_app/src/parsers/CartJsonParser.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/Cart.dart';
import '../models/User.dart';

import 'RepositoryManager.dart';
import '../repository/UserRepository.dart';

class CartRepository{

  UserRepository UserRepository_ = RepositoryManager.UserRepository_;

  CartJsonParser CartJsonParser_ = new CartJsonParser();

  Future<Stream<Cart>> getCart() async {
    User _user = UserRepository_.currentUser.value;
    if (_user.apiToken == null) {
      return new Stream.value(null);
    }
    final String _apiToken = 'api_token=${_user.apiToken}&';
    final String url =
        '${GlobalConfiguration().getString('api_base_url')}carts?${_apiToken}with=food;food.restaurant;extras&search=user_id:${_user.id}&searchFields=user_id:=';

    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return CartJsonParser_.fromJsonToModel(data);
    });
  }

  Future<Stream<int>> getCartCount() async {
    User _user = UserRepository_.currentUser.value;
    if (_user.apiToken == null) {
      return new Stream.value(0);
    }
    final String _apiToken = 'api_token=${_user.apiToken}&';
    final String url = '${GlobalConfiguration().getString('api_base_url')}carts/count?${_apiToken}search=user_id:${_user.id}&searchFields=user_id:=';

    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map(
          (data) => Helper.getIntData(data),
    );
  }

  Future<Cart> addCart(Cart cart, bool reset) async {
    User _user = UserRepository_.currentUser.value;
    if (_user.apiToken == null) {
      return new Cart();
    }
    Map<String, dynamic> decodedJSON = {};
    final String _apiToken = 'api_token=${_user.apiToken}';
    final String _resetParam = 'reset=${reset ? 1 : 0}';
    cart.userId = _user.id;
    final String url = '${GlobalConfiguration().getString('api_base_url')}carts?$_apiToken&$_resetParam';
    final client = new http.Client();
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(CartJsonParser_.fromModeltoMap(cart)),
    );
    try {
      decodedJSON = json.decode(response.body)['data'] as Map<String, dynamic>;
    } on FormatException catch (e) {
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
    return CartJsonParser_.fromJsonToModel(decodedJSON);
  }

  double getFoodPrice(Cart Cart_) {
    double result = Cart_.food.price;
    if (Cart_.extras.isNotEmpty) {
      Cart_.extras.forEach((Extra extra) {
        result += extra.price != null ? extra.price : 0;
      });
    }
    return result;
  }

  bool isSame(Cart cart) {
    bool _same = true;
    _same &= cart.food == cart.food;
    _same &= cart.extras.length == cart.extras.length;
    if (_same) {
      cart.extras.forEach((Extra _extra) {
        _same &= cart.extras.contains(_extra);
      });
    }
    return _same;
  }

  Future<Cart> updateCart(Cart cart) async {
    User _user = UserRepository_.currentUser.value;
    if (_user.apiToken == null) {
      return new Cart();
    }
    final String _apiToken = 'api_token=${_user.apiToken}';
    cart.userId = _user.id;
    final String url = '${GlobalConfiguration().getString('api_base_url')}carts/${cart.id}?$_apiToken';
    final client = new http.Client();
    final response = await client.put(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(CartJsonParser_.fromModeltoMap(cart)),
    );
    return CartJsonParser_.fromJsonToModel(json.decode(response.body)['data']);
  }

  Future<bool> removeCart(Cart cart) async {
    User _user = UserRepository_.currentUser.value;
    if (_user.apiToken == null) {
      return false;
    }
    final String _apiToken = 'api_token=${_user.apiToken}';
    final String url = '${GlobalConfiguration().getString('api_base_url')}carts/${cart.id}?$_apiToken';
    final client = new http.Client();
    final response = await client.delete(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    return Helper.getBoolData(json.decode(response.body));
  }

}