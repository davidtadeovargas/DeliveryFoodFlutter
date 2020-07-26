class ExtraGroup {

  String id;
  String name;
  bool forzed;

  ExtraGroup();

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}
