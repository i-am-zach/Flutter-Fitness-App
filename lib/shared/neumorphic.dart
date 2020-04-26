import 'package:flutter/material.dart';

class NeumorphicGlobal {
  static final Color background = Color(0XFFEFF3F6);
  static final Color darker = Color.fromRGBO(0, 0, 0, 0.2);
  static final Color lighter = Color.fromRGBO(255, 255, 255, 0.9);
}

class NeumorphicCard extends StatelessWidget {
  Widget child;
  BoxConstraints contraints;
  EdgeInsets margin;
  EdgeInsets padding;
  BorderRadius borderRadius;

  NeumorphicCard(
      {@required this.child,
      this.contraints,
      this.margin,
      this.padding,
      this.borderRadius});

  BoxDecoration baseDecoration(BorderRadius borderRadius) => BoxDecoration(
          color: NeumorphicGlobal.background,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
                offset: Offset(6, 2),
                blurRadius: 4.0,
                spreadRadius: 3.0,
                color: NeumorphicGlobal.darker),
            BoxShadow(
                offset: Offset(-6, -2),
                blurRadius: 4.0,
                spreadRadius: 3.0,
                color: NeumorphicGlobal.lighter),
          ]);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: baseDecoration(borderRadius),
      constraints: contraints,
      child: child,
    );
  }
}

class NeumorphicButton extends StatefulWidget {
  Widget text;
  Function onTap;
  BoxConstraints constraints;

  NeumorphicButton(
      {@required this.text, @required this.onTap, this.constraints});

  @override
  _NeumorphicButtonState createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool pressed;

  final BoxDecoration baseDecoration = BoxDecoration(
      color: NeumorphicGlobal.background,
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
            offset: Offset(6, 2),
            blurRadius: 4.0,
            spreadRadius: 3.0,
            color: NeumorphicGlobal.darker),
        BoxShadow(
            offset: Offset(-6, -2),
            blurRadius: 4.0,
            spreadRadius: 3.0,
            color: NeumorphicGlobal.lighter),
      ]);
  final BoxDecoration pressDecoration = BoxDecoration(
    color: NeumorphicGlobal.background,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      pressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          pressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          pressed = false;
        });
      },
      onTap: widget.onTap,
      child: Container(
          constraints: widget.constraints,
          padding: EdgeInsets.all(16.0),
          alignment: Alignment.center,
          decoration: pressed ? pressDecoration : baseDecoration,
          child: widget.text),
    );
  }
}
