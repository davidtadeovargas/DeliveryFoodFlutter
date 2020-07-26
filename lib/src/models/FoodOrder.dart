import '../models/Extra.dart';
import '../models/Food.dart';

class FoodOrder {

  String id;
  double price;
  double quantity;
  List<Extra> extras;
  Food food;
  DateTime dateTime;
  FoodOrder();
}
