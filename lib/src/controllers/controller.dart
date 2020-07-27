import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../repository/SettingsRepository.dart';

import 'package:food_delivery_app/src/repository/RepositoryManager.dart';
import '../repository/UserRepository.dart';

class Controller extends AppConMVC {

  GlobalKey<ScaffoldState> scaffoldKey;
  SettingsRepository SettingsRepository_ = RepositoryManager.SettingsRepository_;
  UserRepository UserRepository_ = RepositoryManager.UserRepository_;

  Controller() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  @override
  void initState() {
    SettingsRepository_.initSettings();
    SettingsRepository_.getCurrentLocation();
    UserRepository_.getCurrentUser();
    super.initState();
  }
}
