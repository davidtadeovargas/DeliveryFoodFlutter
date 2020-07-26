class Nutrition {

  String id;
  String name;
  double quantity;

  Nutrition();

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}
