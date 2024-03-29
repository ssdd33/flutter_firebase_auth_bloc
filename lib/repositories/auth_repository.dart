import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:firebase_auth_bloc/constants/db_constants.dart';
import 'package:firebase_auth_bloc/models/custom_error.dart';

class AuthRepository {
  final FirebaseFirestore firebaseFireStore;
  final fbAuth.FirebaseAuth firebaseAuth;

  AuthRepository({required this.firebaseFireStore, required this.firebaseAuth});

  Stream<fbAuth.User?> get user => firebaseAuth.userChanges();

  Future<void> signup(
      {required String email,
      required String name,
      required String password}) async {
    try {
      print('repo signup :  $password');
      final fbAuth.UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final signedinUser = userCredential.user!;
      await userRef.doc(signedinUser.uid).set({
        'name': name,
        'email': email,
        'profileImage': 'https://picsum.photos/300',
        'rank': 'bronze',
        'point': 0,
      });
    } on fbAuth.FirebaseAuthException catch (e) {
      throw CustomError(code: e.code, message: e.message!, plugin: e.plugin);
    } catch (e) {
      throw CustomError(
          code: 'Exception',
          message: e.toString(),
          plugin: 'flutter_error/server_error ');
    }
  }

  Future<void> signin(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on fbAuth.FirebaseAuthException catch (e) {
      throw CustomError(code: e.code, message: e.message!, plugin: e.plugin);
    } catch (e) {
      throw CustomError(
          code: 'Exception',
          message: e.toString(),
          plugin: 'flutter_error/server_error ');
    }
  }

  Future<void> signout() async {
    await firebaseAuth.signOut();
  }
}
