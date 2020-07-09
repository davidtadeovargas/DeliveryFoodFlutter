import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/category.dart';
import '../models/food.dart';
import '../models/gallery.dart';
import '../models/restaurant.dart';
import '../models/review.dart';
import '../repository/category_repository.dart';
import '../repository/food_repository.dart';
import '../repository/gallery_repository.dart';
import '../repository/restaurant_repository.dart';
import '../repository/settings_repository.dart';

class RestaurantController extends ControllerMVC {
  Restaurant restaurant;
  List<Gallery> galleries = <Gallery>[];
  List<Food>foods = <Food>[];
  List<Food>foodsCategory = <Food>[];
  List<Food>trendingFoods = <Food>[];
  List<Food>featuredFoods = <Food>[];
  List<Category>categories = <Category>[];
  List<Review>reviews = <Review>[];
  GlobalKey<ScaffoldState> scaffoldKey;
  String _selectedCategory;

  RestaurantController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  //Contiene la lista de categorias por restauran
  /**
   * 
   * Eduardo Gonzalez Casasola 12 junio 2020
   * 
  **/
  Future<void> listenForCategories() async {
      final Stream<Category> stream = await getCategories();
      stream.listen((Category _category) {
        setState(() => categories.add(_category));
      }, onError: (a) {
        print(a);
      }, onDone: () {});
  }
  //Contiene la lista de productos por categoria
  Map<String, List<Food>> foodsCategories = {};


 get selectedCategory => this._selectedCategory;
    //Contine el id de la categoria
  set selectedCategory(String valor){
      foodsCategory.clear();
      this._selectedCategory = valor;
      listenForFoodsCategory(valor);
      notifyListeners();
  }

   void listenForFoodsCategory(String idCategoria) async {
    this._selectedCategory = idCategoria;
    final Stream<Food> stream = await getProductosPorCategoria(idCategoria);
    stream.listen((Food _food) {
      setState(() => foodsCategory.add(_food));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

   List<Food> get getArticulosCategoriaSeleccionada => this.foodsCategory;
  /** 
   * 
   * FIN 
   * 
   * **/
  void listenForRestaurant({String id, String message}) async {
    final Stream<Restaurant> stream = await getRestaurant(id, deliveryAddress.value);
    stream.listen((Restaurant _restaurant) {
      setState(() => restaurant = _restaurant);
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForGalleries(String idRestaurant) async {
    final Stream<Gallery> stream = await getGalleries(idRestaurant);
    stream.listen((Gallery _gallery) {
      setState(() => galleries.add(_gallery));
    }, onError: (a) {}, onDone: () {});
  }

  void listenForRestaurantReviews({String id, String message}) async {
    final Stream<Review> stream = await getRestaurantReviews(id);
    stream.listen((Review _review) {
      setState(() => reviews.add(_review));
    }, onError: (a) {}, onDone: () {});
  }

  void listenForFoods(String idRestaurant) async {
    final Stream<Food> stream = await getFoodsOfRestaurant(idRestaurant);
    stream.listen((Food _food) {
      setState(() => foods.add(_food));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void listenForTrendingFoods(String idRestaurant) async {
    final Stream<Food> stream = await getTrendingFoodsOfRestaurant(idRestaurant);
    stream.listen((Food _food) {
      setState(() => trendingFoods.add(_food));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void listenForFeaturedFoods(String idRestaurant) async {
    final Stream<Food> stream = await getFeaturedFoodsOfRestaurant(idRestaurant);
    stream.listen((Food _food) {
      setState(() => featuredFoods.add(_food));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> refreshRestaurant() async {
    var _id = restaurant.id;
    restaurant = new Restaurant();
    galleries.clear();
    reviews.clear();
    featuredFoods.clear();
    listenForRestaurant(id: _id, message: S.of(context).restaurant_refreshed_successfuly);
    listenForRestaurantReviews(id: _id);
    listenForGalleries(_id);
    listenForFeaturedFoods(_id);
  }
}
