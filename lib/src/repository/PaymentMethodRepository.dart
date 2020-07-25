import 'package:flutter/widgets.dart';
import 'package:food_delivery_app/src/models/payment_method.dart';

import '../../generated/l10n.dart';

class PaymentMethodRepository {

  //Singleton
  static final PaymentMethodRepository _singleton = new PaymentMethodRepository._internal();
  PaymentMethodRepository._internal();

  //Flag to determine if the payment mathod lists are already init
  bool initialized = false;

  List<PaymentMethod> _paymentsList;
  List<PaymentMethod> _cashList;
  List<PaymentMethod> _pickupList;

  List<PaymentMethod> get paymentsList => _paymentsList;
  List<PaymentMethod> get cashList => _cashList;
  List<PaymentMethod> get pickupList => _pickupList;



  factory PaymentMethodRepository() {
    return _singleton;
  }

  instance(BuildContext _context){

    //If the payment mathod lists are not already initialized do it
    if(!initialized){

      this._paymentsList = [
        new PaymentMethod("visacard", S.of(_context).visa_card, S.of(_context).click_to_pay_with_your_visa_card, "/Checkout", "assets/img/visacard.png",
            isDefault: true),
        new PaymentMethod("mastercard", S.of(_context).mastercard, S.of(_context).click_to_pay_with_your_mastercard, "/Checkout", "assets/img/mastercard.png"),
        new PaymentMethod("razorpay", S.of(_context).razorpay, S.of(_context).clickToPayWithRazorpayMethod, "/RazorPay", "assets/img/razorpay.png"),
        new PaymentMethod("paypal", S.of(_context).paypal, S.of(_context).click_to_pay_with_your_paypal_account, "/PayPal", "assets/img/paypal.png"),
      ];
      this._cashList = [
        new PaymentMethod("cod", S.of(_context).cash_on_delivery, S.of(_context).click_to_pay_cash_on_delivery, "/CashOnDelivery", "assets/img/cash.png"),
      ];
      this._pickupList = [
        new PaymentMethod("pop", S.of(_context).pay_on_pickup, S.of(_context).click_to_pay_on_pickup, "/PayOnPickup", "assets/img/pay_pickup.png"),
        new PaymentMethod("delivery", S.of(_context).delivery_address, S.of(_context).click_to_pay_on_pickup, "/PaymentMethod", "assets/img/pay_pickup.png"),
      ];
    }

    //Return the current instance
    return _singleton;
  }
}
