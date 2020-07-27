import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/CreditCard.dart';
import '../models/User.dart';

import 'package:food_delivery_app/src/repository/RepositoryManager.dart';
import '../repository/UserRepository.dart';

class SettingsController extends ControllerMVC {

  CreditCard creditCard = new CreditCard();
  GlobalKey<FormState> loginFormKey;
  GlobalKey<ScaffoldState> scaffoldKey;

  UserRepository UserRepository_ = RepositoryManager.UserRepository_;

  SettingsController() {
    loginFormKey = new GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void update(User user) async {
    user.deviceToken = null;
    UserRepository_.update(user).then((value) {
      setState(() {});
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).profile_settings_updated_successfully),
      ));
    });
  }

  void updateCreditCard(CreditCard creditCard) {
    UserRepository_.setCreditCard(creditCard).then((value) {
      setState(() {});
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).payment_settings_updated_successfully),
      ));
    });
  }

  void listenForUser() async {
    creditCard = await UserRepository_.getCreditCard();
    setState(() {});
  }

  Future<void> refreshSettings() async {
    creditCard = new CreditCard();
  }
}
