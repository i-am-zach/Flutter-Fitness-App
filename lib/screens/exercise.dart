import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workout/services/models.dart';

class ExerciseScreen extends StatelessWidget {
  Stream<Exercise> exerciseStream;
  int index;
  int totalExercises;
  PageController pageController;

  ExerciseScreen(
      {this.exerciseStream,
      this.index,
      this.totalExercises,
      this.pageController});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: exerciseStream,
      builder: (BuildContext context, AsyncSnapshot snap) {
        Exercise exercise = snap.data;
        if (exercise == null) {
          exercise = Exercise(title: "Loading Exercise", sets: 3, reps: '8');
        }
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.pink[300],
            onPressed: () {
              pageController.nextPage(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.decelerate);
            },
            child: Icon(Icons.navigate_next),
          ),
          body: Container(
              padding: EdgeInsets.all(16),
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 300,
                      height: 300,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.1),
                                offset: Offset(10, 4),
                                blurRadius: 6.0,
                                spreadRadius: 3.0),
                            BoxShadow(
                                color: Color.fromRGBO(255, 255, 255, 0.9),
                                offset: Offset(-10, -4),
                                blurRadius: 6.0,
                                spreadRadius: 3.0),
                          ]),
                      child: WorkoutIcon(exercise.type),
                    ),
                  ),
                  FractionallySizedBox(
                      heightFactor: 0.25,
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: Text(exercise.title ?? "No title",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 50, fontWeight: FontWeight.w300)),
                      )),
                  FractionallySizedBox(
                    heightFactor: 0.8,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        exercise.sets.toString() +
                            ' x ' +
                            exercise.reps.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 40,
                            letterSpacing: 15),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    child: Text(
                      '$index/$totalExercises',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  )
                ],
              )),
        );
      },
    );
  }
}

class WorkoutIcon extends StatelessWidget {
  String type;
  WorkoutIcon(String workoutType) {
    type = workoutType;
  }

  @override
  Widget build(BuildContext context) {
    Color _color = Colors.pink[300];
    switch (type) {
      case "jump":
        return FractionallySizedBox(
          widthFactor: 0.6,
          child: Center(
              child: Image(
                  image: AssetImage("assets/icons/jump@3x.png"),
                  color: _color)),
        );
      case "legs":
        return FractionallySizedBox(
          widthFactor: 0.7,
          child: Center(
              child: Image(
                  image: AssetImage("assets/icons/leg@3x.png"), color: _color)),
        );
      case "arm":
        return FractionallySizedBox(
          widthFactor: 0.8,
          child: Center(
              child: Image(
                  image: AssetImage("assets/icons/arm@3x.png"), color: _color)),
        );
      default:
        return FractionallySizedBox(
          widthFactor: 0.8,
          child: Center(
              child: Image(
                  image: AssetImage("assets/icons/dumbell@3x.png"),
                  color: _color)),
        );
    }
  }
}
