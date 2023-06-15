import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meditation/pages/homePage.dart';
import 'package:meditation/pages/reminderPage.dart';
import 'package:meditation/user_model.dart';
import 'package:email_validator/email_validator.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  static String id = 'ProfilePage';


  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController bodyWeightController = TextEditingController();



  UserModel? myUser;

  getUserInfo ()async{
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('RegisterData').doc(uid).get();
    myUser= UserModel.fromJson(snapshot.data() as Map<String,dynamic>);
    setState(() {
      nameController.text = myUser?.name??"";
      emailController.text = myUser?.email??"";
      ageController.text = myUser?.age??"";
      bodyWeightController.text = myUser?.bodyWeight??"";
    });
  }

  void updateProfile() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('RegisterData')
        .doc(uid)
        .update({
      'Name': nameController.text,
      'Email': emailController.text,
      'Age': ageController.text,
      'BodyWeight': bodyWeightController.text,
    }).then((value) {
      showDialog(
          context: context,
          builder: (context) {
            return
              AlertDialog(
                content: const Text(
                    'Profile Updated!'),
                contentTextStyle: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Alegreya',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                actions: [
                  TextButton(
                    onPressed: (){
                      Navigator.pushNamed(context, homePage.id);
                    },
                    child: const Text(
                      'Okay',
                      style: TextStyle(
                        color: Color(0xFF8E97FD),
                        fontFamily: 'Alegreya',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              );
          });
      // Update email in Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String newEmail = emailController.text;
        user.updateEmail(newEmail).then((_) {
        }).catchError((error) {
          print('Error updating email: $error');
        });
      }
    }).catchError((error) {
      // An error occurred while updating the profile
      print('Error updating profile: $error');
    });
  }

  bool validateEmailFormat(String email) {
    // You can use a regular expression or any other method to validate the email format
    // Here's a simple example using the email_validator package
    return EmailValidator.validate(email);
  }

  void saveProfile() {
    // Validate email format before updating the profile
    if (validateEmailFormat(emailController.text)) {
      updateProfile();
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return
              AlertDialog(
                content: const Text(
                    'Email address invalid.'),
                contentTextStyle: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Alegreya',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                actions: [
                  TextButton(
                    onPressed: (){
                      Navigator.pushNamed(context, ProfilePage.id);
                    },
                    child: const Text(
                      'Okay',
                      style: TextStyle(
                        color: Color(0xFF8E97FD),
                        fontFamily: 'Alegreya',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              );
          });
    }
  }

  @override
  void initState (){
    super.initState();
    getUserInfo();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    ageController.dispose();
    bodyWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(items:[
        BottomNavigationBarItem(
            icon:
            GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, homePage.id);
                },
                child: Icon(Icons.home,color: Colors.grey[700],)), label: ''),
        BottomNavigationBarItem(
            icon:
            GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, reminderPage.id);
                },
                child: Icon(Icons.timer)), label: ''),
        BottomNavigationBarItem(
            icon:
            GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, ProfilePage.id);
                },
                child: Icon(Icons.person_2)), label: ''),
      ],
      ),
      appBar: AppBar(
        backgroundColor: Color(0xFF8E97FD),
        toolbarHeight: 80,
        title: Text('Edit Profile'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.bold,
          fontFamily: 'Alegreya',
        ),
      ),
      body:SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 400,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: TextFormField(
                    //enabled: isEditing,
                    controller: nameController,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Alegreya',
                    ),
                    decoration:
                    const InputDecoration(
                      label: Text('Full Name'),prefixIcon: Icon(Icons.person),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.5,),
                        borderRadius: BorderRadius.all(Radius.circular(30.0,),),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF8E97FD), width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(30.0,),),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: TextFormField(
                    //enabled: isEditing,
                    controller: emailController,
                    style:const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Alegreya',
                    ),
                    decoration:
                    const InputDecoration(
                      label: Text('Email'),prefixIcon: Icon(Icons.email),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.5,),
                        borderRadius: BorderRadius.all(Radius.circular(30.0,),),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF8E97FD), width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(30.0,),),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: TextFormField(
                    //enabled: isEditing,
                    controller: ageController,
                    style:const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Alegreya',
                    ),
                    decoration:
                    const InputDecoration(
                      label: Text('Age'),prefixIcon: Icon(Icons.numbers),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.5,),
                        borderRadius: BorderRadius.all(Radius.circular(30.0,),),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF8E97FD), width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(30.0,),),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: TextFormField(
                    //enabled: isEditing,
                    controller: bodyWeightController,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Alegreya',
                    ),
                    decoration:
                    const InputDecoration(
                      label: Text('Body Weight'),prefixIcon: Icon(Icons.line_weight),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.5,),
                        borderRadius: BorderRadius.all(Radius.circular(30.0,),),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF8E97FD), width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(30.0,),),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),

                Center(
                  child: SizedBox(
                    height: 65,
                    width: 250,
                    child: MaterialButton(
                      padding: EdgeInsets.all(15),
                      onPressed: () {
                          saveProfile();
                      },
                      color: Color(0xFF8E97FD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'SAVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Alegreya',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }
}
