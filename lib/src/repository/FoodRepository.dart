import 'dart:convert';
import 'dart:io';

import 'package:food_delivery_app/src/parsers/FavoriteJsonParser.dart';
import 'package:food_delivery_app/src/parsers/FilterJsonParser.dart';
import 'package:food_delivery_app/src/parsers/FoodJsonParser.dart';
import 'package:food_delivery_app/src/parsers/ReviewJsonParser.dart';
import 'RepositoryManager.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/Address.dart';
import '../models/Favorite.dart';
import '../models/Filter.dart';
import '../models/Food.dart';
import '../models/Review.dart';
import '../models/User.dart';
import '../repository/UserRepository.dart';
import 'AddressRepository.dart';

class FoodRepository{

  FoodJsonParser FoodJsonParser_ = FoodJsonParser();
  FavoriteJsonParser FavoriteJsonParser_ = FavoriteJsonParser();
  ReviewJsonParser ReviewJsonParser_ = ReviewJsonParser();
  FilterJsonParser FilterJsonParser_ = FilterJsonParser();

  UserRepository UserRepository_ = RepositoryManager.UserRepository_;
  AddressRepository AddressRepository_ = RepositoryManager.AddressRepository_;


  Future<Stream<Food>> getTrendingFoods(Address address) async {
    Uri uri = Helper.getUri('api/foods');
    Map<String, dynamic> _queryParams = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Filter filter = FilterJsonParser_.fromJsonToModel(json.decode(prefs.getString('filter') ?? '{}'));
    filter.delivery = false;
    filter.open = false;
    _queryParams['limit'] = '6';
    _queryParams['trending'] = 'week';
    if (!AddressRepository_.isUnknown(address)) {
      _queryParams['myLon'] = address.longitude.toString();
      _queryParams['myLat'] = address.latitude.toString();
      _queryParams['areaLon'] = address.longitude.toString();
      _queryParams['areaLat'] = address.latitude.toString();
    }
    _queryParams.addAll(FilterJsonParser_.toQuery(filter));
    uri = uri.replace(queryParameters: _queryParams);
    try {
      final client = new http.Client();
      final streamedRest = await client.send(http.Request('get', uri));

      return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
        return FoodJsonParser_.fromJsonToModel(data);
      });
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
      return new Stream.value(FoodJsonParser_.fromJsonToModel({}));
    }
  }

  Future<Stream<Food>> getFood(String foodId) async {
    Uri uri = Helper.getUri('api/foods/$foodId');
    uri = uri.replace(queryParameters: {'with': 'nutrition;restaurant;category;extras;extraGroups;foodReviews;foodReviews.user'});
    try {
      final client = new http.Client();
      final streamedRest = await client.send(http.Request('get', uri));
      return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).map((data) {
        return FoodJsonParser_.fromJsonToModel(data);
      });
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
      return new Stream.value(FoodJsonParser_.fromJsonToModel({}));
    }
  }

  Future<Stream<Food>> searchFoods(String search, Address address) async {
    Uri uri = Helper.getUri('api/foods');
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
        return FoodJsonParser_.fromJsonToModel(data);
      });
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
      return new Stream.value(FoodJsonParser_.fromJsonToModel({}));
    }
  }

  Future<Stream<Food>> getFoodsByCategory(categoryId) async {
    Uri uri = Helper.getUri('api/foods');
    Map<String, dynamic> _queryParams = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Filter filter = FilterJsonParser_.fromJsonToModel(json.decode(prefs.getString('filter') ?? '{}'));
    _queryParams['with'] = 'restaurant';
    _queryParams['search'] = 'category_id:$categoryId';
    _queryParams['searchFields'] = 'category_id:=';

    _queryParams = FilterJsonParser_.toQuery(filter,oldQuery: _queryParams);
    uri = uri.replace(queryParameters: _queryParams);
    try {
      final client = new http.Client();
      final streamedRest = await client.send(http.Request('get', uri));

      return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
        return FoodJsonParser_.fromJsonToModel(data);
      });
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
      return new Stream.value(FoodJsonParser_.fromJsonToModel({}));
    }
  }

  Future<Stream<Favorite>> isFavoriteFood(String foodId) async {
    User _user = UserRepository_.currentUser.value;
    if (_user.apiToken == null) {
      return Stream.value(null);
    }
    final String _apiToken = 'api_token=${_user.apiToken}&';
    final String url = '${GlobalConfiguration().getString('api_base_url')}favorites/exist?${_apiToken}food_id=$foodId&user_id=${_user.id}';
    try {
      final client = new http.Client();
      final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

      return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getObjectData(data)).map((data) => FavoriteJsonParser_.fromJsonToModel(data));
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: url).toString());
      return new Stream.value(FavoriteJsonParser_.fromJsonToModel({}));
    }
  }

  Future<Stream<Favorite>> getFavorites() async {
    User _user = UserRepository_.currentUser.value;
    if (_user.apiToken == null) {
      return Stream.value(null);
    }
    final String _apiToken = 'api_token=${_user.apiToken}&';
    final String url =
        '${GlobalConfiguration().getString('api_base_url')}favorites?${_apiToken}with=food;user;extras&search=user_id:${_user.id}&searchFields=user_id:=';

    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    try {
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .expand((data) => (data as List))
          .map((data) => FavoriteJsonParser_.fromJsonToModel(data));
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: url).toString());
      return new Stream.value(FavoriteJsonParser_.fromJsonToModel({}));
    }
  }

  Future<Favorite> addFavorite(Favorite favorite) async {
    User _user = UserRepository_.currentUser.value;
    if (_user.apiToken == null) {
      return new Favorite();
    }
    final String _apiToken = 'api_token=${_user.apiToken}';
    favorite.userId = _user.id;
    final String url = '${GlobalConfiguration().getString('api_base_url')}favorites?$_apiToken';
    try {
      final client = new http.Client();
      final response = await client.post(
        url,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: json.encode(FavoriteJsonParser_.fromModeltoMap(favorite)),
      );
      return FavoriteJsonParser_.fromJsonToModel(json.decode(response.body)['data']);
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: url).toString());
      return FavoriteJsonParser_.fromJsonToModel({});
    }
  }

  Future<Favorite> removeFavorite(Favorite favorite) async {
    User _user = UserRepository_.currentUser.value;
    if (_user.apiToken == null) {
      return new Favorite();
    }
    final String _apiToken = 'api_token=${_user.apiToken}';
    final String url = '${GlobalConfiguration().getString('api_base_url')}favorites/${favorite.id}?$_apiToken';
    try {
      final client = new http.Client();
      final response = await client.delete(
        url,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
      return FavoriteJsonParser_.fromJsonToModel(json.decode(response.body)['data']);
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: url).toString());
      return FavoriteJsonParser_.fromJsonToModel({});
    }
  }

  Future<Stream<Food>> getFoodsOfRestaurant(String restaurantId) async {
    final String url = '${GlobalConfiguration().getString('api_base_url')}foods?with=restaurant&search=restaurant.id:$restaurantId&searchFields=restaurant.id:=';
    try {
      final client = new http.Client();
      final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

      return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
        return FoodJsonParser_.fromJsonToModel(data);
      });
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: url).toString());
      return new Stream.value(FoodJsonParser_.fromJsonToModel({}));
    }
  }

  Future<Stream<Food>> getProductosPorCategoria(String categoriID) async {
    final String url = '${GlobalConfiguration().getString('api_base_url')}foods?with=restaurant&search=category_id:$categoriID&searchFields=category_id:=';
    try {
      final client = new http.Client();
      final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

      return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
        return FoodJsonParser_.fromJsonToModel(data);
      });
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: url).toString());
      return new Stream.value(FoodJsonParser_.fromJsonToModel({}));
    }
  }


  Future<Stream<Food>> getTrendingFoodsOfRestaurant(String restaurantId) async {
    Uri uri = Helper.getUri('api/foods');
    uri = uri.replace(queryParameters: {
      'with': 'restaurant',
      'search': 'restaurant_id:$restaurantId;featured:1',
      'searchFields': 'restaurant_id:=;featured:=',
    });
    // TODO Trending foods only
    try {
      final client = new http.Client();
      final streamedRest = await client.send(http.Request('get', uri));

      return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
        return FoodJsonParser_.fromJsonToModel(data);
      });
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
      return new Stream.value(FoodJsonParser_.fromJsonToModel({}));
    }
  }

  Future<Stream<Food>> getFeaturedFoodsOfRestaurant(String restaurantId) async {
    Uri uri = Helper.getUri('api/foods');
    uri = uri.replace(queryParameters: {
      'with': 'restaurant',
      'search': 'restaurant_id:$restaurantId;featured:1',
      'searchFields': 'restaurant_id:=;featured:=',
      'searchJoin': 'and',
    });
    try {
      final client = new http.Client();
      final streamedRest = await client.send(http.Request('get', uri));

      return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
        return FoodJsonParser_.fromJsonToModel(data);
      });
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
      return new Stream.value(FoodJsonParser_.fromJsonToModel({}));
    }
  }

  Future<Review> addFoodReview(Review review, Food food) async {
    final String url = '${GlobalConfiguration().getString('api_base_url')}food_reviews';
    final client = new http.Client();
    review.user = UserRepository_.currentUser.value;
    try {
      final response = await client.post(
        url,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: json.encode(ReviewJsonParser_.ofFoodToMap(review, food.id)),
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