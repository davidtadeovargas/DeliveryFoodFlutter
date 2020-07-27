import '../models/Address.dart';
import '../models/FoodOrder.dart';
import '../models/OrderStatus.dart';
import '../models/Payment.dart';
import '../models/User.dart';

class Order {

  String id;
  List<FoodOrder> foodOrders;
  OrderStatus orderStatus;
  double tax;
  double deliveryFee;
  String hint;
  bool active;
  DateTime dateTime;
  User user;
  Payment payment;
  Address deliveryAddress;
  String placesCar;
  String colorCar;

  Order();
}
