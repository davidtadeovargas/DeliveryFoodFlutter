import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/repository/SettingsRepository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/HomeController.dart';
import '../elements/CardsCarouselWidget.dart';
import '../elements/CaregoriesCarouselWidget.dart';
import '../elements/DeliveryAddressBottomSheetWidget.dart';
import '../elements/FoodsCarouselWidget.dart';
import '../elements/GridWidget.dart';
import '../elements/ReviewsListWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../repository/SettingsRepository.dart';
import '../repository/UserRepository.dart';

class HomeWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  HomeWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends StateMVC<HomeWidget> {

  HomeController _con;
  SettingsRepository SettingsRepository_ = new SettingsRepository();
  UserRepository UserRepository_ = new UserRepository();

  _HomeWidgetState() : super(HomeController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: ValueListenableBuilder(
          valueListenable: SettingsRepository_.setting,
          builder: (context, value, child) {
            return Text(
              value.appName ?? S.of(context).home,
              style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
            );
          },
        ),
//        title: Text(
//          settingsRepo.setting?.value.appName ?? S.of(context).home,
//          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
//        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _con.refreshHome,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SearchBarWidget(
                  onClickFilter: (event) {
                    widget.parentScaffoldKey.currentState.openEndDrawer();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    Icons.stars,
                    color: Theme.of(context).hintColor,
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      if (UserRepository_.currentUser.value.apiToken == null) {
                        _con.requestForCurrentLocation(context);
                      } else {
                        var bottomSheetController = widget.parentScaffoldKey.currentState.showBottomSheet(
                          (context) => DeliveryAddressBottomSheetWidget(scaffoldKey: widget.parentScaffoldKey),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                          ),
                        );
                        bottomSheetController.closed.then((value) {
                          _con.refreshHome();
                        });
                      }
                    },
                    icon: Icon(
                      Icons.my_location,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  title: Text(
                    S.of(context).top_restaurants,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  subtitle: Text(
                    S.of(context).near_to + " " + (SettingsRepository_.deliveryAddress.value?.address ?? S.of(context).unknown),
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ),
              CardsCarouselWidget(restaurantsList: _con.topRestaurants, heroTag: 'home_top_restaurants'),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                leading: Icon(
                  Icons.trending_up,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  S.of(context).trending_this_week,
                  style: Theme.of(context).textTheme.headline4,
                ),
                subtitle: Text(
                  S.of(context).clickOnTheFoodToGetMoreDetailsAboutIt,
                  style: Theme.of(context).textTheme.caption.merge(TextStyle(fontSize: 11)),
                ),
              ),
              FoodsCarouselWidget(foodsList: _con.trendingFoods, heroTag: 'home_food_carousel'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    Icons.category,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    S.of(context).food_categories,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
              CategoriesCarouselWidget(
                categories: _con.categories,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    Icons.trending_up,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    S.of(context).most_popular,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridWidget(
                  restaurantsList: _con.popularRestaurants,
                  heroTag: 'home_restaurants',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 20),
                  leading: Icon(
                    Icons.recent_actors,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    S.of(context).recent_reviews,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ReviewsListWidget(reviewsList: _con.recentReviews),
              ),
            ],
          ),
        ),
      ),
    );
  }
}