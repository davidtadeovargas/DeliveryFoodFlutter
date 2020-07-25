import 'package:food_delivery_app/src/models/VehiculeInformation.dart';

class ComandaRepository {

  //Singleton
  static final ComandaRepository _singleton = new ComandaRepository._internal();
  ComandaRepository._internal();

  VehiculeInformation VehiculeInformation_;



  //Singleton
  factory ComandaRepository() {
    return _singleton;
  }
}
