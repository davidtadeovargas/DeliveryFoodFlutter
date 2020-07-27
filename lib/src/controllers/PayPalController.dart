import 'package:flutter/material.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../models/Address.dart';

import 'package:food_delivery_app/src/repository/RepositoryManager.dart';
import '../repository/SettingsRepository.dart';
import '../repository/UserRepository.dart';

class PayPalController extends ControllerMVC {

  GlobalKey<ScaffoldState> scaffoldKey;
  InAppWebViewController webView;
  String url = "";
  double progress = 0;
  Address deliveryAddress;

  UserRepository UserRepository_ = RepositoryManager.UserRepository_;
  SettingsRepository SettingsRepository_ = RepositoryManager.SettingsRepository_;

  PayPalController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }
  @override
  void initState() {
    final String _apiToken = 'api_token=${UserRepository_.currentUser.value.apiToken}';
    final String _userId = 'user_id=${UserRepository_.currentUser.value.id}';
    final String _deliveryAddress = 'delivery_address_id=${SettingsRepository_.deliveryAddress.value?.id}';
    url =
        '${GlobalConfiguration().getString('base_url')}payments/paypal/express-checkout?$_apiToken&$_userId&$_deliveryAddress';
    setState(() {});
    super.initState();
  }
}
