import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Align(
                alignment: Alignment.center,
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Image(
                    image: AssetImage("assets/images/logo-lg.png"),
                  ),
                )),
          ),
          Positioned.fill(
            child: Container(
                margin: EdgeInsets.only(bottom: 30),
                alignment: Alignment.bottomCenter,
                child: Text("Loading your app...")),
          ),
        ],
      )),
    );
  }
}
