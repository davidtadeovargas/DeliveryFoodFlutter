import '../helpers/custom_trace.dart';

class ExtraGroup {
  String id;
  String name;
  bool forzed;

  ExtraGroup();

  ExtraGroup.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      int forzed_ = jsonMap['forzed'];
      forzed = forzed_==1;
    } catch (e) {
      id = '';
      name = '';
      forzed = false;
      print(CustomTrace(StackTrace.current, message: e));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    return map;
  }

  @override
  String toString() {
    return this.toMap().toString();
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}
