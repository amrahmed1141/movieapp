import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movieapp/constant.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final emailController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  resetPassword() async {
    if (_formkey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Check your email for password reset link"),
            duration: Duration(seconds: 2),
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("User Not Found"),
              duration: Duration(seconds: 2),
            ),
          );
        }
        print('Error sending password reset email: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: appBackgroundColor,
        title: const Text(
          ' Password Recovery',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          SvgPicture.asset(
            'assets/images/splash_icon.svg',
            fit: BoxFit.cover,
            width: 250,
          ),
          const SizedBox(
            height: 50,
          ),
          Form(
            key: _formkey,
            child: Column(
              children: [
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.white)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary)),
                      hintStyle: const TextStyle(color: Colors.white38),
                      fillColor: grey,
                      filled: true,
                      labelText: 'Enter Your Email',
                      labelStyle: const TextStyle(color: Colors.white38),
                      prefixIcon: const Icon(Icons.email),
                      prefixIconColor: Colors.white38),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: MaterialButton(
                    onPressed: () {
                      resetPassword();
                    },
                    color: buttonColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 2,
                    padding: const EdgeInsets.all(12),
                    minWidth: double.infinity,
                    child: const Text(
                      'Send Email',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(' we will send you a link to reset your password',
              style: TextStyle(color: Colors.white.withOpacity(0.5))),
        ]),
      ),
    );
  }
}
