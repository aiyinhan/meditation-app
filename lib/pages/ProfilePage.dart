import 'package:flutter/material.dart';
import 'package:meditation/components/my_profile.dart';
import 'package:meditation/pages/homePage.dart';
import 'package:meditation/pages/loginpage.dart';
import 'package:meditation/pages/reminderPage.dart';
import 'package:meditation/models/user_model.dart';
import '../controllers/profile_controller.dart';

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

  final ProfileController _profileController = ProfileController();

  void _loadUserInfo() async {
    UserModel? user = await _profileController.getUserInfo();
    setState(() {
      nameController.text = user?.name ?? '';
      emailController.text = user?.email ?? '';
      ageController.text = user?.age ?? '';
      bodyWeightController.text = user?.bodyWeight ?? '';
    });
  }

  void _updateProfile() async {


    UserModel user = UserModel(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      age: ageController.text.trim(),
      bodyWeight: bodyWeightController.text.trim(),
    );
    String message = await _profileController.updateProfile(user);
    showMessage(message);
  }

  void showMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Alert',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: 'Alegreya',
              ),
            ),
            content: Text(
              message,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Alegreya',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'OK',
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

  void _logout() async {
    bool success = await _profileController.logout();
    if (success) {
      Navigator.pushNamed(context, loginpage.id);
    } else {
      showMessage('Error logging out.');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
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
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, homePage.id);
                  },
                  child: Icon(
                    Icons.home,
                    color: Colors.grey[700],
                  )),
              label: ''),
          BottomNavigationBarItem(
              icon: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, reminderPage.id);
                  },
                  child: Icon(Icons.timer)),
              label: ''),
          BottomNavigationBarItem(
              icon: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ProfilePage.id);
                  },
                  child: Icon(Icons.person_2)),
              label: ''),
        ],
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF8E97FD),
        toolbarHeight: 60,
        title: Text('Edit Profile'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pushNamed(context, homePage.id);
          },
        ),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          fontFamily: 'Alegreya',
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 400,
            child: Column(
              children: [
                myProfile(
                    controller: nameController,
                    name: 'Name',
                    icon: Icons.person_2),

                myProfile(
                    controller: emailController,
                    name: 'Email',
                    icon: Icons.email),
                myProfile(
                  controller: ageController,
                  name: 'Age',
                  icon: Icons.numbers,
                ),
                myProfile(
                    controller: bodyWeightController,
                    name: 'Body Weight',
                    icon: Icons.line_weight),
                SizedBox(height: 30),

                //save button
                SizedBox(
                  height: 50,
                  width: 300,
                  child: MaterialButton(
                    padding: EdgeInsets.all(10),
                    onPressed: () {
                      _updateProfile();
                    },
                    color: Color(0xFF8E97FD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Alegreya',
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),

                //logout button
                SizedBox(
                  height: 52,
                  width: 300,
                  child: MaterialButton(
                    padding: EdgeInsets.all(10),
                    onPressed: () {
                      _logout();
                    },
                    color: Colors.black45,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Log Out',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Alegreya',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                // GestureDetector(
                //   onTap: () {
                //     showDialog(
                //       context: context,
                //       builder: (BuildContext context) {
                //         return AlertDialog(
                //             title: Text(
                //               'Delete Account',
                //               style: TextStyle(
                //                 fontSize: 22,
                //                 fontWeight: FontWeight.bold,
                //                 fontFamily: 'Alegreya',
                //               ),
                //             ),
                //             content: Text(
                //               'Are you sure you want to delete this account? Once deleted, all data associated with this account will be permanently lost.',
                //               style: TextStyle(
                //                 fontSize: 20,
                //                 fontWeight: FontWeight.bold,
                //                 fontFamily: 'Alegreya',
                //               ),
                //             ),
                //             actions: <Widget>[
                //               TextButton(
                //                 child: Text(
                //                   'Cancel',
                //                   style: TextStyle(
                //                     fontSize: 20,
                //                     fontWeight: FontWeight.bold,
                //                     fontFamily: 'Alegreya',
                //                   ),
                //                 ),
                //                 onPressed: () {
                //                   Navigator.of(context).pop();
                //                 },
                //               ),
                //               TextButton(
                //                 //delete
                //                 child: Text(
                //                   'Delete',
                //                   style: TextStyle(
                //                     fontSize: 20,
                //                     fontWeight: FontWeight.bold,
                //                     fontFamily: 'Alegreya',
                //                   ),
                //                 ),
                //                 onPressed: () {
                //                   deleteAccount();
                //                 },
                //               ),
                //             ]
                //         );
                //       },
                //     );
                //   },
                //   child: Text(
                //     'Delete Account',
                //     style: TextStyle(
                //       color: Colors.red,
                //       fontFamily: 'Alegreya',
                //       fontWeight: FontWeight.bold,
                //       fontSize: 20,
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
