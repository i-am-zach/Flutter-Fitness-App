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

class Report {
  String uid;
  List<CompletionReport> completed;

  Report({this.uid, this.completed});

  Report.fromData(Map data) {
    uid = data['uid'];
    completed = [];
    List repoMap = data['completed'];
    for (int i = 0; i < repoMap.length; i++) {
      CompletionReport completionReport = CompletionReport.fromData(repoMap[i]);
      completed.add(completionReport);
    }
  }

  Map<String, dynamic> deserialize() => {
        'uid': uid,
        'completed': completed
            .map((completedReport) => completedReport.deserialize())
            .toList()
      };
}

class CompletionReport {
  Timestamp logged;
  Routine routine;

  CompletionReport({this.logged, this.routine});

  CompletionReport.fromData(Map data) {
    logged = data['logged'];
    routine = Routine.fromData(data['routine']);
  }

  Map<String, dynamic> deserialize() => {
        'logged': logged,
        'routine': routine.deserialize(),
      };
}

class Routine {
  String id;
  String title;
  String description;
  int estimatedTime;
  List exercises;
  String author;

  Routine(
      {this.id,
      this.title,
      this.exercises,
      this.description,
      this.author,
      this.estimatedTime});

  Routine.fromData(Map data) {
    id = data['id'];
    title = data['title'];
    description = data['description'];
    exercises = data['exercises'];
    author = data['author'];
    estimatedTime = data['estimatedTime'];
  }

  Map<String, dynamic> deserialize() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'exercises': exercises,
      'author': author,
      'estimatedTime': estimatedTime,
    };
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
