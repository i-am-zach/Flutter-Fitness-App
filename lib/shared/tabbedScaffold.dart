import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TabbedScaffold extends StatelessWidget {
  Widget body;

  TabbedScaffold({this.body});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            bottom: TabBar(
          tabs: <Widget>[
            Tab(icon: Icon(Icons.directions_car)),
            Tab(icon: Icon(Icons.directions_boat)),
            Tab(icon: Icon(Icons.directions_bike)),
          ],
        )),
        body: body,
      ),
    );
  }
}
