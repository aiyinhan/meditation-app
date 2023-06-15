import 'package:flutter/material.dart';
import 'package:meditation/components/my_button.dart';
import 'package:meditation/components/my_textfield.dart';
import 'package:meditation/pages/RegisterPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meditation/pages/forgotpass.dart';
import 'package:meditation/pages/homePage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';



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

  //firebase (get current user)
  final _auth =FirebaseAuth.instance;
  bool showSpinner =false;

  @override
  void initState() {
    super.initState();

    //getCurrentUser();
  }


  // void getCurrentUser() async{ //have sign in
  //   try{
  //     final user = await _auth.currentUser; //response when user registered
  //     if (user !=null){
  //       User loggedInUser = user;
  //     }
  //   } catch (e){
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Center(
          child: SafeArea(
            child:SingleChildScrollView(
              child: Column(
                children:  [
                  SizedBox(height: 10),
                  Icon(
                    Icons.lock,
                    size: 50,
                  ),
                  //text
                  Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'Alegreya',
                      fontSize: 40,
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
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),

                  //forgot password?
                  TextButton(onPressed: (){
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
                                fontFamily:'Alegreya',
                                fontSize: 18) ,
                          ),
                        ),
                      ],
                    ),
                  ),


                  //login button
                  MyButton(
                    onTap: ()async{
                      setState(() {
                        showSpinner=true;
                      });
                      try {
                        final user = await _auth.signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text);
                        Navigator.pushNamed(context,homePage.id);
                        setState(() {
                          showSpinner=false;
                        });
                      }on FirebaseAuthException catch(e){
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
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
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

