import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../controllers/restaurant_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/DrawerWidget.dart';
import '../elements/FoodItemWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';

import '../models/category.dart';
import '../models/route_argument.dart';

class MenuWidget extends StatefulWidget {
  @override
  _MenuWidgetState createState() => _MenuWidgetState();
  final RouteArgument routeArgument;

  MenuWidget({Key key, this.routeArgument}) : super(key: key);
}
  String idSeleccionado = "3";
class _MenuWidgetState extends StateMVC<MenuWidget> {
  RestaurantController _con;

  _MenuWidgetState() : super(RestaurantController()) {
    _con = controller;
  }

 
  @override
  void initState() {
    _con.listenForCategories();
    _con.listenForFoodsCategory(idSeleccionado);
    _con.listenForFoods(widget.routeArgument.id);
    _con.listenForTrendingFoods(widget.routeArgument.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final  categorias = _con.categories;
    idSeleccionado = _con.selectedCategory;
    
    return Scaffold(
      key: _con.scaffoldKey,
      drawer: DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _con.foods.isNotEmpty ? _con.foods[0].restaurant.name : '',
          overflow: TextOverflow.fade,
          softWrap: false,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 0)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _ListaCategorias(categorias, _con),
              ),
            _con.getArticulosCategoriaSeleccionada.isEmpty
                ? CircularLoadingWidget(height: 250)
                : ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: _con.getArticulosCategoriaSeleccionada.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 10);
                    },
                    itemBuilder: (context, index) {
                      return FoodItemWidget(
                        heroTag: 'menu_list',
                        food: _con.getArticulosCategoriaSeleccionada.elementAt(index),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

class _ListaCategorias extends StatelessWidget {
  final List<Category> categoria;
  final RestaurantController con;
  const _ListaCategorias(this.categoria, this.con);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: categoria.length,
        itemBuilder: (BuildContext context, int index){
          final name = categoria[index].name;
          return Padding(
            padding: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  _CategoriaButton(categoria[index], con),
                  SizedBox(height: 5),
                  Text( '${name[0].toUpperCase()}${name.substring(1)}')
                ],
            ),
          );
        }
        ),
    );
  }
}

class _CategoriaButton extends StatelessWidget {
final Category categoria;
final RestaurantController con;
const _CategoriaButton(this.categoria, this.con);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        con.selectedCategory = categoria.id;       
      },
        child: Container(
        margin: EdgeInsets.symmetric(horizontal:10),
        height: 60,
        width:  60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: (con.selectedCategory  == categoria.id ) 
          ? Colors.green
          : Theme.of(context).accentColor 
           
        ),
        child: Padding(
                padding: const EdgeInsets.all(15),
                child: categoria.image.url.toLowerCase().endsWith('.svg')
                    ? SvgPicture.network(
                        categoria.image.url,
                      )
                    : CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: categoria.image.icon,
                        placeholder: (context, url) => Image.asset(
                          'assets/img/loading.gif',
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
              ),
      ),
    );
  }
}
