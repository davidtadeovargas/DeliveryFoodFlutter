import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/Food.dart';
import '../models/Order.dart';
import '../models/OrderStatus.dart';
import '../models/Review.dart';

import 'package:food_delivery_app/src/repository/RepositoryManager.dart';
import '../repository/FoodRepository.dart';
import '../repository/OrderRepository.dart';
import '../repository/RestaurantRepository.dart';

class ReviewsController extends ControllerMVC {

  Review restaurantReview;
  List<Review> foodsReviews = [];
  Order order;
  List<Food> foodsOfOrder = [];
  List<OrderStatus> orderStatus = <OrderStatus>[];
  GlobalKey<ScaffoldState> scaffoldKey;

  FoodRepository FoodRepository_ = RepositoryManager.FoodRepository_;
  OrderRepository OrderRepository_ = RepositoryManager.OrderRepository_;
  RestaurantRepository RestaurantRepository_ = RepositoryManager.RestaurantRepository_;

  ReviewsController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    this.restaurantReview = new Review.init("0");
  }

  void listenForOrder({String orderId, String message}) async {

    final Stream<Order> stream = await OrderRepository_.getOrder(orderId);
    stream.listen((Order _order) {
      setState(() {
        order = _order;
        foodsReviews = List.generate(order.foodOrders.length, (_) => new Review.init("0"));
      });
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      getFoodsOfOrder();
      if (message != null) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void addFoodReview(Review _review, Food _food) async {
    FoodRepository_.addFoodReview(_review, _food).then((value) {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).the_food_has_been_rated_successfully),
      ));
    });
  }

  void addRestaurantReview(Review _review) async {
    RestaurantRepository_.addRestaurantReview(_review, this.order.foodOrders[0].food.restaurant).then((value) {
      refreshOrder();
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).the_restaurant_has_been_rated_successfully),
      ));
    });
  }

  Future<void> refreshOrder() async {
    listenForOrder(orderId: order.id, message: S.of(context).reviews_refreshed_successfully);
  }

  void getFoodsOfOrder() {
    this.order.foodOrders.forEach((_foodOrder) {
      if (!foodsOfOrder.contains(_foodOrder.food)) {
        foodsOfOrder.add(_foodOrder.food);
      }
    });
  }
}
