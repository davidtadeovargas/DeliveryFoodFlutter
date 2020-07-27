import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../elements/PaymentMethodListItemWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../models/RouteArgument.dart';

import 'package:food_delivery_app/src/repository/RepositoryManager.dart';
import '../repository/SettingsRepository.dart';
import 'package:food_delivery_app/src/repository/PaymentMethodRepository.dart';

class PaymentMethodsWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  PaymentMethodsWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _PaymentMethodsWidgetState createState() => _PaymentMethodsWidgetState();
}

class _PaymentMethodsWidgetState extends State<PaymentMethodsWidget> {

  PaymentMethodRepository PaymentMethodRepository_ = RepositoryManager.PaymentMethodRepository_;
  SettingsRepository SettingsRepository_ = RepositoryManager.SettingsRepository_;

  @override
  Widget build(BuildContext context) {

    if (!SettingsRepository_.setting.value.payPalEnabled)
      PaymentMethodRepository_.paymentsList.removeWhere((element) {
        return element.id == "paypal";
      });
    if (!SettingsRepository_.setting.value.razorPayEnabled)
      PaymentMethodRepository_.paymentsList.removeWhere((element) {
        return element.id == "razorpay";
      });
    if (!SettingsRepository_.setting.value.stripeEnabled)
      PaymentMethodRepository_.paymentsList.removeWhere((element) {
        return element.id == "visacard" || element.id == "mastercard";
      });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).payment_mode,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SearchBarWidget(),
            ),
            SizedBox(height: 15),
            PaymentMethodRepository_.paymentsList.length > 0
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      leading: Icon(
                        Icons.payment,
                        color: Theme.of(context).hintColor,
                      ),
                      title: Text(
                        S.of(context).payment_options,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      subtitle: Text(S.of(context).select_your_preferred_payment_mode),
                    ),
                  )
                : SizedBox(
                    height: 0,
                  ),
            SizedBox(height: 10),
            ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: PaymentMethodRepository_.paymentsList.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                return PaymentMethodListItemWidget(paymentMethod: PaymentMethodRepository_.paymentsList.elementAt(index));
              },
            ),
            PaymentMethodRepository_.cashList.length > 0
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      leading: Icon(
                        Icons.monetization_on,
                        color: Theme.of(context).hintColor,
                      ),
                      title: Text(
                        S.of(context).cash_on_delivery,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      subtitle: Text(S.of(context).select_your_preferred_payment_mode),
                    ),
                  )
                : SizedBox(
                    height: 0,
                  ),
            ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: PaymentMethodRepository_.cashList.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                return PaymentMethodListItemWidget(paymentMethod: PaymentMethodRepository_.cashList.elementAt(index));
              },
            ),
          ],
        ),
      ),
    );
  }
}
