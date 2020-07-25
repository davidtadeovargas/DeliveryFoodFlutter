import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/models/VehiculeInformation.dart';
import 'package:food_delivery_app/src/repository/ComandaRepository.dart';
import 'package:food_delivery_app/src/repository/PaymentMethodRepository.dart';

import '../../generated/l10n.dart';
import '../models/address.dart' as model;
import '../models/payment_method.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;
import 'cart_controller.dart';

class DeliveryPickupController extends CartController {

  GlobalKey<ScaffoldState> scaffoldKey;
  model.Address deliveryAddress;
  PaymentMethodRepository PaymentMethodRepository_;
  ComandaRepository ComandaRepository_ = new ComandaRepository();

  DeliveryPickupController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    super.listenForCarts();
    listenForDeliveryAddress();
    print(settingRepo.deliveryAddress.value.toMap());
  }

  void listenForDeliveryAddress() async {
    this.deliveryAddress = settingRepo.deliveryAddress.value;
    print(this.deliveryAddress.id);
  }

  void addAddress(model.Address address) {
    userRepo.addAddress(address).then((value) {
      setState(() {
        settingRepo.deliveryAddress.value = value;
        this.deliveryAddress = value;
      });
    }).whenComplete(() {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).new_address_added_successfully),
      ));
    });
  }

  void updateAddress(model.Address address) {
    userRepo.updateAddress(address).then((value) {
      setState(() {
        settingRepo.deliveryAddress.value = value;
        this.deliveryAddress = value;
      });
    }).whenComplete(() {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).the_address_updated_successfully),
      ));
    });
  }

  PaymentMethod getPickUpMethod() {
    return PaymentMethodRepository_.pickupList.elementAt(0);
  }

  PaymentMethod getDeliveryMethod() {
    return PaymentMethodRepository_.pickupList.elementAt(1);
  }

  void toggleDelivery() {
    PaymentMethodRepository_.pickupList.forEach((element) {
      if (element != getDeliveryMethod()) {
        element.selected = false;
      }
    });
    setState(() {
      getDeliveryMethod().selected = !getDeliveryMethod().selected;
    });
  }

  void togglePickUp() {
    PaymentMethodRepository_.pickupList.forEach((element) {
      if (element != getPickUpMethod()) {
        element.selected = false;
      }
    });
    setState(() {
      getPickUpMethod().selected = !getPickUpMethod().selected;
    });
  }

  PaymentMethod getSelectedMethod() {
    return PaymentMethodRepository_.pickupList.firstWhere((element) => element.selected);
  }

  @override
  void goCheckout(BuildContext context) {

    //If is for pickup
    PaymentMethod selectedMehotd = getSelectedMethod();
    PaymentMethod pickUpMethod = getPickUpMethod();
    if(selectedMehotd==pickUpMethod){

      //If vehicule information is still not filled
      if(ComandaRepository_.VehiculeInformation_==null){
        showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                title: Text(S.of(context).ups),
                content: Text(S.of(context).Please_fill_vehicule_information_first),
                actions:[
                  FlatButton(
                    child: Text(S.of(context).ok),
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            }
        );
        return;
      }
    }

    //Place the order
    //addOrder(Order order, Payment payment);

    Navigator.of(context).pushNamed(selectedMehotd.route);
  }
}
