import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/src/repository/RepositoryManager.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../helpers/custom_trace.dart';
import '../repository/SettingsRepository.dart';
import '../repository/UserRepository.dart';

class SplashScreenController extends ControllerMVC {

  ValueNotifier<Map<String, double>> progress = new ValueNotifier(new Map());
  GlobalKey<ScaffoldState> scaffoldKey;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  UserRepository UserRepository_ = RepositoryManager.UserRepository_;
  SettingsRepository SettingsRepository_ = RepositoryManager.SettingsRepository_;

  SplashScreenController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    // Should define these variables before the app loaded
    progress.value = {"Setting": 0, "User": 0};
  }

  @override
  void initState() {
    super.initState();
    firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));
    configureFirebase(firebaseMessaging);
    SettingsRepository_.setting.addListener(() {
      if (SettingsRepository_.setting.value.appName != null && SettingsRepository_.setting.value.appName != '' && SettingsRepository_.setting.value.mainColor != null) {
        progress.value["Setting"] = 41;
        // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
        progress?.notifyListeners();
      }
    });
    UserRepository_.currentUser.addListener(() {
      if (UserRepository_.currentUser.value.auth != null) {
        progress.value["User"] = 59;
        progress?.notifyListeners();
      }
    });
    Timer(Duration(seconds: 20), () {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    });
  }

  void configureFirebase(FirebaseMessaging _firebaseMessaging) {
    try {
      _firebaseMessaging.configure(
        onMessage: notificationOnMessage,
        onLaunch: notificationOnLaunch,
        onResume: notificationOnResume,
      );
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e));
      print(CustomTrace(StackTrace.current, message: 'Error Config Firebase'));
    }
  }

  Future notificationOnResume(Map<String, dynamic> message) async {
    print(CustomTrace(StackTrace.current, message: message['data']['id']));
    try {
      if (message['data']['id'] == "orders") {
        SettingsRepository_.navigatorKey.currentState.pushReplacementNamed('/Pages', arguments: 3);
      }
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e));
    }
  }

  Future notificationOnLaunch(Map<String, dynamic> message) async {
    String messageId = await SettingsRepository_.getMessageId();
    try {
      if (messageId != message['google.message_id']) {
        if (message['data']['id'] == "orders") {
          await SettingsRepository_.saveMessageId(message['google.message_id']);
          SettingsRepository_.navigatorKey.currentState.pushReplacementNamed('/Pages', arguments: 3);
        }
      }
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e));
    }
  }

  Future notificationOnMessage(Map<String, dynamic> message) async {
    Fluttertoast.showToast(
      msg: message['notification']['title'],
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 5,
    );
  }
}
