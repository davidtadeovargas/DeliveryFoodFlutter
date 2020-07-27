import 'dart:ui';

import 'package:food_delivery_app/src/models/Setting.dart';

import 'IBaseParser.dart';


class SettingsJsonParser implements IBaseParser {

  @override
  Object fromJsonToModel(Map<String, dynamic> jsonMap) {

    Setting Setting_ = new Setting();

    Setting_.appName = jsonMap['app_name'] ?? null;
    Setting_.mainColor = jsonMap['main_color'] ?? null;
    Setting_.mainDarkColor = jsonMap['main_dark_color'] ?? '';
    Setting_.secondColor = jsonMap['second_color'] ?? '';
    Setting_.secondDarkColor = jsonMap['second_dark_color'] ?? '';
    Setting_.accentColor = jsonMap['accent_color'] ?? '';
    Setting_.accentDarkColor = jsonMap['accent_dark_color'] ?? '';
    Setting_.scaffoldDarkColor = jsonMap['scaffold_dark_color'] ?? '';
    Setting_.scaffoldColor = jsonMap['scaffold_color'] ?? '';
    Setting_.googleMapsKey = jsonMap['google_maps_key'] ?? null;
    Setting_.mobileLanguage.value = Locale(jsonMap['mobile_language'] ?? "en", '');
    Setting_.appVersion = jsonMap['app_version'] ?? '';
    Setting_.distanceUnit = jsonMap['distance_unit'] ?? 'km';
    Setting_.enableVersion = jsonMap['enable_version'] == null || jsonMap['enable_version'] == '0' ? false : true;
    Setting_.defaultTax = double.tryParse(jsonMap['default_tax']) ?? 0.0; //double.parse(jsonMap['default_tax'].toString());
    Setting_.defaultCurrency = jsonMap['default_currency'] ?? '';
    Setting_.currencyDecimalDigits = int.tryParse(jsonMap['default_currency_decimal_digits']) ?? 2;
    Setting_.currencyRight = jsonMap['currency_right'] == null || jsonMap['currency_right'] == '0' ? false : true;
    Setting_.payPalEnabled = jsonMap['enable_paypal'] == null || jsonMap['enable_paypal'] == '0' ? false : true;
    Setting_.stripeEnabled = jsonMap['enable_stripe'] == null || jsonMap['enable_stripe'] == '0' ? false : true;
    Setting_.razorPayEnabled = jsonMap['enable_razorpay'] == null || jsonMap['enable_razorpay'] == '0' ? false : true;

    return Setting_;
  }

  @override
  Map fromModeltoMap(Object Object) {

    //Cast the model
    Setting Setting_ = Object;

    var map = new Map<String, dynamic>();

    map["app_name"] = Setting_.appName;
    map["default_tax"] = Setting_.defaultTax;
    map["default_currency"] = Setting_.defaultCurrency;
    map["default_currency_decimal_digits"] = Setting_.currencyDecimalDigits;
    map["currency_right"] = Setting_.currencyRight;
    map["enable_paypal"] = Setting_.payPalEnabled;
    map["enable_stripe"] = Setting_.stripeEnabled;
    map["enable_razorpay"] = Setting_.razorPayEnabled;
    map["mobile_language"] = Setting_.mobileLanguage.value.languageCode;

    return map;
  }

  @override
  String mapToString(Object Object) {
    throw UnimplementedError();
  }
}