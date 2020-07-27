import 'dart:convert';
import 'dart:io';

import 'RepositoryManager.dart';
import 'package:food_delivery_app/src/parsers/FilterJsonParser.dart';
import 'package:food_delivery_app/src/parsers/RestaurantJsonParser.dart';
import 'package:food_delivery_app/src/parsers/ReviewJsonParser.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/Address.dart';
import '../models/Filter.dart';
import '../models/Restaurant.dart';
import '../models/Review.dart';

import '../repository/UserRepository.dart';

import 'AddressRepository.dart';

class RestaurantRepository{

  UserRepository UserRepository_ = RepositoryManager.UserRepository_;

  RestaurantJsonParser RestaurantJsonParser_ = RestaurantJsonParser();
  ReviewJsonParser ReviewJsonParser_ = ReviewJsonParser();
  FilterJsonParser FilterJsonParser_ = FilterJsonParser();
  AddressRepository AddressRepository_ = RepositoryManager.AddressRepository_;

  Future<Stream<Restaurant>> getNearRestaurants(Address myLocation, Address areaLocation) async {
    Uri uri = Helper.getUri('api/restaurants');
    Map<String, dynamic> _queryParams = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Filter filter = FilterJsonParser_.fromJsonToModel(json.decode(prefs.getString('filter') ?? '{}'));

    _queryParams['limit'] = '6';
    if (!AddressRepository_.isUnknown(myLocation)  && !AddressRepository_.isUnknown(areaLocation)) {
      _queryParams['myLon'] = myLocation.longitude.toString();
      _queryParams['myLat'] = myLocation.latitude.toString();
      _queryParams['areaLon'] = areaLocation.longitude.toString();
      _queryParams['areaLat'] = areaLocation.latitude.toString();
    }
    _queryParams.addAll(FilterJsonParser_.toQuery(filter));
    uri = uri.replace(queryParameters: _queryParams);
    try {
      final client = new http.Client();
      final streamedRest = await client.send(http.Request('get', uri));

      return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
        return RestaurantJsonParser_.fromJsonToModel(data);
      });
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
      return new Stream.value(RestaurantJsonParser_.fromJsonToModel({}));
    }
  }

  Future<Stream<Restaurant>> getPopularRestaurants(Address myLocation) async {
    Uri uri = Helper.getUri('api/restaurants');
    Map<String, dynamic> _queryParams = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Filter filter = FilterJsonParser_.fromJsonToModel(json.decode(prefs.getString('filter') ?? '{}'));

    _queryParams['limit'] = '6';
    _queryParams['popular'] = 'all';
    if (!AddressRepository_.isUnknown(myLocation)) {
      _queryParams['myLon'] = myLocation.longitude.toString();
      _queryParams['myLat'] = myLocation.latitude.toString();
    }
    _queryParams.addAll(FilterJsonParser_.toQuery(filter));
    uri = uri.replace(queryParameters: _queryParams);
    try {
      final client = new http.Client();
      final streamedRest = await client.send(http.Request('get', uri));

      return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
        return RestaurantJsonParser_.fromJsonToModel(data);
      });
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
      return new Stream.value(RestaurantJsonParser_.fromJsonToModel({}));
    }
  }

  Future<Stream<Restaurant>> searchRestaurants(String search, Address address) async {
    Uri uri = Helper.getUri('api/restaurants');
    Map<String, dynamic> _queryParams = {};
    _queryParams['search'] = 'name:$search;description:$search';
    _queryParams['searchFields'] = 'name:like;description:like';
    _queryParams['limit'] = '5';
    if (!AddressRepository_.isUnknown(address)) {
      _queryParams['myLon'] = address.longitude.toString();
      _queryParams['myLat'] = address.latitude.toString();
      _queryParams['areaLon'] = address.longitude.toString();
      _queryParams['areaLat'] = address.latitude.toString();
    }
    uri = uri.replace(queryParameters: _queryParams);
    try {
      final client = new http.Client();
      final streamedRest = await client.send(http.Request('get', uri));

      return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
        return RestaurantJsonParser_.fromJsonToModel(data);
      });
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
      return new Stream.value(RestaurantJsonParser_.fromJsonToModel({}));
    }
  }

  Future<Stream<Restaurant>> getRestaurant(String id, Address address) async {
    Uri uri = Helper.getUri('api/restaurants/$id');
    Map<String, dynamic> _queryParams = {};
    if (!AddressRepository_.isUnknown(address)) {
      _queryParams['myLon'] = address.longitude.toString();
      _queryParams['myLat'] = address.latitude.toString();
      _queryParams['areaLon'] = address.longitude.toString();
      _queryParams['areaLat'] = address.latitude.toString();
    }
    uri = uri.replace(queryParameters: _queryParams);
    try {
      final client = new http.Client();
      final streamedRest = await client.send(http.Request('get', uri));

      return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).map((data) => RestaurantJsonParser_.fromJsonToModel(data));
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
      return new Stream.value(RestaurantJsonParser_.fromJsonToModel({}));
    }
  }

  Future<Stream<Review>> getRestaurantReviews(String id) async {
    final String url = '${GlobalConfiguration().getString('api_base_url')}restaurant_reviews?with=user&search=restaurant_id:$id';
    try {
      final client = new http.Client();
      final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

      return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
        return ReviewJsonParser_.fromJsonToModel(data);
      });
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: url).toString());
      return new Stream.value(ReviewJsonParser_.fromJsonToModel({}));
    }
  }

  Future<Stream<Review>> getRecentReviews() async {
    final String url = '${GlobalConfiguration().getString('api_base_url')}restaurant_reviews?orderBy=updated_at&sortedBy=desc&limit=3&with=user';
    try {
      final client = new http.Client();
      final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
      return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
        return ReviewJsonParser_.fromJsonToModel(data);
      });
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: url).toString());
      return new Stream.value(ReviewJsonParser_.fromJsonToModel({}));
    }
  }

  Future<Review> addRestaurantReview(Review review, Restaurant restaurant) async {
    final String url = '${GlobalConfiguration().getString('api_base_url')}restaurant_reviews';
    final client = new http.Client();
    review.user = UserRepository_.currentUser.value;
    try {
      final response = await client.post(
        url,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: json.encode(ReviewJsonParser_.ofRestaurantToMap(review,restaurant.id)),
      );
      if (response.statusCode == 200) {
        return ReviewJsonParser_.fromJsonToModel(json.decode(response.body)['data']);
      } else {
        print(CustomTrace(StackTrace.current, message: response.body).toString());
        return ReviewJsonParser_.fromJsonToModel({});
      }
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: url).toString());
      return ReviewJsonParser_.fromJsonToModel({});
    }
  }

}
