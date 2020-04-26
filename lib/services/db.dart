import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:workout/services/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';
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
