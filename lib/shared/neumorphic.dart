import 'package:flutter/material.dart';

class NeumorphicGlobal {
  static final Color background = Color(0XFFEFF3F6);
  static final Color darker = Color.fromRGBO(0, 0, 0, 0.2);
  static final Color lighter = Color.fromRGBO(255, 255, 255, 0.9);
}

class NeumorphicData {
  static const defaultNeumorphicColorData = const NeumorphicColorData(
    background: const Color(0XFFEFF3F6),
    lighter: const Color.fromRGBO(255, 255, 255, 0.9),
    darker: const Color.fromRGBO(0, 0, 0, 0.1),
  );

  final BoxConstraints contraints;
  final NeumorphicColorData neumorphicColorData;
  final BorderRadius borderRadius;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final int level;

  const NeumorphicData(
      {this.contraints,
      this.neumorphicColorData = defaultNeumorphicColorData,
      this.borderRadius,
      this.margin,
      this.padding,
      this.level = 5});
}

class NeumorphicColorData {
  final Color lighter;
  final Color darker;
  final Color background;

  const NeumorphicColorData({this.lighter, this.darker, this.background});
}

class NeumorphicCard extends StatelessWidget {
  static const NeumorphicData defaultNeumorphicData = const NeumorphicData();

  final Widget child;
  final NeumorphicData neumorphicData;

  NeumorphicCard(
      {@required this.child, this.neumorphicData = defaultNeumorphicData});

  BoxDecoration pressedDecoration(NeumorphicData neuData) => BoxDecoration(
        color: neuData.neumorphicColorData.background,
      );

  BoxDecoration baseDecoration(NeumorphicData neuData) {
    final Map<int, double> multRange = {
      1: 0.5,
      2: 0.66,
      3: 0.75,
      4: 0.83,
      5: 1,
      6: 1.2,
      7: 1.4,
      8: 1.6,
      9: 1.8,
      10: 2,
    };
    double mod = multRange[neuData.level];
    Color darker = neuData.neumorphicColorData.darker.withOpacity(0.15 * mod);
    Color lighter = neuData.neumorphicColorData.lighter.withOpacity(0.5 * mod);
    return BoxDecoration(
        color: neuData.neumorphicColorData.background,
        borderRadius: neuData.borderRadius,
        boxShadow: [
          BoxShadow(
              offset: Offset(6, 2),
              blurRadius: 6.0,
              spreadRadius: 3.0,
              color: darker),
          BoxShadow(
              offset: Offset(-6, -2),
              blurRadius: 6.0,
              spreadRadius: 3.0,
              color: lighter)
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: neumorphicData.margin,
      padding: neumorphicData.padding,
      decoration: baseDecoration(neumorphicData),
      constraints: neumorphicData.contraints,
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
