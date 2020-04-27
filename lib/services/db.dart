import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:workout/services/models.dart';
import 'package:workout/services/services.dart';
import 'dart:async';
import './globals.dart';

class Document<T> {
  final Firestore _db = Firestore.instance;
  final String path;
  DocumentReference ref;

  Document({this.path}) {
    ref = _db.document(path);
  }

  Future<T> getData() {
    return ref.get().then((v) => Global.models[T](v.data) as T);
  }

  Stream<T> streamData() {
    return ref.snapshots().map((v) => Global.models[T](v.data) as T);
  }

  Future<void> upsert(Map data) {
    return ref.setData(Map<String, dynamic>.from(data), merge: true);
  }
}

class Collection<T> {
  final Firestore _db = Firestore.instance;
  final String path;
  CollectionReference ref;

  Collection({this.path}) {
    ref = _db.collection(path);
  }

  Future<List<T>> getData() async {
    var snapshots = await ref.getDocuments();
    return snapshots.documents
        .map((doc) => Global.models[T](doc.data) as T)
        .toList();
  }

  Stream streamData() {
    return ref.snapshots().map((data) {
      List<T> documents =
          data.documents.map((doc) => Global.models[T](doc.data) as T).toList();
      return documents;
    });
  }
}

class UserData<T> {
  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String collection;

  UserData({this.collection});

  Stream<T> get documentStream {
    return _auth.onAuthStateChanged.switchMap((user) {
      if (user != null) {
        Document<T> doc = Document<T>(path: "$collection/" + user.uid);
        return doc.streamData();
      } else {
        return Stream<T>.value(null);
      }
    });
  }

  Stream<List<Routine>> get routineStream {
    return _auth.onAuthStateChanged.switchMap((user) {
      return _db
          .collection(collection)
          .document(user.uid)
          .snapshots()
          .switchMap((userData) {
        if (userData.data['routines'] == null) {
          return Stream.empty();
        }
        List routines = userData.data['routines'];
        return _db
            .collection('routines')
            .where('id', whereIn: routines)
            .snapshots()
            .map((v) =>
                v.documents.map((doc) => Routine.fromData(doc.data)).toList());
      });
    });
  }
}

class ExerciseService {
  final Firestore _db = Firestore.instance;

  List<Stream<Exercise>> exerciseStreamList(Routine routine) {
    List<Stream<Exercise>> streams = [];
    for (int i = 0; i < routine.exercises.length; i++) {
      streams.add(this.exerciseStream(routine, i));
    }
    return streams;
  }

  Stream<Exercise> exerciseStream(Routine routine, int index) {
    String exercise_id = routine.exercises[index]['exercise_id'];
    return Document<Exercise>(path: 'exercises/' + exercise_id).streamData();
  }
}

class ReportService {
  final Firestore _db = Firestore.instance;

  Stream<Report> reportStream(User user) {
    DocumentReference reportRef = _db.collection('reports').document(user.uid);
    return reportRef.snapshots().map((snap) {
      Report report = Report.fromData(snap.data);
      return report;
    });
  }

  List<CompletionReport> recentReports(Report report, int hours) {
    List<CompletionReport> recent = [];
    DateTime now = DateTime.now();
    for (int i = 0; i < report.completed.length; i++) {
      CompletionReport cr = report.completed[i];
      DateTime logged = cr.logged.toDate();
      if (now.difference(logged).inHours < hours) {
        recent.add(cr);
      }
    }
    return recent;
  }

  logCompletedRoutine(User user, Routine routine) async {
    DocumentReference reportRef = _db.collection('reports').document(user.uid);
    DocumentSnapshot snap = await reportRef.get();
    if (snap.data == null) {
      CompletionReport completionReport = CompletionReport(
          logged: Timestamp.fromDate(DateTime.now()), routine: routine);
      Report report = new Report(uid: user.uid, completed: [completionReport]);
      reportRef.setData(report.deserialize());
    } else {
      Report report = Report.fromData(snap.data);
      CompletionReport completionReport = CompletionReport(
          logged: Timestamp.fromDate(DateTime.now()), routine: routine);
      report.completed.add(completionReport);
      reportRef.setData(report.deserialize());
    }
  }

  removeCompletedRoutine(User user, Timestamp timestamp) async {
    DocumentReference reportRef = _db.collection('reports').document(user.uid);
    DocumentSnapshot snap = await reportRef.get();

    Report report = Report.fromData(snap.data);
    for (int i = 0; i < report.completed.length; i++) {
      CompletionReport comp = report.completed[i];
      if (comp.logged.compareTo(timestamp) == 0) {
        report.completed.removeAt(i);
        reportRef.setData(report.deserialize());
        break;
      }
    }
  }
}

class ReportAggregation {
  final Report report;

  ReportAggregation({@required this.report});

  List<Routine> get routines =>
      report.completed.map((cr) => cr.routine).toList();

  int totalMinutes() {
    int sum = 0;

    this.routines.forEach((routine) {
      sum += routine.estimatedTime;
    });

    return sum;
  }

  int minutesBy(Duration duration) {
    int sum = 0;

    this.report.completed.forEach((report) {
      Duration difference = DateTime.now().difference(report.logged.toDate());
      if (duration.inMilliseconds - difference.inMilliseconds >= 0) {
        sum += report.routine.estimatedTime;
      }
    });

    return sum;
  }

  int streak() {
    int sum = 0;
    List<DateTime> logs =
        report.completed.map((cr) => cr.logged.toDate()).toList();

    DateTime dt = DateTime.now();
    while (_checkDate(dt, logs)) {
      sum++;
      dt.subtract(Duration(hours: 24));
    }
    return sum;
  }

  bool _checkDate(DateTime date, List<DateTime> loggedDays) {
    if (loggedDays.length == 0) {
      return false;
    }
    int containIdx = -1;
    for (int i = 0; i < loggedDays.length; i++) {
      DateTime dt = loggedDays[i];
      if (dt.difference(date).inHours <= 24) {
        containIdx = i;
      } else {
        break;
      }
    }
    for (int i = -1; i < containIdx; i++) {
      loggedDays.removeAt(0);
    }
    return containIdx >= 0;
  }

  Routine favoriteRoutine() {
    Map<Routine, int> count = {};
    int max = 0;
    Routine maxR;
    this.routines.forEach((routine) {
      if (count.containsKey(routine)) {
        count[routine]++;
      } else {
        count[routine] = 1;
      }
      if (count[routine] > max) {
        max = count[routine];
        maxR = routine;
      }
    });
    return maxR;
  }
}
