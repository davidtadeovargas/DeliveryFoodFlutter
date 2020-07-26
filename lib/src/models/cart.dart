import '../models/Extra.dart';
import '../models/Food.dart';

class Cart {

  String id;
  Food food;
  double quantity;
  List<Extra> extras;
  Extra extraBase;
  String userId;

  Cart();

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => super.hashCode;
}
