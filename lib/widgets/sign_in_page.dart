import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movieapp/constant.dart';
import 'package:movieapp/pages/users/home.dart';
import 'package:movieapp/services/firebase/database.dart';
import 'package:movieapp/services/locals/shared_preference.dart';
import 'package:movieapp/widgets/custom_text_field.dart';
import 'package:movieapp/widgets/fonts.dart';
import 'package:movieapp/widgets/nav_bottom.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String id = '', name = '', image = '';
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool signInRequired = false;
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  String? _errorMsg;

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the tree
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  userLogin() async {
    if (passwordController.text.isNotEmpty && emailController.text.isNotEmpty) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);

        QuerySnapshot querySnapshot =
            await DatabaseService().getUserByEmail(emailController.text);

        name = '${(querySnapshot.docs[0]['name'])}';
        emailController.text = '${(querySnapshot.docs[0]['email'])}';
        id = '${(querySnapshot.docs[0]['Id'])}';
        image = '${(querySnapshot.docs[0]['Image'])}';

        await SharedPrefercenceHelper().saveUserName(name);
        await SharedPrefercenceHelper().saveUserEmail(emailController.text);
        await SharedPrefercenceHelper().saveUserId(id);
        await SharedPrefercenceHelper().saveUserImage(image);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text("Login Successfully"), // Message to show in the SnackBar
            duration: Duration(seconds: 2), // Duration of the SnackBar
          ),
        );
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => NavigationBottom()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          setState(() {
            _errorMsg = 'No user found for that email.';
          });
        } else if (e.code == 'wrong-password') {
          setState(() {
            _errorMsg = 'Wrong password provided for that user.';
          });
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
                    errorMsg: _errorMsg,
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
                    errorMsg: _errorMsg,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Forget Password ?',
                          style: AppFont.lightTextStyle(),
                        )),
                  ],
                ),
                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      userLogin();
                    } // Your button action
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
                    "Sign in",
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
