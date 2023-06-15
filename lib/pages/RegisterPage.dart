import 'package:flutter/material.dart';
import 'package:meditation/components/my_textfield.dart';
import 'package:meditation/pages/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  static String id = 'registerpage';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool showSpinner = false;


  //text editing controller
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final ageController = TextEditingController();
  final bodyWeightController = TextEditingController();
  final confirmPasswordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Icon(
                      Icons.lock,
                      size: 50,
                    ),
                  ),
                  //text
                  Text(
                    'Register',
                    style: TextStyle(
                      fontFamily: 'Alegreya',
                      fontSize: 40,
                    ),
                  ),

                  SizedBox(height: 15),

                  //name text field
                  MyTextField(
                    controller: usernameController,
                    hintText: 'Username',
                    obscureText: false,
                  ),
                  SizedBox(height: 10),

                  //email
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  SizedBox(height: 10),

                  //age
                  MyTextField(
                    controller: ageController,
                    hintText: 'Age',
                    obscureText: false,
                  ),
                  SizedBox(height: 10),

                  //body weight
                  MyTextField(
                    controller: bodyWeightController,
                    hintText: 'Body Weight',
                    obscureText: false,
                  ),
                  SizedBox(height: 10),

                  //password
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  SizedBox(height: 10),

                  //confirm password
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),
                  SizedBox(height: 30),

                  //sign in button
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        showSpinner=true;
                      });
                      try {
                        final newUser = await _auth.createUserWithEmailAndPassword(
                            email: emailController.text, password: passwordController.text);
                        String uid = FirebaseAuth.instance.currentUser!.uid;
                        _firestore.collection('RegisterData').doc(uid).set({
                          'Name': usernameController.text,
                          'Email': emailController.text,
                          'Age': ageController.text,
                          'BodyWeight': bodyWeightController.text,
                        });
                        if(passwordController.text!=confirmPasswordController.text){
                          showDialog(context: context, builder: (BuildContext context){
                            return AlertDialog(
                              content: Text("Confirm password and password are not the same."),
                              contentTextStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Alegreya',
                              ),

                              title: Center(
                                  child: Text('Error Message!')
                              ),
                              titleTextStyle: TextStyle(
                                fontSize: 25,
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Alegreya',
                              ),
                            );
                          });
                        }
                        else {
                          Navigator.pushNamed(context, loginpage.id);
                        }

                        setState(() {
                          showSpinner=false;
                        });

                      } on FirebaseAuthException catch(e){
                        print(e);
                        showDialog(context: context, builder: (BuildContext context){
                          return AlertDialog(
                            content: Text(e.message.toString()),
                            contentTextStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Alegreya',
                            ),

                            title: Center(
                                child: Text('Error Message!')
                            ),
                            titleTextStyle: TextStyle(
                              fontSize: 25,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Alegreya',
                            ),
                          );
                        });
                        setState(() {
                          showSpinner=false;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(14),
                      margin: EdgeInsets.symmetric(horizontal: 70),
                      decoration: BoxDecoration(
                      color:Color(0xFF8E97FD),
                      borderRadius: BorderRadius.circular(8),
                    ),
                      child: Center(
                        child: Text(
                          'SIGN UP',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            fontFamily:'Alegreya' ),
                      ),
                    ),
                ),
                  ),
                  GestureDetector(
                    onTap: () {
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                      Navigator.pushNamed(context, loginpage.id);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 40.0),
                          //margin: EdgeInsets.only(right: 10),
                          child: Text(
                            'Back to Login',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Alegreya',
                                fontSize: 18),
                          ),
                        ),
                      ],
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



