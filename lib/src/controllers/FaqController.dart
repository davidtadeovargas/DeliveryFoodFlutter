import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/FaqCategory.dart';

import 'package:food_delivery_app/src/repository/RepositoryManager.dart';
import '../repository/FaqRepository.dart';

class FaqController extends ControllerMVC {

  List<FaqCategory> faqs = <FaqCategory>[];
  GlobalKey<ScaffoldState> scaffoldKey;

  FaqRepository FaqRepository_ = RepositoryManager.FaqRepository_;

  FaqController() {
    scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForFaqs();
  }

  void listenForFaqs({String message}) async {
    final Stream<FaqCategory> stream = await FaqRepository_.getFaqCategories();
    stream.listen((FaqCategory _faq) {
      setState(() {
        faqs.add(_faq);
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

  Future<void> refreshFaqs() async {
    faqs.clear();
    listenForFaqs(message: S.of(context).faqsRefreshedSuccessfuly);
  }
}
