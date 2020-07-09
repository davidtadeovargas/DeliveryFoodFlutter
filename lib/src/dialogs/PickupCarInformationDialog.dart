import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/formatters/UpperCaseTextFormatter.dart';
import 'package:food_delivery_app/src/models/VehiculeInformation.dart';

import '../helpers/custom_trace.dart';

class PickupCarInformationDialog  {

  ValueChanged<VehiculeInformation> onResult;
  ValueChanged<VehiculeInformation> onCancel;

  BuildContext context;

  PickupCarInformationDialog({this.onResult, this.onCancel, this.context});

  Future<void> showPickupDialog() async {

    final platesTextEditController = TextEditingController();
    final colorTextEditController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Vehicule information'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: platesTextEditController,
                  decoration: InputDecoration(
                      labelText: 'Enter your plates',
                  ),
                  inputFormatters: [
                    UpperCaseTextFormatter(),
                  ]
                ),
                TextField(
                  controller: colorTextEditController,
                  decoration: InputDecoration(
                      labelText: 'Enter your color car',
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {

                //Get the values
                final plates = platesTextEditController.text;
                final color = colorTextEditController.text;

                //The fields should be filled
                if(plates.isEmpty){
                  return;
                }
                if(color.isEmpty){
                  return;
                }

                //Close the dialog
                Navigator.of(context).pop();

                //Create the result model
                final VehiculeInformation_ = VehiculeInformation();
                VehiculeInformation_.plates = plates;
                VehiculeInformation_.color = color;

                //Callback
                onResult(VehiculeInformation_);
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();

                onCancel(null);
              },
            ),
          ],
        );
      },
    );
  }

  String validateEmpty(String value) {
    if (value.isEmpty) {
      return "Please enter information";
    }
    else{
      return null;
    }
  }
}