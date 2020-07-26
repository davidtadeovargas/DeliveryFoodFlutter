import '../models/User.dart';

class Review {

  String id;
  String review;
  String rate;
  User user;

  Review();
  Review.init(this.rate);

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}
