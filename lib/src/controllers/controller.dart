import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../repository/SettingsRepository.dart';
import '../repository/UserRepository.dart';

class Controller extends AppConMVC {

  GlobalKey<ScaffoldState> scaffoldKey;
  SettingsRepository SettingsRepository_ = new SettingsRepository();
  UserRepository UserRepository_ = new UserRepository();

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
