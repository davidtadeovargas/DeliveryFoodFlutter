import '../models/Media.dart';

class User {

  String id;
  String name;
  String email;
  String password;
  String apiToken;
  String deviceToken;
  String phone;
  String address;
  String bio;
  Media image;

  // used for indicate if client logged in or not
  bool auth;

//  String role;

  User();
}
