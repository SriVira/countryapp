import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static Stream<User?> get user => firebaseAuth.authStateChanges();

  static Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  static Future<void> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  static Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
