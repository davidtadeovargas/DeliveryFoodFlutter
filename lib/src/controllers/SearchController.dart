import 'package:mvc_pattern/mvc_pattern.dart';

import '../models/Address.dart';
import '../models/Food.dart';
import '../models/Restaurant.dart';

import 'package:food_delivery_app/src/repository/RepositoryManager.dart';
import '../repository/FoodRepository.dart';
import '../repository/RestaurantRepository.dart';
import '../repository/SearchRepository.dart';
import '../repository/SettingsRepository.dart';

class SearchController extends ControllerMVC {

  List<Restaurant> restaurants = <Restaurant>[];
  List<Food> foods = <Food>[];

  SettingsRepository SettingsRepository_ = RepositoryManager.SettingsRepository_;
  FoodRepository FoodRepository_ = RepositoryManager.FoodRepository_;
  RestaurantRepository RestaurantRepository_ = RepositoryManager.RestaurantRepository_;
  SearchRepository SearchRepository_ = RepositoryManager.SearchRepository_;

  SearchController() {
    listenForRestaurants();
    listenForFoods();
  }

  void listenForRestaurants({String search}) async {
    if (search == null) {
      search = await SearchRepository_.getRecentSearch();
    }
    Address _address = SettingsRepository_.deliveryAddress.value;
    final Stream<Restaurant> stream = await RestaurantRepository_.searchRestaurants(search, _address);
    stream.listen((Restaurant _restaurant) {
      setState(() => restaurants.add(_restaurant));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void listenForFoods({String search}) async {
    if (search == null) {
      search = await SearchRepository_.getRecentSearch();
    }
    Address _address = SettingsRepository_.deliveryAddress.value;
    final Stream<Food> stream = await FoodRepository_.searchFoods(search, _address);
    stream.listen((Food _food) {
      setState(() => foods.add(_food));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> refreshSearch(search) async {
    setState(() {
      restaurants = <Restaurant>[];
      foods = <Food>[];
    });
    listenForRestaurants(search: search);
    listenForFoods(search: search);
  }

  void saveSearch(String search) {
    SearchRepository_.setRecentSearch(search);
  }
}
