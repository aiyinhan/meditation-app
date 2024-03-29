import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meditation/models/user_model.dart';

class ProfileController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> getUserInfo() async {
    try {
      String uid = _auth.currentUser!.uid;
      DocumentSnapshot snapshot =
      await _firestore.collection('RegisterData').doc(uid).get();
      return snapshot.exists
          ? UserModel.fromJson(snapshot.data() as Map<String, dynamic>)
          : null;
    } catch (e) {
      print('Error getting user info: $e');
      return null;
    }
  }

  bool validateEmailFormat(String email) {
    return EmailValidator.validate(email);
  }

  Future<String> updateProfile(UserModel user) async {
    try {

      if (user.name.isEmpty ||
          user.email.isEmpty ||
          user.age.isEmpty ||
          user.bodyWeight.isEmpty) {
        return 'Please enter all fields';
      }
      if (!validateEmailFormat(user.email)) {
        return 'Invalid email format.';
      }
      String uid = _auth.currentUser!.uid;

      if (user.email != (await getUserInfo())?.email) {
        QuerySnapshot snapshot = await _firestore
            .collection('RegisterData')
            .where('Email', isEqualTo: user.email)
            .get();
        if (snapshot.docs.isNotEmpty) {
          return 'This email is already registered.';
        }
        User? currentUser = _auth.currentUser;
        if (currentUser != null) {
          await currentUser.updateEmail(user.email);
        }
      }
      await _firestore.collection('RegisterData').doc(uid).update({
        'Name': user.name,
        'Email': user.email,
        'Age': user.age,
        'BodyWeight': user.bodyWeight,
      });
      return 'Profile Updated!';
    } catch (e) {
      return 'Error updating Profile :$e';
    }
  }

  Future<bool> logout() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      print('Error logging out: $e');
      return false;
    }
  }
}
