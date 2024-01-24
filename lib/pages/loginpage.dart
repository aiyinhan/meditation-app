import 'package:flutter/material.dart';
import 'package:meditation/components/my_button.dart';
import 'package:meditation/components/my_textfield.dart';
import 'package:meditation/pages/RegisterPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meditation/pages/forgotpass.dart';
import 'package:meditation/pages/homePage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../controllers/auth_controller.dart';

class loginpage extends StatefulWidget {
  const loginpage({Key? key}) : super(key: key);
  static String id = 'loginpage';

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  //text editing controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthController _authController = AuthController();

  bool showSpinner = false;
  bool obscureText = true;

  @override
  void initState() {
    super.initState();

    //getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Center(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Icon(
                    Icons.lock,
                    size: 30,
                  ),
                  //text
                  SizedBox(height: 10),
                  Text(
                    "NeuroMedita",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Alegreya',
                      letterSpacing: 4,
                    ),
                  ),
                  SizedBox(height: 15),

                  //email text field
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
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

                  //forgot password?
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, forgotPass.id);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: 15),
                          //margin: EdgeInsets.only(right: 10),
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Alegreya',
                                fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //login button
                  MyButton(
                    onTap: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        await _authController.loginUser(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                        Navigator.pushNamed(context, homePage.id);
                        setState(() {
                          showSpinner = false;
                        });
                      } on FirebaseAuthException catch (e) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Text(e.message.toString()),
                                ),
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
                            });
                        setState(() {
                          showSpinner = false;
                        });
                      }
                    },
                  ),

                  SizedBox(height: 10),

                  //not a member
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member? ',
                        style: TextStyle(
                          fontFamily: 'Alegreya',
                          fontSize: 17,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RegisterPage.id);
                        },
                        child: Text(
                          'Register now.',
                          style: TextStyle(
                            fontFamily: 'Alegreya',
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
