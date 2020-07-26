import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/controllers/FoodController.dart';

import '../helpers/helper.dart';
import '../models/Extra.dart';

class ExtraItemWidget extends StatefulWidget {
  final Extra extra;
  final VoidCallback onChanged;
  final bool showPrice;
  final bool onlyOneSelection;
  final FoodController FoodController_;

  ExtraItemWidget({
    Key key,
    this.extra,
    this.onChanged,
    this.showPrice,
    this.onlyOneSelection,
    this.FoodController_,
  }) : super(key: key);

  @override
  _ExtraItemWidgetState createState() => _ExtraItemWidgetState();
}

class _ExtraItemWidgetState extends State<ExtraItemWidget> with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;
  Animation<double> sizeCheckAnimation;
  Animation<double> rotateCheckAnimation;
  Animation<double> opacityAnimation;
  Animation opacityCheckAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: Duration(milliseconds: 350), vsync: this);
    CurvedAnimation curve = CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    animation = Tween(begin: 0.0, end: 60.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    opacityAnimation = Tween(begin: 0.0, end: 0.5).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    opacityCheckAnimation = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    rotateCheckAnimation = Tween(begin: 2.0, end: 0.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    sizeCheckAnimation = Tween<double>(begin: 0, end: 36).animate(curve)
      ..addListener(() {
        setState(() {});
      });

    if(widget.FoodController_.firstExtra){
      _forward();
      widget.FoodController_.firstExtra = false;
    }
  }

  void _reverse(){

    bool rev = false;
    if(widget.onlyOneSelection){

      if(widget.FoodController_.previousAnimationController!=animationController){
        widget.FoodController_.resetExtracount();
        rev = true;
      }
    }
    else{
      rev = true;
    }

    if(rev){
      animationController.reverse();
      widget.extra.checked = false;
    }
  }

  void _forward(){

    animationController.forward();
    widget.extra.checked = true;

    if(widget.onlyOneSelection) {
      if (widget.FoodController_.getExtracount() == 2) {
        widget.FoodController_.previousAnimationController.reverse();
        widget.FoodController_.extra.checked = false;
        widget.FoodController_.previousAnimationController = null;
      }
      else {
        widget.FoodController_.addExtracount();
      }

      if(widget.FoodController_.previousAnimationController==null){
        widget.FoodController_.previousAnimationController = animationController;
        widget.FoodController_.extra = widget.extra;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

        if (widget.extra.checked) {

          _reverse();

        } else {

          _forward();
        }

        widget.onChanged();

      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                  image: DecorationImage(image: NetworkImage(widget.extra.image?.thumb), fit: BoxFit.cover),
                ),
              ),
              Container(
                height: animation.value,
                width: animation.value,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                  color: Theme.of(context).accentColor.withOpacity(opacityAnimation.value),
                ),
                child: Transform.rotate(
                  angle: rotateCheckAnimation.value,
                  child: Icon(
                    Icons.check,
                    size: sizeCheckAnimation.value,
                    color: Theme.of(context).primaryColor.withOpacity(opacityCheckAnimation.value),
                  ),
                ),
              ),
            ],
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
