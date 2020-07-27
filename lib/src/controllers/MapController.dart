import 'dart:async';

import 'package:flutter/services.dart';
import 'package:food_delivery_app/src/parsers/AddressJsonParser.dart';
import 'package:food_delivery_app/src/parsers/RestaurantJsonParser.dart';
import 'package:food_delivery_app/src/repository/AddressRepository.dart';
import 'package:food_delivery_app/src/repository/RepositoryManager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../helpers/app_config.dart' as config;
import '../helpers/helper.dart';
import '../helpers/maps_util.dart';
import '../models/Address.dart';
import '../models/Restaurant.dart';
import '../repository/RestaurantRepository.dart';
import '../repository/SettingsRepository.dart';

class MapController extends ControllerMVC {

  Restaurant currentRestaurant;
  List<Restaurant> topRestaurants = <Restaurant>[];
  List<Marker> allMarkers = <Marker>[];
  Address currentAddress;
  Set<Polyline> polylines = new Set();
  CameraPosition cameraPosition;
  MapsUtil mapsUtil = new MapsUtil();
  Completer<GoogleMapController> mapController = Completer();

  SettingsRepository SettingsRepository_ = RepositoryManager.SettingsRepository_;
  RestaurantRepository RestaurantRepository_ = RepositoryManager.RestaurantRepository_;
  AddressRepository AddressRepository_ = RepositoryManager.AddressRepository_;

  RestaurantJsonParser RestaurantJsonParser_ = RestaurantJsonParser();
  AddressJsonParser AddressJsonParser_ = AddressJsonParser();

  void listenForNearRestaurants(Address myLocation, Address areaLocation) async {
    final Stream<Restaurant> stream = await RestaurantRepository_.getNearRestaurants(myLocation, areaLocation);
    stream.listen((Restaurant _restaurant) {
      setState(() {
        topRestaurants.add(_restaurant);
      });
      Helper.getMarker(RestaurantJsonParser_.fromModeltoMap(_restaurant)).then((marker) {
        setState(() {
          allMarkers.add(marker);
        });
      });
    }, onError: (a) {}, onDone: () {});
  }

  void getCurrentLocation() async {
    try {
      currentAddress = SettingsRepository_.deliveryAddress.value;
      setState(() {
        if (AddressRepository_.isUnknown(currentAddress)) {
          cameraPosition = CameraPosition(
            target: LatLng(40, 3),
            zoom: 4,
          );
        } else {
          cameraPosition = CameraPosition(
            target: LatLng(currentAddress.latitude, currentAddress.longitude),
            zoom: 14.4746,
          );
        }
      });
      if (!AddressRepository_.isUnknown(currentAddress)) {
        Helper.getMyPositionMarker(currentAddress.latitude, currentAddress.longitude).then((marker) {
          setState(() {
            allMarkers.add(marker);
          });
        });
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
    }
  }

  void getRestaurantLocation() async {
    try {
      currentAddress = await SettingsRepository_.getCurrentLocation();
      setState(() {
        cameraPosition = CameraPosition(
          target: LatLng(double.parse(currentRestaurant.latitude), double.parse(currentRestaurant.longitude)),
          zoom: 14.4746,
        );
      });
      Helper.getMyPositionMarker(currentAddress.latitude, currentAddress.longitude).then((marker) {
        setState(() {
          allMarkers.add(marker);
        });
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
    }
  }

  Future<void> goCurrentLocation() async {
    final GoogleMapController controller = await mapController.future;

    SettingsRepository_.setCurrentLocation().then((_currentAddress) {
      setState(() {
        SettingsRepository_.deliveryAddress.value = _currentAddress;
        currentAddress = _currentAddress;
      });
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(_currentAddress.latitude, _currentAddress.longitude),
        zoom: 14.4746,
      )));
    });
  }

  void getRestaurantsOfArea() async {
    setState(() {
      topRestaurants = <Restaurant>[];
      Address areaAddress = AddressJsonParser_.fromJsonToModel({"latitude": cameraPosition.target.latitude, "longitude": cameraPosition.target.longitude});
      if (cameraPosition != null) {
        listenForNearRestaurants(currentAddress, areaAddress);
      } else {
        listenForNearRestaurants(currentAddress, currentAddress);
      }
    });
  }

  void getDirectionSteps() async {
    currentAddress = await SettingsRepository_.getCurrentLocation();
    mapsUtil
        .get("origin=" +
            currentAddress.latitude.toString() +
            "," +
            currentAddress.longitude.toString() +
            "&destination=" +
            currentRestaurant.latitude +
            "," +
            currentRestaurant.longitude +
            "&key=${SettingsRepository_.setting.value?.googleMapsKey}")
        .then((dynamic res) {
      if (res != null) {
        List<LatLng> _latLng = res as List<LatLng>;
        _latLng?.insert(0, new LatLng(currentAddress.latitude, currentAddress.longitude));
        setState(() {
          polylines.add(new Polyline(
              visible: true, polylineId: new PolylineId(currentAddress.hashCode.toString()), points: _latLng, color: config.Colors().mainColor(0.8), width: 6));
        });
      }
    });
  }

  Future refreshMap() async {
    setState(() {
      topRestaurants = <Restaurant>[];
    });
    listenForNearRestaurants(currentAddress, currentAddress);
  }
}
