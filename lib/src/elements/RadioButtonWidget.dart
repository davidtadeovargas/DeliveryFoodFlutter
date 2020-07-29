import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/controllers/FoodController.dart';

import '../helpers/helper.dart';
import '../models/Extra.dart';

class RadioButtonWidget extends StatefulWidget {

  final Extra extra;
  final VoidCallback onChanged;
  final bool showPrice;
  final FoodController FoodController_;
  int extraIndex;
  final HashMap radioButtonsGroupValues;
  Extra ExtraPrevious;
  final HashMap radioButtonsExtraPrevValues;

  RadioButtonWidget({
    Key key,
    this.extra,
    this.onChanged,
    this.showPrice,
    this.FoodController_,
    this.extraIndex,
    this.radioButtonsGroupValues,
    this.ExtraPrevious,
    this.radioButtonsExtraPrevValues
  }) : super(key: key);

  @override
  _RadioButtonWidgetState createState() => _RadioButtonWidgetState();
}

class _RadioButtonWidgetState extends State<RadioButtonWidget> with SingleTickerProviderStateMixin {

  Extra extraMutable;

  @override
  void initState() {
    super.initState();

    extraMutable = widget.extra;

    WidgetsBinding.instance.addPostFrameCallback((_) => onBuildComplete(context));
  }

  void onBuildComplete(BuildContext BuildContext_){
    widget.FoodController_.calculateTotal();
  }

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {

      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Radio(
              value: extraMutable.id,
              groupValue: widget.radioButtonsGroupValues[extraMutable.extraGroupId],
              onChanged: (Object extraid) {

                Extra Extra_ = widget.FoodController_.food.extras.where((extra) => extra.extraGroupId == widget.extra.extraGroupId).elementAt(widget.extraIndex);

                setState(() {

                  if (Extra_.checked) {
                    Extra_.checked = false;
                  } else {
                    Extra_.checked = true;

                    Extra ExtraPrevious = widget.radioButtonsExtraPrevValues[widget.extra.extraGroupId];

                    //The previous extra model is not checked anymore
                    if(ExtraPrevious!=null){
                      ExtraPrevious.checked = false;
                    }

                    //Save the previous extra model
                    widget.radioButtonsExtraPrevValues[widget.extra.extraGroupId] = Extra_;
                  }

                  widget.radioButtonsGroupValues[extraMutable.extraGroupId] = extraid;

                  });

                widget.onChanged();
              }
          ),
          SizedBox(width: 15),
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.extra?.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Text(
                        Helper.skipHtml(widget.extra.description),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                widget.showPrice ? Helper.getPrice(widget.extra.price, context, style: Theme.of(context).textTheme.headline4):SizedBox(width: 8),
              ],
            ),
          )
        ],
      ),
    );
  }
}
