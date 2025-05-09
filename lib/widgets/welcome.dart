import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movieapp/constant.dart';
import 'package:movieapp/widgets/fonts.dart';
import 'package:movieapp/widgets/sign_in_page.dart';
import 'package:movieapp/widgets/sign_up_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose(); // Dispose controller to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Allow the body to resize when the keyboard appears
      backgroundColor: appBackgroundColor,
      body: Column(
        children: [
          /// **🟢 Welcome Section at the Top**
          const SizedBox(height: 100), // Space from the top
          SvgPicture.asset(
            'assets/images/splash_icon.svg',
            fit: BoxFit.cover,
            width: 250,
          ),
         
          const SizedBox(
            height: 40,
          ),

          /// **🔵 Tab Layout Positioned at the Bottom**
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 1.9,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: TabBar(
                      controller: tabController,
                      unselectedLabelColor: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.5),
                      labelColor: Theme.of(context).colorScheme.onBackground,
                      tabs: const [
                        Padding(
                          padding: EdgeInsets.all(.0),
                          child: Text(
                            'Sign up',
                            style: TextStyle(color: Colors.white,fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            'Sign in',
                            style: TextStyle(color: Colors.white,fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            'Admin',
                            style: TextStyle(color: buttonColor,fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        SignUp(), // Sign In Content
                        SignIn(), // Sign Up Content
                        Container(), // Admin Content
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
