import '../helpers/custom_trace.dart';
import '../models/address.dart';
import '../models/FoodOrder.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
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
