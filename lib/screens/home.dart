import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:workout/screens/exercise.dart';
import 'package:workout/screens/workout.dart';
import 'package:workout/services/services.dart';
import 'package:workout/shared/neumorphic.dart';

class HomeScreen extends StatelessWidget {
  final Firestore _db = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    List<Routine> userRoutines = Provider.of<List<Routine>>(context);
    if (userRoutines == null) {
      userRoutines = [
        Routine(
            title: "Loading data",
            author: "",
            description: "",
            estimatedTime: 30,
            exercises: [])
      ];
    }
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Your Routines",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  RoutineCard(routine: userRoutines[0]),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RoutineCard extends StatelessWidget {
  Routine routine;

  RoutineCard({this.routine});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WorkoutScreen(routine: routine)));
        },
        child: NeumorphicCard(
          neumorphicData: NeumorphicData(
              level: 10,
              padding: EdgeInsets.all(16),
              borderRadius: BorderRadius.circular(20)),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
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
                          fontSize: 36,
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
                          width: 5,
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
