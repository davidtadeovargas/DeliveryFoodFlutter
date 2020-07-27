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

  RadioButtonWidget({
    Key key,
    this.extra,
    this.onChanged,
    this.showPrice,
    this.FoodController_,
    this.extraIndex
  }) : super(key: key);

  @override
  _RadioButtonWidgetState createState() => _RadioButtonWidgetState();
}

class _RadioButtonWidgetState extends State<RadioButtonWidget> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => onBuildComplete(context));
  }

  void onBuildComplete(BuildContext BuildContext_){
    widget.FoodController_.calculateTotal();
  }

  void changedRadioButton(Extra Extra_){

    if (Extra_.checked) {
      Extra_.checked = false;
    } else {
      Extra_.checked = true;

      //The previous extra model is not checked anymore
      if(widget.FoodController_.ExtraPrevious!=null){
        widget.FoodController_.ExtraPrevious.checked = false;
      }

      //Save the previous extra model
      widget.FoodController_.ExtraPrevious = Extra_;
    }

    widget.FoodController_.radioButtonGroupValue = Extra_.id;

    widget.onChanged();
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
              value: widget.extra.id,
              groupValue: widget.FoodController_.radioButtonGroupValue,
              onChanged: (Object extraIndex) {

                Extra Extra_ = widget.FoodController_.food.extras.where((extra) => extra.extraGroupId == widget.extra.extraGroupId).elementAt(widget.extraIndex);

                changedRadioButton(Extra_);
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
