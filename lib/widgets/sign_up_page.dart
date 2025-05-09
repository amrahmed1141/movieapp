import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/constant.dart';
import 'package:movieapp/services/firebase/database.dart';
import 'package:movieapp/services/locals/shared_preference.dart';
import 'package:movieapp/widgets/custom_text_field.dart';
import 'package:movieapp/widgets/nav_bottom.dart';
import 'package:random_string/random_string.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // Declare controllers and stateful variables here
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the tree
    passwordController.dispose();
    emailController.dispose();
    nameController.dispose();
    super.dispose();
  }

  registration() async {
    // ignore: unnecessary_null_comparison
    if (nameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        emailController.text.isNotEmpty) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                "Register Successfully"), // Message to show in the SnackBar
            duration: Duration(seconds: 2), // Duration of the SnackBar
          ),
        );
        String id = randomAlphaNumeric(10);
        Map<String, dynamic> userData = {
          "name": nameController.text,
          "email": emailController.text,
          'Image':
              "https://firebasestorage.googleapis.com/v0/b/movie-9e1ed.firebasestorage.app/o/profile.jpeg?alt=media&token=b37cab44-7523-4e2a-b2b3-408e1b473886",
          'Id': id,
        };
        await DatabaseService().AddUserDetails(userData, id);
         await SharedPrefercenceHelper().saveUserName(nameController.text);
        await SharedPrefercenceHelper().saveUserEmail(emailController.text);
        await SharedPrefercenceHelper().saveUserId(id);
        await SharedPrefercenceHelper().saveUserImage("https://firebasestorage.googleapis.com/v0/b/movie-9e1ed.firebasestorage.app/o/profile.jpeg?alt=media&token=b37cab44-7523-4e2a-b2b3-408e1b473886");

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => NavigationBottom()));
      } on FirebaseException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  "The password provided is too weak."), // Message to show in the SnackBar
              duration: Duration(seconds: 2), // Duration of the SnackBar
            ),
          );
        } else if (e.code == 'email-already-in-use') {
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      resizeToAvoidBottomInset:
          true, // Allow the UI to resize when the keyboard appears
      body: SafeArea(
        child: SingleChildScrollView(
          // Make the content scrollable
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// **Name Input Field**
                Container(
                  margin: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: MyTextField(
                      controller: nameController,
                      hintText: 'Name',
                      obscureText: false,
                      keyboardType: TextInputType.name,
                      prefixIcon: const Icon(CupertinoIcons.person_fill),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please fill in this field';
                        } else if (val.length > 30) {
                          return 'Name too long';
                        }
                        return null;
                      }),
                ),

                /// **Email Input Field**
                Container(
                  margin: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(CupertinoIcons.mail_solid),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please fill in this field';
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                          .hasMatch(val)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),

                /// **Password Input Field**
                Container(
                  margin: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: obscurePassword,
                    keyboardType: TextInputType.visiblePassword,
                    prefixIcon: const Icon(CupertinoIcons.lock_fill),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please fill in this field';
                      } else if (!RegExp(
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$')
                          .hasMatch(val)) {
                        return 'Please enter a valid password';
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                          iconPassword = obscurePassword
                              ? CupertinoIcons.eye_fill
                              : CupertinoIcons.eye_slash_fill;
                        });
                      },
                      icon: Icon(iconPassword),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                /// **Sign Up Button**
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      registration();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor, // Button color
                    foregroundColor: Colors.white, // Text color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 15), // Button padding
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                    ),
                    elevation: 3, // Button shadow
                  ),
                  child: const Text(
                    "Sign up",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
