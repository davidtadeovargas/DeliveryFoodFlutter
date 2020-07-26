import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class WalkthroughWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new WalkthroughWidget(),
    );
  }
}

class WalkthroughWidgetStateful extends StatefulWidget {
  WalkthroughWidgetStateful({
    Key key,
  }) : super(key: key);

  @override
  _WalkthroughWidgetState createState() => _WalkthroughWidgetState();
}

class _WalkthroughWidgetState extends StateMVC<WalkthroughWidgetStateful> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
