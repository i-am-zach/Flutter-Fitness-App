import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<FirebaseUser> get userFuture => _auth.currentUser();

  Stream<FirebaseUser> get userStream => _auth.onAuthStateChanged;

  Future<FirebaseUser> googleSignIn() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      AuthResult result = await _auth.signInWithCredential(credential);
      FirebaseUser user = result.user;

      this.updateUserData(user);
      return user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<FirebaseUser> anonLogin() async {
    AuthResult result = await _auth.signInAnonymously();
    FirebaseUser user = result.user;

    this.updateUserData(user);
    return user;
  }

  Future<void> signOut() {
    return _auth.signOut();
  }

  updateUserData(FirebaseUser user) {
    _db.collection('users').document(user.uid).setData({
      'uid': user.uid,
      'name': user.displayName,
      'lastActivity': DateTime.now(),
    });
  }

  get loggedIn {
    return _auth.currentUser() != null;
  }
}
