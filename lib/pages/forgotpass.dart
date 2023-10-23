import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditation/pages/loginpage.dart';

class forgotPass extends StatefulWidget {
  const forgotPass({Key? key}) : super(key: key);
  static String id = 'forgotPass';

  @override
  State<forgotPass> createState() => _forgotPassState();
}

class _forgotPassState extends State<forgotPass> {
  final emailController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close),
                    ),
                    SizedBox(height: 70),

                    Text(
                      "Forgot Password",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Alegreya',
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Please enter your email address to recover your password.',
                      style: TextStyle(
                        fontSize: 23,
                        color: Colors.black,
                        fontFamily: 'Alegreya',
                      ),
                    ),
                    const SizedBox(height: 40),

                    //email text field
                    Container(
                      child: TextFormField(
                        obscureText: false,
                        controller: emailController,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Alegreya',
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                30.0,
                              ),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFF8E97FD), width: 2.0),
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                30.0,
                              ),
                            ),
                          ),
                          //isDense: true,
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'email address',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 23,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    //forgot pass button
                    Center(
                      child: SizedBox(
                        height: 65,
                        width: 350,
                        child: MaterialButton(
                          padding: EdgeInsets.all(15),
                          onPressed: () async {
                            try {
                              await _auth.sendPasswordResetEmail(email:emailController.text.trim());
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return
                                      AlertDialog(
                                        content: Text(
                                            'Password reset link! Check your email.'),
                                        contentTextStyle: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Alegreya',
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: (){
                                              Navigator.pushNamed(context, loginpage.id);
                                          },
                                            child: Text(
                                              'Back to Login',
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
                            } on FirebaseAuthException catch (e) {
                              print(e);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Center(child: Text('Error Message!')),
                                      titleTextStyle: TextStyle(
                                        fontSize: 25,
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Alegreya',
                                      ),
                                      content: Text(e.message.toString()),
                                      contentTextStyle: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Alegreya',
                                      ),
                                    );
                                  }
                                  );
                            }
                          },
                          color: Color(0xFF8E97FD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'RESET PASSWORD',
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
        ));
  }
}
