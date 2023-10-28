import 'package:firebase_auth/firebase_auth.dart';

class Globals {
  FirebaseAuth _auth = FirebaseAuth.instance;

  printInteger() {
    // _auth;
    //if(kDebugMode) print(_auth);
  }

  autht() {
    return _auth.currentUser;
  }

  changeInteger(FirebaseAuth a) {
    _auth = a;
    printInteger(); // this can be replaced with any static method
  }

  authSignOut() {
    _auth.signOut();
  }
}
