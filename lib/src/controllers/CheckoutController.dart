import 'package:flutter/material.dart';

import 'package:food_delivery_app/src/repository/RepositoryManager.dart';
import 'package:food_delivery_app/src/repository/ComandaRepository.dart';
import 'package:food_delivery_app/src/repository/OrderRepository.dart';

import '../../generated/l10n.dart';
import '../models/Cart.dart';
import '../models/CreditCard.dart';
import '../models/FoodOrder.dart';
import '../models/Order.dart';
import '../models/OrderStatus.dart';
import '../models/Payment.dart';

import 'package:food_delivery_app/src/repository/RepositoryManager.dart';
import '../repository/OrderRepository.dart';
import '../repository/SettingsRepository.dart';
import '../repository/UserRepository.dart';

import 'CartController.dart';

class CheckoutController extends CartController {
  Payment payment;

  UserRepository UserRepository_ = RepositoryManager.UserRepository_;
  SettingsRepository SettingsRepository_ = RepositoryManager.SettingsRepository_;
  OrderRepository OrderRepository_ = RepositoryManager.OrderRepository_;

  double taxAmount = 0.0;
  double deliveryFee = 0.0;
  double subTotal = 0.0;
  double total = 0.0;
  CreditCard creditCard = new CreditCard();
  bool loading = true;
  GlobalKey<ScaffoldState> scaffoldKey;

  CheckoutController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForCreditCard();
  }

  void listenForCreditCard() async {
    creditCard = await UserRepository_.getCreditCard();
    setState(() {});
  }

  @override
  void onLoadingCartDone() {
    if (payment != null) addOrder(carts);
    super.onLoadingCartDone();
  }

  void addOrder(List<Cart> carts) async {

    OrderRepository OrderRepository_ = RepositoryManager.OrderRepository_;
    ComandaRepository ComandaRepository_ = RepositoryManager.ComandaRepository_;

    Order _order = new Order();
    _order.foodOrders = new List<FoodOrder>();
    _order.tax = carts[0].food.restaurant.defaultTax;
    _order.deliveryFee = payment.method == 'Pay on Pickup' ? 0 : carts[0].food.restaurant.deliveryFee;
    OrderStatus _orderStatus = new OrderStatus();
    _orderStatus.id = '1'; // TODO default order status Id
    _order.orderStatus = _orderStatus;
    _order.deliveryAddress = SettingsRepository_.deliveryAddress.value;
    _order.colorCar = ComandaRepository_.VehiculeInformation_.color;
    _order.placesCar = ComandaRepository_.VehiculeInformation_.plates;
    carts.forEach((_cart) {
      FoodOrder _foodOrder = new FoodOrder();
      _foodOrder.quantity = _cart.quantity;
      _foodOrder.price = _cart.food.price;
      _foodOrder.food = _cart.food;
      _foodOrder.extras = _cart.extras;
      _order.foodOrders.add(_foodOrder);
    });
    OrderRepository_.addOrder(_order, this.payment).then((value) {
      if (value is Order) {
        setState(() {
          loading = false;
        });
      }
    });
  }

  void updateCreditCard(CreditCard creditCard) {
    UserRepository_.setCreditCard(creditCard).then((value) {
      setState(() {});
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).payment_card_updated_successfully),
      ));
    });
  }
}
