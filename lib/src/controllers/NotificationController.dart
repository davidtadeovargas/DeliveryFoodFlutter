import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';

import '../models/Notification.dart' as NotificationL;
import 'package:food_delivery_app/src/repository/RepositoryManager.dart';
import '../repository/NotificationRepository.dart';

class NotificationController extends ControllerMVC {

  List<NotificationL.Notification> notifications = <NotificationL.Notification>[];
  GlobalKey<ScaffoldState> scaffoldKey;

  NotificationRepository NotificationRepository_ = RepositoryManager.NotificationRepository_;

  NotificationController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForNotifications();
  }

  void listenForNotifications({String message}) async {
    final Stream<NotificationL.Notification> stream = await NotificationRepository_.getNotifications();
    stream.listen((NotificationL.Notification _notification) {
      setState(() {
        notifications.add(_notification);
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

  Future<void> refreshNotifications() async {
    notifications.clear();
    listenForNotifications(message: S.of(context).notifications_refreshed_successfuly);
  }
}
