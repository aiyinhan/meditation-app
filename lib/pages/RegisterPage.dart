import 'package:flutter/material.dart';
import 'package:meditation/components/my_textfield.dart';
import 'package:meditation/controllers/auth_controller.dart';
import 'package:meditation/pages/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  static String id = 'registerpage';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool showSpinner = false;
  bool obscureText = true;
  final AuthController _authController = AuthController();

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
                SizedBox(height: 30),
                Icon(
                  Icons.lock,
                  size: 25,
                ),
                Text(
                  'Create Your Account!',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Alegreya',
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Alegreya',
                    ),
                    controller: passwordController,
                    obscureText: obscureText,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                        icon: Icon(Icons.remove_red_eye),
                      ),
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        fontSize: 23,
                        color: Colors.grey[600],
                      ),
                      contentPadding: EdgeInsets.all(10),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF8E97FD),
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                //confirm password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Alegreya',
                    ),
                    controller: confirmPasswordController,
                    obscureText: obscureText,
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      hintStyle: TextStyle(
                        fontSize: 23,
                        color: Colors.grey[600],
                      ),
                      contentPadding: EdgeInsets.all(10),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF8E97FD),
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 30),

                //sign in button
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    if (passwordController.text !=
                        confirmPasswordController.text) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text(
                              "Confirm password and password are not the same.",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Alegreya',
                              ),
                            ),
                            title: Center(child: Text('Error Message!')),
                            titleTextStyle: TextStyle(
                              fontSize: 25,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Alegreya',
                            ),
                          );
                        },
                      );
                    } else {
                      try {
                        await _authController.registerUser(
                            email: emailController.text,
                            password: passwordController.text,
                            username: usernameController.text,
                            age: ageController.text,
                            bodyWeight: bodyWeightController.text);
                        Navigator.pushNamed(context, loginpage.id);
                      } on FirebaseAuthException catch (e) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text(e.message.toString()),
                              contentTextStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Alegreya',
                              ),
                              title: Center(child: Text('Error Message!')),
                              titleTextStyle: TextStyle(
                                fontSize: 25,
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Alegreya',
                              ),
                            );
                          },
                        );
                      }
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(horizontal: 70),
                    decoration: BoxDecoration(
                      color: Color(0xFF8E97FD),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'SIGN UP',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          fontFamily: 'Alegreya',
                        ),
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
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Alegreya',
                              fontSize: 17),
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
