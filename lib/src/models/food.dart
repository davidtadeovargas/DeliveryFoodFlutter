import '../helpers/custom_trace.dart';
import '../models/Category.dart';
import '../models/Extra.dart';
import '../models/ExtraGroup.dart';
import '../models/Media.dart';
import '../models/Nutrition.dart';
import '../models/Restaurant.dart';
import '../models/Review.dart';

class Food {

  String id;
  String name;
  double price;
  double discountPrice;
  Media image;
  String description;
  String ingredients;
  String weight;
  String unit;
  String packageItemsCount;
  bool featured;
  bool deliverable;
  Restaurant restaurant;
  Category category;
  List<Extra> extras;
  List<ExtraGroup> extraGroups;
  List<Review> foodReviews;
  List<Nutrition> nutritions;

  Food();

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}
