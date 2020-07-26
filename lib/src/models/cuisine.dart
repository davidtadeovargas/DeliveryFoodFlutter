import '../models/Media.dart';

class Cuisine {

  String id;
  String name;
  String description;
  Media image;
  bool selected;

  Cuisine();

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => super.hashCode;
}
