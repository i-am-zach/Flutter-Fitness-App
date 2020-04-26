import 'package:flutter/material.dart';
import 'package:workout/screens/screens.dart';
import 'package:workout/services/db.dart';
import 'package:workout/services/models.dart';
import 'package:workout/shared/neumorphic.dart';

class WorkoutScreen extends StatelessWidget {
  static final PAGE_CONTROLLER = PageController(initialPage: 0);
  final Routine routine;
  final ExerciseService _exerciseService = ExerciseService();

  WorkoutScreen({this.routine});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          body: PageView.builder(
              controller: PAGE_CONTROLLER,
              itemCount: routine.exercises.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return BeginScreen(
                    workoutTitle: routine.title,
                    pageController: PAGE_CONTROLLER,
                  );
                } else if (index > routine.exercises.length) {
                  return CompleteScreen();
                } else {
                  return ExerciseScreen(
                    exerciseStream:
                        _exerciseService.exerciseStream(routine, index - 1),
                    index: index,
                    totalExercises: routine.exercises.length,
                    pageController: PAGE_CONTROLLER,
                  );
                }
              })),
    );
  }
}

class CompleteScreen extends StatelessWidget {
  const CompleteScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class BeginScreen extends StatelessWidget {
  String workoutTitle;
  PageController pageController;

  BeginScreen({@required this.workoutTitle, @required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Are you ready to start $workoutTitle?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.w300),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            NeumorphicButton(
              onTap: () {
                Navigator.popAndPushNamed(context, '/home');
              },
              text: Text("Go Back"),
              constraints: BoxConstraints(minWidth: 100),
            ),
            SizedBox(width: 50),
            NeumorphicButton(
              onTap: () {
                pageController.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.decelerate);
              },
              text: Text("Let's go"),
              constraints: BoxConstraints(minWidth: 100),
            ),
          ]),
        ],
      ),
    );
  }
}
