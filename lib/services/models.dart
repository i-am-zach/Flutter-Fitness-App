import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise {
  String id;
  String title;
  int sets;
  dynamic reps;
  String type;
  String description;

  bool exists;

  Exercise(
      {this.id,
      this.title,
      this.sets = 3,
      this.reps = 8,
      this.type = "generic",
      this.description = "",
      this.exists = true});

  Exercise.fromData(Map data) {
    title = data['title'];
    sets = data['sets'];
    reps = data['reps'];
    type = data['type'];
    id = data['id'];
    description = data['description'];
  }
}

class Routine {
  String title;
  String description;
  String estimatedTime;
  List exercises;
  String author;

  Routine(
      {this.title,
      this.exercises,
      this.description,
      this.author,
      this.estimatedTime});

  Routine.fromData(Map data) {
    title = data['title'];
    description = data['description'];
    exercises = data['exercises'];
    author = data['author'];
    estimatedTime = data['estimatedTime'];
  }
}

class User {
  String name;
  String uid;
  Timestamp lastActivity;
  List routines;
  String description;

  User({this.name, this.uid, this.lastActivity, this.routines});

  User.fromData(Map data) {
    name = data['name'];
    uid = data['uid'];
    lastActivity = data['lastActivity'];
    routines = data['routines'];
  }
}
