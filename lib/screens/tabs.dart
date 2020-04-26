import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:workout/screens/home.dart';
import 'package:workout/screens/screens.dart';
import 'package:workout/services/services.dart';
import 'package:workout/shared/neumorphic.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key key}) : super(key: key);

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _currentIndex = 0;
  final List<Widget> tabs = [
    HomeScreen(),
    ProgressTab(),
    ProfileRoute(),
    CreateRoutineRoute(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
                title: Text("Home"), icon: Icon(Icons.home)),
            BottomNavigationBarItem(
                title: Text("Progress"),
                icon: Icon(FontAwesomeIcons.chartLine)),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.user), title: Text("Profile")),
          ]),
      body: tabs[_currentIndex],
    );
  }
}

class CreateRoutineRoute extends StatelessWidget {
  const CreateRoutineRoute({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
