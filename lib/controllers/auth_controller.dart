import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> registerUser({
    required String email,
    required String password,
    required String username,
    required String age,
    required String bodyWeight,
  }) async {
    final newUser = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    String uid = newUser.user!.uid;
    await _firestore.collection('RegisterData').doc(uid).set({
      'Name': username,
      'Email': email,
      'Age': age,
      'BodyWeight': bodyWeight,
      'Password': password,
      'Role': 'user',
    });
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }
}
