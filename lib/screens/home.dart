import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:workout/screens/workout.dart';
import 'package:workout/services/services.dart';
import 'package:workout/shared/neumorphic.dart';

class HomeScreen extends StatelessWidget {
  final Firestore _db = Firestore.instance;
  final UserData _userData = UserData();
  final GlobalData _globalData = GlobalData();

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    GlobalRoutineData grd = Provider.of<GlobalRoutineData>(context);

    List<Stream<Routine>> followingRoutines =
        _userData.followingRoutinesBy(user);
    List<Stream<Routine>> createdRoutines = _userData.createdRoutinesBy(user);
    List<Stream<Routine>> discoverRoutines =
        _globalData.getDiscoverRoutines(grd);

    return Scaffold(
        // drawer: AppDrawer(),
        body: Container(
      child: ListView(
        children: <Widget>[
          AsyncRoutineScrollview(
            asyncRoutineList: followingRoutines,
            title: "Your routines",
            cardHeight: 250,
          ),
          AsyncRoutineScrollview(
            asyncRoutineList: createdRoutines,
            title: "Made by you",
            cardHeight: 250,
            reverse: true,
          ),
          AsyncRoutineScrollview(
            asyncRoutineList: discoverRoutines,
            title: "Discover",
            cardHeight: 250,
            reverse: false,
          )
        ],
      ),
    ));
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: FlutterLogo(),
          ),
          ListTile(
            title: Text("Create workout",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
            onTap: () {},
          )
        ],
      ),
    );
  }
}

class AsyncRoutineScrollview extends StatelessWidget {
  const AsyncRoutineScrollview(
      {Key key,
      @required this.asyncRoutineList,
      @required this.title,
      this.reverse = false,
      this.cardHeight = 200.0,
      this.titleStyle = const TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w300,
      ),
      this.margin = const EdgeInsets.only(top: 25, bottom: 25)})
      : super(key: key);

  final List<Stream<Routine>> asyncRoutineList;
  final String title;
  final TextStyle titleStyle;
  final double cardHeight;
  final bool reverse;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    if (asyncRoutineList == null || asyncRoutineList.length == 0) {
      return Container();
    }
    return Container(
        margin: margin,
        child: Column(
          crossAxisAlignment:
              reverse ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text(
                title,
                style: titleStyle,
              ),
            ),
            SizedBox(
                height: cardHeight,
                child: ListView.builder(
                    reverse: reverse,
                    scrollDirection: Axis.horizontal,
                    itemCount: asyncRoutineList.length,
                    itemBuilder: (BuildContext context, int index) =>
                        AsyncRoutineCard(
                          asyncRoutine: asyncRoutineList[index],
                        )))
          ],
        ));
  }
}

class AsyncRoutineCard extends StatelessWidget {
  AsyncRoutineCard({@required this.asyncRoutine});

  Stream<Routine> asyncRoutine;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: asyncRoutine,
      builder: (BuildContext context, AsyncSnapshot snap) {
        if (snap.hasData) {
          Routine routine = snap.data;
          return RoutineCard(
            routine: routine,
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class RoutineCard extends StatelessWidget {
  Routine routine;

  RoutineCard({@required this.routine});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WorkoutScreen(routine: routine)));
        },
        child: Container(
          padding: EdgeInsets.all(16),
          constraints:
              BoxConstraints(minWidth: MediaQuery.of(context).size.width * 0.9),
          child: NeumorphicCard(
            neumorphicData: NeumorphicData(
                level: 10,
                padding: EdgeInsets.all(16),
                borderRadius: BorderRadius.circular(20)),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        routine.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(routine.description,
                          style: TextStyle(fontWeight: FontWeight.w300)),
                    ],
                  ),
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: <Widget>[
                        Icon(FontAwesomeIcons.solidClock, size: 14),
                        SizedBox(
                          width: 5,
                        ),
                        Text(routine.estimatedTime.toString() + ' min'),
                        SizedBox(
                          width: 5,
                        ),
                        Text("|"),
                        SizedBox(
                          width: 5,
                        ),
                        Text("${routine.exercises.length} Exercises")
                      ],
                    )),
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.userTag,
                          size: 12,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(routine.author,
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 10))
                      ],
                    ))
              ],
            ),
          ),
        ));
  }
}
