import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/src/parsers/AddressJsonParser.dart';
import 'package:food_delivery_app/src/parsers/CreditCardJsonParser.dart';
import 'package:food_delivery_app/src/parsers/UserJsonParser.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/Address.dart';
import '../models/CreditCard.dart';
import '../models/User.dart';

class UserRepository{

  ValueNotifier<User> currentUser = ValueNotifier(User());
  UserJsonParser UserJsonParser_ = UserJsonParser();
  CreditCardJsonParser CreditCardJsonParser_ = CreditCardJsonParser();
  AddressJsonParser AddressJsonParser_ = AddressJsonParser();

  Future<User> login(User user) async {
    final String url = '${GlobalConfiguration().getString('api_base_url')}login';
    final client = new http.Client();
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(UserJsonParser_.fromModeltoMap(user)),
    );
    if (response.statusCode == 200) {
      setCurrentUser(response.body);
      currentUser.value = UserJsonParser_.fromJsonToModel(json.decode(response.body)['data']);
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
      throw new Exception(response.body);
    }
    return currentUser.value;
  }

  bool profileCompleted(User User_) {
    return User_.address != null && User_.address != '' && User_.phone != null && User_.phone != '';
  }

  Future<User> register(User user) async {
    final String url = '${GlobalConfiguration().getString('api_base_url')}register';
    final client = new http.Client();
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(UserJsonParser_.fromModeltoMap(user)),
    );
    if (response.statusCode == 200) {
      setCurrentUser(response.body);
      currentUser.value = UserJsonParser_.fromJsonToModel(json.decode(response.body)['data']);
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
      throw new Exception(response.body);
    }
    return currentUser.value;
  }

  Future<bool> resetPassword(User user) async {
    final String url = '${GlobalConfiguration().getString('api_base_url')}send_reset_link_email';
    final client = new http.Client();
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(UserJsonParser_.fromModeltoMap(user)),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
      throw new Exception(response.body);
    }
  }

  Future<void> logout() async {
    currentUser.value = new User();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
  }

  void setCurrentUser(jsonString) async {
    try {
      if (json.decode(jsonString)['data'] != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('current_user', json.encode(json.decode(jsonString)['data']));
      }
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: jsonString).toString());
      throw new Exception(e);
    }
  }

  Future<void> setCreditCard(CreditCard creditCard) async {
    if (creditCard != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('credit_card', json.encode(CreditCardJsonParser_.fromModeltoMap(creditCard)));
    }
  }

  Future<User> getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.clear();
    if (currentUser.value.auth == null && prefs.containsKey('current_user')) {
      currentUser.value = UserJsonParser_.fromJsonToModel(json.decode(await prefs.get('current_user')));
      currentUser.value.auth = true;
    } else {
      currentUser.value.auth = false;
    }
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    currentUser.notifyListeners();
    return currentUser.value;
  }

  Future<CreditCard> getCreditCard() async {
    CreditCard _creditCard = new CreditCard();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('credit_card')) {
      _creditCard = CreditCardJsonParser_.fromJsonToModel(json.decode(await prefs.get('credit_card')));
    }
    return _creditCard;
  }

  Future<User> update(User user) async {
    final String _apiToken = 'api_token=${currentUser.value.apiToken}';
    final String url = '${GlobalConfiguration().getString('api_base_url')}users/${currentUser.value.id}?$_apiToken';
    final client = new http.Client();
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(UserJsonParser_.fromModeltoMap(user)),
    );
    setCurrentUser(response.body);
    currentUser.value = UserJsonParser_.fromJsonToModel(json.decode(response.body)['data']);
    return currentUser.value;
  }

  Future<Stream<Address>> getAddresses() async {
    User _user = currentUser.value;
    final String _apiToken = 'api_token=${_user.apiToken}&';
    final String url =
        '${GlobalConfiguration().getString('api_base_url')}delivery_addresses?$_apiToken&search=user_id:${_user.id}&searchFields=user_id:=&orderBy=updated_at&sortedBy=desc';
    try {
      final client = new http.Client();
      final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

      return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
        return AddressJsonParser_.fromJsonToModel(data);
      });
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: url));
      return new Stream.value(AddressJsonParser_.fromJsonToModel({}));
    }
  }

  Future<Address> addAddress(Address address) async {
    User _user = currentUser.value;
    final String _apiToken = 'api_token=${_user.apiToken}';
    address.userId = _user.id;
    final String url = '${GlobalConfiguration().getString('api_base_url')}delivery_addresses?$_apiToken';
    final client = new http.Client();
    try {
      final response = await client.post(
        url,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: json.encode(AddressJsonParser_.fromModeltoMap(address)),
      );
      return AddressJsonParser_.fromJsonToModel(json.decode(response.body)['data']);
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: url));
      return AddressJsonParser_.fromJsonToModel({});
    }
  }

  Future<Address> updateAddress(Address address) async {
    User _user = currentUser.value;
    final String _apiToken = 'api_token=${_user.apiToken}';
    address.userId = _user.id;
    final String url = '${GlobalConfiguration().getString('api_base_url')}delivery_addresses/${address.id}?$_apiToken';
    final client = new http.Client();
    try {
      final response = await client.put(
        url,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: json.encode(AddressJsonParser_.fromModeltoMap(address)),
      );
      return AddressJsonParser_.fromJsonToModel(json.decode(response.body)['data']);
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: url));
      return AddressJsonParser_.fromJsonToModel({});
    }
  }

  Future<Address> removeDeliveryAddress(Address address) async {
    User _user = currentUser.value;
    final String _apiToken = 'api_token=${_user.apiToken}';
    final String url = '${GlobalConfiguration().getString('api_base_url')}delivery_addresses/${address.id}?$_apiToken';
    final client = new http.Client();
    try {
      final response = await client.delete(
        url,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
      return AddressJsonParser_.fromJsonToModel(json.decode(response.body)['data']);
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: url));
      return AddressJsonParser_.fromJsonToModel({});
    }
  }
}