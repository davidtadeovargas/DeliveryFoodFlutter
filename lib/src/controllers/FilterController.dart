import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/parsers/CuisineJsonParser.dart';
import 'package:food_delivery_app/src/parsers/FilterJsonParser.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../models/Cart.dart';
import '../models/Cuisine.dart';
import '../models/Filter.dart';
import '../repository/CuisineRepository.dart';

class FilterController extends ControllerMVC {

  GlobalKey<ScaffoldState> scaffoldKey;
  List<Cuisine> cuisines = [];
  Filter filter;
  Cart cart;

  CuisineRepository CuisineRepository_ = new CuisineRepository();
  FilterJsonParser FilterJsonParser_ = new FilterJsonParser();
  CuisineJsonParser CuisineJsonParser_ = new CuisineJsonParser();

  FilterController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForFilter().whenComplete(() {
      listenForCuisines();
    });
  }

  Future<void> listenForFilter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      filter = FilterJsonParser_.fromJsonToModel(json.decode(prefs.getString('filter') ?? '{}'));
    });
  }

  Future<void> saveFilter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    filter.cuisines = this.cuisines.where((_f) => _f.selected).toList();
    prefs.setString('filter', json.encode(FilterJsonParser_.fromModeltoMap(filter)));
  }

  void listenForCuisines({String message}) async {
    cuisines.add(CuisineJsonParser_.fromJsonToModel({'id': '0', 'name': S.of(context).all, 'selected': true}));
    final Stream<Cuisine> stream = await CuisineRepository_.getCuisines();
    stream.listen((Cuisine _cuisine) {
      setState(() {
        if (filter.cuisines.contains(_cuisine)) {
          _cuisine.selected = true;
          cuisines.elementAt(0).selected = false;
        }
        cuisines.add(_cuisine);
      });
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  Future<void> refreshCuisines() async {
    cuisines.clear();
    listenForCuisines(message: S.of(context).addresses_refreshed_successfuly);
  }

  void clearFilter() {
    setState(() {
      filter.open = false;
      filter.delivery = false;
      resetCuisines();
    });
  }

  void resetCuisines() {
    filter.cuisines = [];
    cuisines.forEach((Cuisine _f) {
      _f.selected = false;
    });
    cuisines.elementAt(0).selected = true;
  }

  void onChangeCuisinesFilter(int index) {
    if (index == 0) {
      // all
      setState(() {
        resetCuisines();
      });
    } else {
      setState(() {
        cuisines.elementAt(index).selected = !cuisines.elementAt(index).selected;
        cuisines.elementAt(0).selected = false;
      });
    }
  }
}
