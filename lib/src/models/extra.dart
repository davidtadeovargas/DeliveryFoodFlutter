import '../models/Media.dart';

class Extra {

  String id;
  String extraGroupId;
  String name;
  double price;
  Media image;
  String description;
  bool checked;

  Extra();

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}
