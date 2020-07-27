import 'package:food_delivery_app/src/models/Address.dart';
import 'package:location/location.dart';

class AddressRepository{

  bool isUnknown(Address Address_) {
    return Address_.latitude == null || Address_.longitude == null;
  }

  LocationData toLocationData(Address Address_) {
    return LocationData.fromMap({
      "latitude": Address_.latitude,
      "longitude": Address_.longitude,
    });
  }
}